import ShadowLibrary.Core
import Text.XML.HXT.Core
import Text.XML.HXT.XPath
import Data.List
import Data.List.Utils (replace)
import Text.Regex.Posix
import Text.Printf


extractRecords = extractLinksWithText "//a[contains(@href,'.pdf')]"  -- pary adres-tytuł
                 >>> second (arr $ replace "\r\n            " " ") 
                 >>> first (arr ((++"tr") . init)) 
                 >>> first (extractLinksWithText "//li/a[contains(@href,'.pdf')]")
                 
                 
                 
toShadowItem :: ((String, String), String) -> ShadowItem
toShadowItem ((url, articleTitle), yearlyTitle) =
  (defaultShadowItem url title) {
    originalDate = Just date,
    itype = "periodical",
    format = Just "pdf",
    finalUrl = url
    }
  where title = "Pte " ++ yearlyTitle ++ " " ++ (replace "\r\n" "" (replace "\r\n          " "" articleTitle))
        date = getDate url

getDate url =
  case url =~~ "/(19[0-9][0-9]|20[0-9][0-9])/" :: Maybe [[String]] of
    Just [[_, year]] -> year
    otherwise -> error $ "unexpected url: " ++ url


main = do
    let start = "http://pte.au.poznan.pl"
    let shadowLibrary = ShadowLibrary {logoUrl=Nothing,
                                       lname="Pte.au.poznan",
                                       abbrev="Pte",
                                       lLevel=0,
                                       webpage=start}
    extractItemsStartingFromUrl shadowLibrary start (extractRecords >>> arr toShadowItem)

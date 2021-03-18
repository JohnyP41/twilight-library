import ShadowLibrary.Core
import Text.XML.HXT.Core
import Text.XML.HXT.XPath
import Data.List
import Data.List.Utils (replace)
import Text.Regex.Posix
import Text.Printf

extractRecords = extractLinksWithText "//a[contains(@href,'.htm')]" 
                 >>> second (arr $ replace "\r\n            " " ") 
                 >>> first (extractLinksWithText "//a[contains(@href,'.pdf')]")
                 
                 
toShadowItem :: ((String, String), String) -> ShadowItem
toShadowItem ((url, articleTitle), yearlyTitle) =
  (defaultShadowItem url title) {
    originalDate = Nothing,
    itype = "periodical",
    format = Just "pdf",
    finalUrl = url
    }

  where title = "Pte " ++ yearlyTitle ++ " " ++ (replace "\r\n" "" (replace "\r\n          " "" articleTitle))

main = do
    let start = "http://pte.au.poznan.pl/PTE_left.htm"
    let shadowLibrary = ShadowLibrary {logoUrl=Nothing,
                                        lname="Pte.au.poznan",
                                        abbrev="Pte",
                                        lLevel=0,
                                        webpage="http://pte.au.poznan.pl/"}
    extractItemsStartingFromUrl shadowLibrary start (extractRecords >>> arr toShadowItem)

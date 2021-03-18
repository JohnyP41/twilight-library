{-# LANGUAGE Arrows, NoMonomorphismRestriction #-}
import ShadowLibrary.Core
import Text.XML.HXT.Core
import Text.XML.HXT.XPath
import Data.List
import Data.List.Utils (replace)
import Text.Regex.Posix
import Text.Printf

extractRecords = extractLinksWithText "//a[contains(@href,'.htm')]" 
                 >>> second (arr $ replace "\r\n" "")
                 >>> second (arr $ replace "\n\t\t\t\t\t\t\t\t\t\t\t" "")
                 >>> second (arr $ replace "\n\t\t\t\t\t\t\t\t\t\t" "")
                 >>> first (extractLinksWithText "//a[contains(@href,'.pdf')]")
                 
                 
toShadowItem :: ((String, String), String) -> ShadowItem
toShadowItem ((url, articleTitle), yearlyTitle) =
  (defaultShadowItem url title) {
    originalDate = extractMonthAndYear title,
    itype = "periodical",
    format = Just "pdf",
    finalUrl = url,
    description = extractFileSize title
    }
  where title = "Pte " ++ yearlyTitle ++ " " ++ (replace "\r\n" "" (replace "\r\n          " "" articleTitle))

extractMonthAndYear :: String -> Maybe String
extractMonthAndYear n =
  case n =~~ ("[a-z]* (1[6789]|20)[0-9][0-9]" :: String) of
    Just year -> Just year
    otherwise -> Nothing

extractFileSize :: String -> Maybe String
extractFileSize n =
  case n =~~ ("([0-9]*)\\.([0-9]*) (B|kB|MB)" :: String) of
    Just fileSize -> Just fileSize
    otherwise -> Nothing 


main = do
    let start = "http://pte.au.poznan.pl/PTE_left.htm"
    let shadowLibrary = ShadowLibrary {logoUrl=Nothing,
                                        lname="Pte.au.poznan",
                                        abbrev="Pte",
                                        lLevel=0,
                                        webpage="http://pte.au.poznan.pl/"}
    extractItemsStartingFromUrl shadowLibrary start (extractRecords >>> arr toShadowItem)

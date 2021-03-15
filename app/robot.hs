import ShadowLibrary.Core
import Text.XML.HXT.Core
import Text.XML.HXT.XPath
import Data.List
import Data.List.Utils (replace)
import Text.Regex.Posix
import Text.Printf
--import Text.XML.HXT.Curl


extractRecords = extractLinksWithText "//a[@class='hermes50-1']"  -- pary adres-tytuł
                 >>> second (arr $ replace "\r\n            " " ") -- czyścimy drugi element pary, czyli tytuł z niepotrzebnych białych znaków
                 >>> first (arr ((++"tr") . init))  -- modyfikujemy pierwszy element pary, czyli adres URL
                 >>> first (extractLinksWithText "//li/a[contains(@href,'.pdf')]") -- pobieramy stronę z adresu URL i wyciągamy linki z tej strony pasujące do wyrażenia XPathowego
                 -- ostatecznie wyjdą trójki ((adres URL, tytuł artykułu), tytuł rocznika)

-- ... a tutaj te trójki przerabiamy do docelowej struktury ShadowItem
toShadowItem :: ((String, String), String) -> ShadowItem
toShadowItem ((url, articleTitle), yearlyTitle) =
  (defaultShadowItem url title) {
    originalDate = Just date,
    itype = "periodical",
    format = Just "pdf",
    finalUrl = url
    }
  where title = "hermes50-1" ++ yearlyTitle ++ " " ++ (replace "\r\n" "" (replace "\r\n          " "" articleTitle))
        date = getDate url

getDate url =
  case url =~~ "/(19[0-9][0-9]|20[0-9][0-9])/" :: Maybe [[String]] of
    Just [[_, year]] -> year
    otherwise -> error $ "unexpected url: " ++ url


main = do
    let start = "http://chomikuj.pl/hermes50-1"
    let shadowLibrary = ShadowLibrary {logoUrl=Nothing,
                                       lname="hermes50-1",
                                       abbrev="hermes50-1",
                                       lLevel=0,
                                       webpage=start}
    extractItemsStartingFromUrl shadowLibrary start (extractRecords >>> arr toShadowItem)

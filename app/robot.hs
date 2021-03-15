import ShadowLibrary.Core
import Text.XML.HXT.Core
import Text.XML.HXT.XPath
import Text.XML.HXT.Curl
import Data.List
import Data.List.Utils (replace)
import Text.Regex.Posix
import Text.Printf


extractRecords = extractLinksWithText "//a[@class='roczniki']"  -- pary adres-tytuł
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
  where title = "Almanach Muszyny " ++ yearlyTitle ++ " " ++ (replace "\r\n" "" (replace "\r\n          " "" articleTitle))
        date = getDate url

getDate url =
  case url =~~ "/(19[0-9][0-9]|20[0-9][0-9])/" :: Maybe [[String]] of
    Just [[_, year]] -> year
    otherwise -> error $ "unexpected url: " ++ url


main = do
    let start = "http://www.almanachmuszyny.pl/"
    let shadowLibrary = ShadowLibrary {logoUrl=Nothing,
                                       lname="Almanach Muszyny",
                                       abbrev="AlmMusz",
                                       lLevel=0,
                                       webpage=start}
    extractItemsStartingFromUrl shadowLibrary start (extractRecords >>> arr toShadowItem)

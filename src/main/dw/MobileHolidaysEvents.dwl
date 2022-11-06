%dw 2.0

/**
* Converts informed year to Easter date. Uses the Algorithm Meeus/Jones/Butcher
*
* === Parameters
*
* [%header, cols="1,1,3"]
* |===
* | Name | Type | Description
* | `date` | Date | Used only the year to calculate the day and month of Easter
* |===
*
* === Example
*
* return Date of Easter
*
* ==== Source
*
* [source,DataWeave,linenums]
* ----
* %dw 2.0
* output application/java
* import yearToEasterDate from MobileHolidaysEvents
* ---
*  yearToEasterDate("2023-11-07" as Date)
* ----
*
* ==== Output
*
* [source,String,linenums]
* ----
* "2023-04-09"
* ----
*
*/
fun yearToEasterDate(date: Date): Date = do {
  var year = (date as String {format: "yyyy"}) as Number
  var a = year mod 19
  var b = floor(year / 100)
  var c = year mod 100
  var d = floor(b / 4)
  var e = b mod 4
  var f = floor((b + 8) / 25)
  var g = floor((b - f + 1) / 3)
  var h = (19 * a + b - d - g + 15) mod 30
  var i = floor(c / 4)
  var k = c mod 4
  var l = (32 + 2 * e + 2 * i - h - k) mod 7
  var m = floor((a + 11 * h + 22 * l) / 451)
  var month = floor((h + l - 7 * m + 114) / 31)
  var day = 1 + (h + l - 7 * m + 114) mod 31
  var response = year as String ++ "-" ++ month as String {format: "00"} ++ "-" ++ day as String {format: "00"}
  ---
  response as Date
}

/**
* Converts informed year to Carnival date
*
* === Parameters
*
* [%header, cols="1,1,3"]
* |===
* | Name | Type | Description
* | `date` | Date | Used only the year to calculate the day and month of Carnival
* |===
*
* === Example
*
* return Date of Carnival.
*
* ==== Source
*
* [source,DataWeave,linenums]
* ----
* %dw 2.0
* output application/java
* import yearToCarnivalDate from MobileHolidaysEvents
* ---
* yearToCarnivalDate("2023-02-17" as Date)
* ----
*
* ==== Output
*
* [source,String,linenums]
* ----
* "2023-02-21"
* ----
*
*/
fun yearToCarnivalDate(date: Date): Date = yearToEasterDate(date) - |P47D|

/**
* Converts informed year to Good Friday date 
*
* === Parameters
*
* [%header, cols="1,1,3"]
* |===
* | Name | Type | Description
* | `date` | Date | Used only the year to calculate the day and month of Good Friday
* |===
*
* === Example
*
* return Date of Good Friday.
*
* ==== Source
*
* [source,DataWeave,linenums]
* ----
* %dw 2.0
* output application/json
* import yearToGoodFridayDate from MobileHolidaysEvents
* ---
* yearToGoodFridayDate("2023-02-17" as Date)
* ----
*
* ==== Output
*
* [source,String,linenums]
* ----
* "2023-04-07"
* ----
*
*/
fun yearToGoodFridayDate(date: Date): Date = yearToEasterDate(date) - |P2D|

/**
* Converts informed year to Corpus Christi date
*
* === Parameters
*
* [%header, cols="1,1,3"]
* |===
* | Name | Type | Description
* | `date` | Date | Used only the year to calculate the day and month of Corpus Christi
* |===
*
* === Example
*
* return Date of Corpus Christi 
*
* ==== Source
*
* [source,DataWeave,linenums]
* ----
* %dw 2.0
* output application/java
* import yearToCorpusChristiDate from MobileHolidaysEvents
* ---
* yearToCorpusChristiDate("2023-02-17" as Date)
* ----
*
* ==== Output
*
* [source,String,linenums]
* ----
* "2023-06-08"
* ----
*
*/
fun yearToCorpusChristiDate(date: Date): Date = yearToEasterDate(date) + |P60D|
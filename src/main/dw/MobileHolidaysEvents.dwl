%dw 2.0

/**
* Describes the `yearToEasterDate` function purpose.
*
* === Parameters
*
* [%header, cols="1,1,3"]
* |===
* | Name | Type | Description
* | `date` | Date | 
* |===
*
* === Example
*
* This example shows how the `yearToEasterDate` function behaves under different inputs.
*
* ==== Source
*
* [source,DataWeave,linenums]
* ----
* %dw 2.0
* output application/json
* ---
*
*
* ----
*
* ==== Output
*
* [source,Json,linenums]
* ----
*
* ----
*
*/
fun yearToEasterDate(date: Date) = do {
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
  var response = year ++ "-" ++ month as String {format: "00"} ++ "-" ++ day as String {format: "00"}
  ---
  response as Date
}

/**
* Describes the `yearToCarnivalDate` function purpose.
*
* === Parameters
*
* [%header, cols="1,1,3"]
* |===
* | Name | Type | Description
* | `date` | Date | 
* |===
*
* === Example
*
* This example shows how the `yearToCarnivalDate` function behaves under different inputs.
*
* ==== Source
*
* [source,DataWeave,linenums]
* ----
* %dw 2.0
* output application/json
* ---
*
*
* ----
*
* ==== Output
*
* [source,Json,linenums]
* ----
*
* ----
*
*/
fun yearToCarnivalDate(date: Date) = yearToEasterDate(date) - |P47D|

fun yearToGoodFridayDate(date: Date) = yearToEasterDate(date) - |P2D|

fun yearToCorpusChristiDate(date: Date) =
  yearToEasterDate(date) + |P60D|
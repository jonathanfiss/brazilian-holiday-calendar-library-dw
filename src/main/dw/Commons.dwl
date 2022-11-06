%dw 2.0
import * from MobileHolidaysEvents

var fixedHolidays: Array = [
    "01-01", //Universal Day
    "04-21", //Tiradentes
    "05-01", ///Labour Day
    "09-07", //Independence Day
    "10-12", //Our Lady of Conception Aparecida Day
    "11-02", //All Souls Day
    "11-15", //Proclamation of the Republic Day
    "12-25" //Christmas Day
]

/**
* Converts informed date to month and day
*
* === Parameters
*
* [%header, cols="1,1,3"]
* |===
* | Name | Type | Description
* | `date` | Date | date used to extract the month and day
* |===
*
* === Example
*
* This example shows how the `monthDay` function behaves under different inputs.
*
* ==== Source
*
* [source,DataWeave,linenums]
* ----
* %dw 2.0
* output application/java
* import monthDay from Commons
* ---
* monthDay("2076-02-17" as Date)
* ----
*
* ==== Output
*
* [source,String,linenums]
* ----
* "02-17"
* ----
*
*/
fun monthDay(date: Date): String = date as String {format: "MM-dd"}

/**
* Check if the date entered is a national holiday. Includes all fixed and mobile holidays.
* __Note: Carnival ans Corpus Christi are not holidays. They are optional day off__
*
* === Parameters
*
* [%header, cols="1,1,3"]
* |===
* | Name | Type | Description
* | `date` | Date | Date to be verified
* |===
*
* === Example
*
* Returns true if informed date is a national public holiday.
*
* ==== Source
*
* [source,DataWeave,linenums]
* ----
* %dw 2.0
* output application/json
* import isNationalHoliday from Commons
* ---
* {
*  isNationalHoliday: isNationalHoliday("2023-01-01" as Date),
*  isNotNationalHoliday: isNationalHoliday("2023-01-05" as Date) 
* }
*
* ----
*
* ==== Output
*
* [source,Json,linenums]
* ----
* {
*  isNationalHoliday: true,
*  isNotNationalHoliday: false 
* }
* ----
*
*/
fun isNationalHoliday(date: Date): Boolean = (fixedHolidays contains monthDay(date)) or (yearToGoodFridayDate(date) == date as Date)

/**
* Check if the date entered is a business day
*
* === Parameters
*
* [%header, cols="1,1,3"]
* |===
* | Name | Type | Description
* | `date` | Date | Date to be verified
* | `includeSaturday` | Boolean | Normally Saturday is not a business day, but there are situations that it should be considered. In these cases set the parameter to true
* |===
*
* === Example
*
* Returns true if informed date is a business day
*
* ==== Source
*
* [source,DataWeave,linenums]
* ----
* %dw 2.0
* output application/json
* import isBusinessDay from Commons
* ---
* {
*  isBusinessDay: isBusinessDay("2023-11-04" as Date),
*  isBusinessDayIncludeSaturday: isBusinessDay("2023-11-05" as Date, true),
*  isNotBusinessDayHoliday: isBusinessDay("2023-11-15" as Date),
*  isNotBusinessDay: isBusinessDay("2023-11-06" as Date) 
* }
* ----
*
* ==== Output
*
* [source,Json,linenums]
* ----
* {
*  isBusinessDay: true,
*  isBusinessDayIncludeSaturday: true,
*  isNotBusinessDayHoliday: false,
*  isNotBusinessDay: false 
* }
* ----
*
*/
fun isBusinessDay(date: Date, includeSaturday: Boolean = false): Boolean = do {
  var dayOfWeek = date as String {format: "e"}
  ---
  if ((!includeSaturday) and dayOfWeek == "7")
    false
  else if (dayOfWeek == "1")
    false
  else !(isNationalHoliday(date))
}



/**
* Maps all dates between dates
*
* === Parameters
*
* [%header, cols="1,1,3"]
* |===
* | Name | Type | Description
* | `start` | Date | Date start the map
* | `endInclusive` | Date | Date end included in the map
* |===
*
* === Example
*
* This example shows how the `allDates` function behaves under different inputs.
*
* ==== Source
*
* [source,DataWeave,linenums]
* ----
* %dw 2.0
* output application/json
* import allDates from Commons
* ---
* allDates("2023-02-17" as Date,"2023-02-25" as Date)
* ----
*
* ==== Output
*
* [source,Json,linenums]
* ----
* [
*   "2023-02-17",
*   "2023-02-18",
*   "2023-02-19",
*   "2023-02-20",
*   "2023-02-21",
*   "2023-02-22",
*   "2023-02-23",
*   "2023-02-24",
*   "2023-02-25"
* ]
* ----
*
*/
fun allDates(start: Date, endInclusive: Date): Array<Date> = do {
  var numberOfDays: Array = (1 to daysBetween(start, endInclusive + |P1D|)) as Array
  ---
  numberOfDays map ((item, index) -> start + ("P$(index)D" as Period))
}
   

/**
* Count the number of days in the informed date range
*
* === Parameters
*
* [%header, cols="1,1,3"]
* |===
* | Name | Type | Description
* | `start` | Date | Start date (inclusive)
* | `endInclusive` | Date | End date (inclusive)
* | `includeSaturday` | Boolean | Normally Saturday is not a bussiness day, but there are situations that it should be considered. In these cases set the parameter to true
* |===
*
* === Example
*
* Returns the number of business days in the informed date range.
*
* ==== Source
*
* [source,DataWeave,linenums]
* ----
* %dw 2.0
* output application/json
* import countBusinessDays from Commons
* ---
* {
*  countBusinessDays: countBusinessDays("2023-02-17" as Date,"2023-02-25" as Date),
*  countBusinessDaysIncludeSaturday: countBusinessDays("2023-02-17" as Date,"2023-02-25" as Date, true) 
* }
* ----
*
* ==== Output
*
* [source,Json,linenums]
* ----
* {
*  countBusinessDays: 6,
*  countBusinessDaysIncludeSaturday: 8) 
* }
* ----
*
*/
  fun countBusinessDays(start: Date, endInclusive: Date, includeSaturday: Boolean = false): Number =
  sizeOf(allDates(start, endInclusive) filter ((item, index) -> isBusinessDay(item, includeSaturday)))
  
/**
* Get the next business day
*
* === Parameters
*
* [%header, cols="1,1,3"]
* |===
* | Name | Type | Description
* | `date` | Date | date (not included)
* | `includeSaturday` | Boolean | Normally Saturday is not a business day, but there are situations that it should be considered. In these cases set the parameter to true
* |===
*
* === Example
*
* Returns the next business day
*
* ==== Source
*
* [source,DataWeave,linenums]
* ----
* %dw 2.0
* output application/json
* import allDates from Commons
* ---
* {
*  nextBusinessDay: nextBusinessDay("2023-02-17" as Date),
*  nextBusinessDayIncludeSaturday: nextBusinessDay("2023-02-17" as Date, true) 
* }
* ----
*
* ==== Output
*
* [source,Json,linenums]
* ----
* {
*  nextBusinessDay: "2023-02-20",
*  nextBusinessDayIncludeSaturday: "2023-02-18" 
* }
* ----
*
*/
@TailRec()
fun nextBusinessDay(date: Date, includeSaturday: Boolean = false): Date = do{
    var result = date + |P1D|
    ---
    if(!isBusinessDay(result, includeSaturday)) nextBusinessDay(result) else result
}

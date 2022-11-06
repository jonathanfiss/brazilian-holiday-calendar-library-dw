%dw 2.0
import * from Commons
import * from MobileHolidaysEvents

/**
* Check if the date entered is a banking holiday. Include all fixed and mobile holidays.
* __Note: Carnival, Carnival Monday and Corpus Christi are not holidays, but traditionally banks close on these days, according to date from [Febraban](https://feriadosbancarios.febraban.org.br/)__
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
* Retuns true if informed date is a banking holiday
*
* ==== Source
*
* [source,DataWeave,linenums]
* ----
* %dw 2.0
* output application/json
* import isBankingHoliday from BankingBusiness
* ---
* {
*  isBankingHoliday: isBankingHoliday("2023-01-01" as Date),
*  isNotBankingHoliday: isBankingHoliday("2023-06-08" as Date) 
* }
* ----
*
* ==== Output
*
* [source,Json,linenums]
* ----
* {
*  isBankingHoliday: true,
*  isNotBankingHoliday: false 
* }
* ----
*
*/
fun isBankingHoliday(date: Date): Boolean = do {
  var nationalHoliday = isNationalHoliday(date)
  var carnival = yearToCarnivalDate(date)
  var carnivalMonday = carnival - |P1D|
  ---
  nationalHoliday or (carnival == date as Date) or (carnivalMonday == date as Date) or (yearToCorpusChristiDate(date) == date as Date)
}

/**
* Check if the date entered is a banking business day
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
* returns true if informed date is a bank business day
*
* ==== Source
*
* [source,DataWeave,linenums]
* ----
* %dw 2.0
* output application/json
* import isBankingBusinessDay from BankingBusiness
* ---
* {
*  isBankingBusinessDay: isBankingBusinessDay("2023-11-04" as Date),
*  isBankingBusinessDayIncludeSaturday: isBankingBusinessDay("2023-11-05" as Date, true),
*  isNotBankingBusinessDayHoliday: isBankingBusinessDay("2023-11-15" as Date),
*  isNotBankingBusinessDay: isBankingBusinessDay("2023-11-06" as Date) 
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
fun isBankingBusinessDay(date: Date): Boolean = do {
  var dayOfWeek = date as String {format: "e"}
  ---
  if (dayOfWeek == "7")
    false
  else if (dayOfWeek == "1")
    false
  else !(isBankingHoliday(date))
}

/**
* Count the number of banking business days in the informed date range
*
* === Parameters
*
* [%header, cols="1,1,3"]
* |===
* | Name | Type | Description
* | `start` | Date | Start date (inclusive)
* | `endInclusive` | Date | end date (inclusive)
* |===
*
* === Example
*
* Returns the number of banking business days in the informed date range
*
* ==== Source
*
* [source,DataWeave,linenums]
* ----
* %dw 2.0
* output application/json
* import countBankingBusinessDays from BankingBusiness
* ---
* countBankingBusinessDays("2023-02-17" as Date,"2023-02-25" as Date)
* ----
*
* ==== Output
*
* [source,Number,linenums]
* ----
* 4 
* ----
*
*/
fun countBankingBusinessDays(start: Date, endInclusive: Date): Number =
  sizeOf(allDates(start, endInclusive) filter ((item, index) -> isBankingBusinessDay(item)))

/**
* Get the next banking business day
*
* === Parameters
*
* [%header, cols="1,1,3"]
* |===
* | Name | Type | Description
* | `date` | Date | date
* |===
*
* === Example
*
* return the next business day
*
* ==== Source
*
* [source,DataWeave,linenums]
* ----
* %dw 2.0
* output application/json
* ---
* nextBankingBusinessDay("2023-02-17" as Date)
* ----
*
* ==== Output
*
* [source,String,linenums]
* ----
* "2023-02-22"
* ----
*
*/
@TailRec()
fun nextBankingBusinessDay(date: Date): Date = do{
    var result = date + |P1D|
    ---
    if(!isBankingBusinessDay(result)) nextBankingBusinessDay(result) else result
}
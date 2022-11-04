%dw 2.0
import * from MobileHolidaysEvents

var fixedHolidays = [
    "01-01", //Universal Day
    "04-21", //Tiradentes
    "05-01", ///Labour Day
    "09-07", //Independence Day
    "10-12", //Our Lady of Conception Aparecida Day
    "11-02", //All Souls Day
    "11-15", //Proclamation of the Republic Day
    "12-25" //Christmas Day
]

fun monthDay(date: Date): String = date as String {format: "MM-dd"}

fun isNationalHoliday(date: Date): Boolean = (fixedHolidays contains monthDay(date)) or (yearToGoodFridayDate(date) == date as Date)

fun isBankingHoliday(date: Date): Boolean = do {
  var nationalHoliday = isNationalHoliday(date)
  var carnival = yearToCarnivalDate(date)
  var carnivalMonday = carnival - |P1D|
  ---
  nationalHoliday or (carnival == date as Date) or (carnivalMonday == date as Date) or (yearToCorpusChristiDate(date) == date as Date)
}

fun isBusinessDay(date: Date, includeSaturday: Boolean = false): Boolean = do {
  var dayOfWeek = date as String {format: "EEEE"}
  ---
  if ((!includeSaturday) and dayOfWeek == "Saturday")
    false
  else if (dayOfWeek == "Sunday")
    false
  else if (isNationalHoliday(date))
    false
  else
    true
}

fun isBankingBusinessDay(date: Date): Boolean = do {
  var dayOfWeek = date as String {format: "EEEE"}
  ---
  if (dayOfWeek == "Saturday")
    false
  else if (dayOfWeek == "Sunday")
    false
  else if (isBankingHoliday(date))
    false
  else
    true
}

fun allDates(start: Date, endInclusive: Date): Array<Date> =
  1 to daysBetween(start, endInclusive + |P1D|) map ((item, index) -> start + ("P$(index)D" as Period))

  fun countBusinessDays(start: Date, endInclusive: Date, includeSaturday: Boolean = false): Number =
  sizeOf(allDates(start, endInclusive) filter ((item, index) -> isBusinessDay(item, includeSaturday)))

fun countBankingBusinessDays(start: Date, endInclusive: Date): Number =
  sizeOf(allDates(start, endInclusive) filter ((item, index) -> isBankingBusinessDay(item)))

fun nextBusinessDay(date: Date, includeSaturday: Boolean = false): Date = do{
    var result = date + |P1D|
    ---
    if(!isBusinessDay(result, includeSaturday)) nextBusinessDay(result) else result
}

fun nextBankingBusinessDay(date: Date): Date = do{
    var result = date + |P1D|
    ---
    if(!isBankingBusinessDay(result)) nextBankingBusinessDay(result) else result
}
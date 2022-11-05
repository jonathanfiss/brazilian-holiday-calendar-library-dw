%dw 2.0
import * from Commons
import * from MobileHolidaysEvents

fun isBankingHoliday(date: Date): Boolean = do {
  var nationalHoliday = isNationalHoliday(date)
  var carnival = yearToCarnivalDate(date)
  var carnivalMonday = carnival - |P1D|
  ---
  nationalHoliday or (carnival == date as Date) or (carnivalMonday == date as Date) or (yearToCorpusChristiDate(date) == date as Date)
}

fun isBankingBusinessDay(date: Date): Boolean = do {
  var dayOfWeek = date as String {format: "e"}
  ---
  if (dayOfWeek == "7")
    false
  else if (dayOfWeek == "1")
    false
  else !(isBankingHoliday(date))
}

fun countBankingBusinessDays(start: Date, endInclusive: Date): Number =
  sizeOf(allDates(start, endInclusive) filter ((item, index) -> isBankingBusinessDay(item)))

@TailRec()
fun nextBankingBusinessDay(date: Date): Date = do{
    var result = date + |P1D|
    ---
    if(!isBankingBusinessDay(result)) nextBankingBusinessDay(result) else result
}
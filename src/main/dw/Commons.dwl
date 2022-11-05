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

fun monthDay(date: Date): String = date as String {format: "MM-dd"}

fun isNationalHoliday(date: Date): Boolean = (fixedHolidays contains monthDay(date)) or (yearToGoodFridayDate(date) == date as Date)

fun isBusinessDay(date: Date, includeSaturday: Boolean = false): Boolean = do {
  var dayOfWeek = date as String {format: "e"}
  ---
  if ((!includeSaturday) and dayOfWeek == "7")
    false
  else if (dayOfWeek == "1")
    false
  else !(isNationalHoliday(date))
}



fun allDates(start: Date, endInclusive: Date): Array<Date> = do {
  var numberOfDays: Array = (1 to daysBetween(start, endInclusive + |P1D|)) as Array
  ---
  numberOfDays map ((item, index) -> start + ("P$(index)D" as Period))
}
   

  fun countBusinessDays(start: Date, endInclusive: Date, includeSaturday: Boolean = false): Number =
  sizeOf(allDates(start, endInclusive) filter ((item, index) -> isBusinessDay(item, includeSaturday)))
  
@TailRec()
fun nextBusinessDay(date: Date, includeSaturday: Boolean = false): Date = do{
    var result = date + |P1D|
    ---
    if(!isBusinessDay(result, includeSaturday)) nextBusinessDay(result) else result
}

%dw 2.0
import * from dw::test::Tests
import * from dw::test::Asserts

import * from Commons
---
"Commons" describedBy [
    "monthDay" describedBy [
        "Must convert to MM-dd" in do {
            monthDay("2022-11-05" as Date) must equalTo("11-05")
        },
    ],
    "isNationalHoliday" describedBy [
        "Must validate if it is not a holiday" in do {
            isNationalHoliday("2022-11-05" as Date) must equalTo(false)
        },
        "Must validate if it is a holiday" in do {
            isNationalHoliday("2022-11-15" as Date) must equalTo(true)
        },
        "Must validate if it is a Friday holiday" in do {
            isNationalHoliday("2023-04-07" as Date) must equalTo(true)
        },
    ],
    "isBusinessDay" describedBy [
        "Must validate if a working day, when it is Saturday" in do {
            isBusinessDay("2022-11-05" as Date) must equalTo(false)
        },
        "Must validate if it is a business day, considering Saturday" in do {
            isBusinessDay("2022-11-05" as Date, true) must equalTo(true)
        },
        "Must validate if a working day, when it is Sunday" in do {
            isBusinessDay("2022-11-06" as Date) must equalTo(false)
        },
        "Must validate if it's a business day, when it's a holiday" in do {
            isBusinessDay("2022-12-25" as Date) must equalTo(false)
        },
    ],
    "allDates" describedBy [
        "Must return an array of dates" in do {
            allDates("2022-12-01" as Date, "2022-12-25" as Date) must beArray() 
        },
    ],
    "countBusinessDays" describedBy [
        "Must count the number of working days between the dates" in do {
            countBusinessDays("2022-12-01" as Date, "2022-12-25" as Date) must equalTo(17)
        },
    ],
    "nextBusinessDay" describedBy [
        "Must return next business day" in do {
            nextBusinessDay("2022-11-04" as Date) must equalTo("2022-11-07" as Date)
        },
        "Must return the next business day, considering Saturday business day" in do {
            nextBusinessDay("2022-11-04" as Date, true) must equalTo("2022-11-05" as Date)
        },
    ],
]

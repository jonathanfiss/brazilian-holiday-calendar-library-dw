%dw 2.0
import * from dw::test::Tests
import * from dw::test::Asserts

import * from MobileHolidaysEvents
---
"MobileHolidaysEvents" describedBy [
    "yearToEasterDate" describedBy [
        "Must calculate what day Easter will be" in do {
            yearToEasterDate("2023-01-01" as Date) must equalTo("2023-04-09" as Date)
        },
    ],
    "yearToCarnivalDate" describedBy [
        "Must calculate on what day will Carnival be" in do {
            yearToCarnivalDate("2023-01-01" as Date) must equalTo("2023-02-21" as Date)
        },
    ],
    "yearToGoodFridayDate" describedBy [
        "Must calculate what day will be Good Friday" in do {
            yearToGoodFridayDate("2023-01-01" as Date) must equalTo("2023-04-07" as Date)
        },
    ],
    "yearToCorpusChristiDate" describedBy [
        "Must calculate what day it will be Corpus Christi" in do {
            yearToCorpusChristiDate("2023-01-01" as Date) must equalTo("2023-06-08" as Date)
        },
    ],
]

%dw 2.0
import * from dw::test::Tests
import * from dw::test::Asserts

import * from BankingBusiness
---
"BankingBusiness" describedBy [
    "isBankingHoliday" describedBy [
        "Must validate if it is not a holiday" in do {
            isBankingHoliday("2022-11-04" as Date) must equalTo(false)
        },
        "Must validate if it is a holiday" in do {
            isBankingHoliday("2022-11-15" as Date) must equalTo(true)
        },
        "Must validate if it is a carnival holiday" in do {
            isBankingHoliday("2023-02-21" as Date) must equalTo(true)
        },
        "Must validate if it is a Carnival Monday holiday" in do {
            isBankingHoliday("2023-02-20" as Date) must equalTo(true)
        },
    ],
    "isBankingBusinessDay" describedBy [
        "Must validate if a working day" in do {
            isBankingBusinessDay("2022-11-04" as Date) must equalTo(true)
        },
        "Must validate if a working day, when it is Saturday" in do {
            isBankingBusinessDay("2022-11-05" as Date) must equalTo(false)
        },
        "Must validate if a working day, when it is Sunday" in do {
            isBankingBusinessDay("2022-11-06" as Date) must equalTo(false)
        },
        "Must validate if it's a business day, when it's a Carnival" in do {
            isBankingBusinessDay("2023-02-21" as Date) must equalTo(false)
        },
    ],
    "countBankingBusinessDays" describedBy [
        "Must count the number of working days between the dates" in do {
            countBankingBusinessDays("2022-02-01" as Date, "2022-03-01" as Date) must equalTo(19)
        },
    ],
    "nextBankingBusinessDay" describedBy [
        "Must return next business day" in do {
            nextBankingBusinessDay("2023-02-17" as Date) must equalTo("2023-02-22" as Date)
        },
    ],
]

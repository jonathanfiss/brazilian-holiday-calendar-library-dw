%dw 2.0
import * from dw::test::Tests
import * from dw::test::Asserts

import * from MyModule
---
"MyModule" describedBy [
    "monthDay" describedBy [
        "It should do something" in do {
            monthDay("2022-11-04") must equalTo("11-04")
        },
    ],
    "isNationalHoliday" describedBy [
        "It should do something" in do {
            isNationalHoliday("2022-09-07") must equalTo(true)
        },
        "It should do something" in do {
            isNationalHoliday("2022-08-07") must equalTo(false)
        },
    ],
]

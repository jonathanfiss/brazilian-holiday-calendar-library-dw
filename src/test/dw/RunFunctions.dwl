/**
* This mapping won't be shared through your library, but you can use it to try out your module and create integration tests.
*/
%dw 2.0
output application/json
var dayOfWeek = ("2022-11-05" as Date) as String {format: "e"}
import * from BankingBusiness
---
nextBankingBusinessDay("2023-02-17" as Date)
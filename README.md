# MobilityTicketing: Lecture 2 starter

Submitted commit: [eca9d1b](https://github.com/Claus0200/mobilityticketing-lecture-2-starter/commit/eca9d1bab3918c56c626af81034daecbfd235292)
Setup and reset instructions: [link](setup.md)

## Where to find the work
Lecture 1: model, workload map and queries: [link](https://github.com/Claus0200/mobilityticketing-lecture-1-starter)
Lecture 2: constraints and tests: [link](https://github.com/Claus0200/mobilityticketing-lecture-2-starter)
Lecture 3: reporting experiment and comparison: [link](https://github.com/Claus0200/mobilityticketing-lecture-3-starter)
Lecture 4: migration stages and verification: [link](https://github.com/Claus0200/mobilityticketing-lecture-4-starter)

## Two decisions worth discussing

### Use NOT NULL with CHECK constraints

I chose to add NOT NULL to columns where a value is required, instead of relying only on CHECK constraints. The alternative was to use only CHECK constraints to validate the values. The reason for that is that a CHECK constraint passes when the expression evaluates to TRUE or NULL. This means a row could still contain NULL even if the CHECK condition would reject an invalid value. Adding NOT NULL makes sure that a required value must actually be present before the CHECK constraint is applied.

This fits MobilityTicketing because fields such as status, price and currency should not be missing from a valid ticket or payment.

The relevant evidence is the NOT NULL constraints and the constraint tests in the Lecture 2 work.

### Make captured payment references unique

I chose to make external_payment_reference unique only for payments with status Captured. The alternative was to make the external payment reference unique for every payment regardless of its status. The reason for this is that the important business rule is that two captured payments should not use the same external payment reference. Failed or other non-captured payment attempts do not need to prevent the same reference from being used again.

This fits MobilityTicketing because a payment can fail and be retried, while a captured payment represents a completed payment that should not be duplicated.

The relevant evidence is [payments_captured_external_reference_unique](database/postgres/migrations/012_ticketing_integrity.sql) and the Lecture 2 tests for duplicate payment references.


## One limitation or open question

One limitation is that the tests cover the constraints and cases identified for the current MobilityTicketing schema, but they do not guarantee that every possible invalid combination has been tested.

The tests show that the specific constraints behave correctly for the cases tried, but there could still be edge cases that are not covered by the test data.

The next step would be to review the business rules for each table and add tests for any cases that are not currently covered.
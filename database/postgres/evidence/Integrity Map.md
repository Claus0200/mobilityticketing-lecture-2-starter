# Integrity map

| Invariant | Affected tables and columns | Current protection | Missing protection or limitation | Expected failure behaviour | Evidence |
| --- | --- | --- | --- | --- | --- |
| Trip capacity and reserved seats must be non-negative, and reserved seats cannot exceed capacity | `trips.capacity`, `trips.reserved_seats` | `CHECK` constraints `trips_capacity_non_negative` and `trips_reserved_seats_valid` | No protection outside the database is required for this invariant | Invalid `INSERT`/`UPDATE` is rejected | Negative tests 1–3 |
| Tickets must reference existing users, trips, and products | `tickets.user_id`, `tickets.trip_id`, `tickets.product_code` | Foreign keys `tickets_user_fk`, `tickets_trip_fk`, `tickets_product_fk` | The database only verifies that the referenced record exists | Ticket write is rejected when a referenced record does not exist | Negative tests 4, 10 and 11 |
| Ticket prices must be non-negative and currencies must be present and correctly formatted | `tickets.price`, `tickets.currency` | `tickets_price_non_negative`, `tickets_currency_format`, and `NOT NULL` | Currency format only checks that the value has three characters; it does not verify that the currency is a real/allowed currency | Invalid price, missing currency, or incorrectly formatted currency is rejected | Negative tests 5 and 7 |
| Ticket validity period must have an end time equal to or later than the start time | `tickets.valid_from_utc`, `tickets.valid_to_utc` | `tickets_validity_window_valid` `CHECK` constraint | Does not verify that the ticket is being used within the validity period | A ticket with an invalid time range is rejected | Negative tests 6 and 8 |
| Ticket codes must be unique | `tickets.ticket_code` | `tickets_ticket_code_unique` `UNIQUE` constraint | Uniqueness is global rather than scoped to a particular operator or product | Duplicate ticket code is rejected | Negative test 9 |
| Payments must reference an existing ticket and contain valid financial data | `payments.ticket_id`, `payments.amount`, `payments.currency`, `payments.status` | Foreign key, `CHECK` constraints and `NOT NULL` | Does not verify that payment amount matches the ticket price | Invalid payment write is rejected | Negative tests 12–15 |
| Validation must refer to the exact ticket identity | `validations.ticket_id`, `validations.ticket_code` | Composite foreign key `validations_ticket_identity_fk` | Validation result itself is not checked against the ticket's current status or validity period | Validation with a non-matching ticket/code pair is rejected | Negative test 18 |

## Issue register

### Issue 1

- Evidence: Negative test 7 shows that `tickets.currency` is protected by `tickets_currency_format`, which only checks the length of the value.
- Problem: A three-character value is accepted even if it is not a valid currency code.
- Consequence: Invalid currency values could be stored in tickets and payments.
- Specific improvement: Use a dedicated currency reference table and a foreign key, or restrict the allowed currency codes with a suitable constraint.
- Open question: Should the system support only a fixed set of currencies such as DKK and EUR, or should additional currencies be supported?

### Issue 2

- Evidence: The validation identity is protected by the composite foreign key, but there is no constraint shown that checks whether a ticket is currently valid or already cancelled/expired when it is validated.
- Problem: Referential integrity confirms that the ticket exists, but it does not enforce the complete business rule for whether the ticket may be validated.
- Consequence: A ticket could potentially be validated even when its status or validity period makes it unusable.
- Specific improvement: Enforce the validation business rule in application logic or through a database trigger/transaction that checks ticket status and validity before recording a successful validation.
- Open question: Should validation eligibility be determined entirely by the ticket status, by the UTC validity period, or by both?

## State-transition trace

### Ticket purchase

1. The user selects a trip and ticket product. The system creates a ticket referencing an existing `user`, `trip`, and `product`.
2. The ticket price, currency, status, and validity period are stored. Database constraints reject invalid prices, currencies, references, or time ranges.
3. A payment is recorded for the ticket. The payment must reference an existing ticket and contain a valid amount, currency, and status.

### Ticket validation

1. A validator/device submits the ticket identity using `ticket_id` and `ticket_code`.
2. The database verifies that the exact ticket identity exists through the composite foreign key `validations_ticket_identity_fk`.
3. The validation result is recorded. Additional rules such as whether the ticket is currently active, expired, cancelled, or otherwise eligible for validation are not fully enforced by the current integrity constraints.
# Test Results

The following tests attempt invalid `INSERT` or `UPDATE` operations. Each operation was rejected by the database because it violated an integrity constraint.

## Summary

| #  | Test                                  | Constraint violated              | Result                             |
| -- | ------------------------------------- | -------------------------------- | ---------------------------------- |
| 1  | Negative trip capacity                | `trips_capacity_non_negative`    | Rejected                           |
| 2  | Reserved seats exceed capacity        | `trips_reserved_seats_valid`     | Rejected                           |
| 3  | Negative reserved seats               | `trips_reserved_seats_valid`     | Rejected                           |
| 4  | Ticket references unknown trip        | `tickets_trip_fk`                | Rejected                           |
| 5  | Negative ticket price                 | `tickets_price_non_negative`     | Rejected                           |
| 6  | Invalid ticket validity window        | `tickets_validity_window_valid`  | Rejected                           |
| 7  | Invalid currency length               | `tickets_currency_format`        | Rejected                           |
| 8  | Ticket validity end before start      | `tickets_validity_window_valid`  | Rejected                           |
| 9  | Duplicate ticket code                 | `tickets_ticket_code_unique`     | Rejected                           |
| 10 | Ticket references unknown user        | `tickets_user_fk`                | Rejected                           |
| 11 | Ticket references unknown trip        | `tickets_trip_fk`                | Rejected                           |
| 12 | Negative payment amount               | `payments_amount_non_negative`   | Rejected                           |
| 13 | Missing payment currency              | `payments.currency NOT NULL`     | Rejected                           |
| 14 | Payment references unknown ticket     | `payments_ticket_fk`             | Rejected                           |
| 15 | Invalid payment status                | `payments_status_known`          | Rejected                           |
| 16 | Negative product price                | `products_price_non_negative`    | Rejected                           |
| 17 | Missing product currency              | `products.currency NOT NULL`     | Rejected                           |
| 18 | Mismatched validation ticket identity | `validations_ticket_identity_fk` | Rejected                           |

## Exact Database Errors

### 1. Negative trip capacity

```text
ERROR: new row for relation "trips" violates check constraint "trips_capacity_non_negative"
```

**Result:** Rejected as expected.

---

### 2. Reserved seats exceed capacity

```text
ERROR: new row for relation "trips" violates check constraint "trips_reserved_seats_valid"
```

**Result:** Rejected as expected.

---

### 3. Negative reserved seats

```text
ERROR: new row for relation "trips" violates check constraint "trips_reserved_seats_valid"
```

**Result:** Rejected as expected.

---

### 4. Ticket references an unknown trip

```text
ERROR: insert or update on table "tickets" violates foreign key constraint "tickets_trip_fk"
DETAIL: Key (trip_id)=(TRIP-DOES-NOT-EXIST) is not present in table "trips".
```

**Result:** Rejected as expected.

---

### 5. Negative ticket price

```text
ERROR: new row for relation "tickets" violates check constraint "tickets_price_non_negative"
```

**Result:** Rejected as expected.

---

### 6. Invalid ticket validity window

```text
ERROR: new row for relation "tickets" violates check constraint "tickets_validity_window_valid"
```

**Result:** Rejected as expected.

---

### 7. Invalid currency length

```text
ERROR: new row for relation "tickets" violates check constraint "tickets_currency_format"
```

**Result:** Rejected as expected.

---

### 8. Ticket validity end before start

```text
ERROR: new row for relation "tickets" violates check constraint "tickets_validity_window_valid"
```

**Result:** Rejected as expected.

---

### 9. Duplicate ticket code

```text
ERROR: duplicate key value violates unique constraint "tickets_ticket_code_unique"
DETAIL: Key (ticket_code)=(CODE-M2-0001) already exists.
```

**Result:** Rejected as expected.

---

### 10. Ticket references an unknown user

```text
ERROR: insert or update on table "tickets" violates foreign key constraint "tickets_user_fk"
DETAIL: Key (user_id)=(DOES-NOT-EXIST) is not present in table "users".
```

**Result:** Rejected as expected.

---

### 11. Ticket references an unknown trip

```text
ERROR: insert or update on table "tickets" violates foreign key constraint "tickets_user_fk"
DETAIL: Key (user_id)=(U1) is not present in table "users".
```

**Result:** Rejected as expected

---

### 12. Negative payment amount

```text
ERROR: new row for relation "payments" violates check constraint "payments_amount_non_negative"
```

**Result:** Rejected as expected.

---

### 13. Missing payment currency

```text
ERROR: null value in column "currency" of relation "payments" violates not-null constraint
```

**Result:** Rejected as expected.

---

### 14. Payment references an unknown ticket

```text
ERROR: insert or update on table "payments" violates foreign key constraint "payments_ticket_fk"
DETAIL: Key (ticket_id)=(DOES-NOT-EXIST) is not present in table "tickets".
```

**Result:** Rejected as expected.

---

### 15. Invalid payment status

```text
ERROR: new row for relation "payments" violates check constraint "payments_status_known"
```

**Result:** Rejected as expected.

---

### 16. Negative product price

```text
ERROR: new row for relation "products" violates check constraint "products_price_non_negative"
```

**Result:** Rejected as expected.

---

### 17. Missing product currency

```text
ERROR: null value in column "currency" of relation "products" violates not-null constraint
```

**Result:** Rejected as expected.

---

### 18. Mismatched validation ticket identity

```text
ERROR: insert or update on table "validations" violates foreign key constraint "validations_ticket_identity_fk"
DETAIL: Key (ticket_id, ticket_code)=(TICKET-1, CODE-5C-0001) is not present in table "tickets".
```

**Result:** Rejected as expected.

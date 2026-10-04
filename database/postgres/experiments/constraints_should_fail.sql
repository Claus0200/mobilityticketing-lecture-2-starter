-- 1. Negative capacity. Expected: CHECK violation.
UPDATE trips
SET capacity = -1
WHERE id = 'TRIP-M2-20260429-0800';

-- 2. More reserved seats than capacity. Expected: CHECK violation.
UPDATE trips
SET reserved_seats = capacity + 1
WHERE id = 'TRIP-M2-20260429-0800';

-- 3. Negative reserved seats. Expected: CHECK violation.
UPDATE trips
SET reserved_seats = -1
WHERE id = 'TRIP-M2-20260429-0800';

-- 4. Unknown trip. Expected: FOREIGN KEY violation.
INSERT INTO tickets (
    id, user_id, trip_id, ticket_code, status,
    product_code, valid_from_utc, valid_to_utc, price, currency
) VALUES (
    'T-INVALID-TRIP', 'USER-1', 'TRIP-DOES-NOT-EXIST',
    'CODE-INVALID-TRIP', 'Active', 'SINGLE',
    '2026-04-29 08:00:00+00', '2026-04-29 09:00:00+00', 36, 'DKK'
);

-- 5. Ticket price cannot be negative. Expected: CHECK violation.
INSERT INTO tickets (
    id, user_id, trip_id, ticket_code, status,
    product_code, valid_from_utc, valid_to_utc,
    price, currency
)
VALUES (
    'TEST-NEG-05', 'U1', 'T1', 'NEG-PRICE-01', 'Pending',
    'SINGLE', NOW(), NOW() + INTERVAL '1 hour',
    -25.00, 'DKK'
);

-- Skipped the rest of the nullability tests for tickets, since they are similair to the above tests and will be rejected by the database.


-- 6. Reversed validity window. Expected: CHECK violation.
INSERT INTO tickets (
    id, user_id, trip_id, ticket_code, status,
    product_code, valid_from_utc, valid_to_utc, price, currency
) VALUES (
    'T-REVERSED', 'USER-1', 'TRIP-M2-20260429-0800',
    'CODE-REVERSED', 'Active', 'SINGLE',
    '2026-04-29 09:00:00+00', '2026-04-29 08:00:00+00', 36, 'DKK'
);

-- 7. Currency must contain exactly 3 characters. Expected: CHECK violation.
INSERT INTO tickets (
    id, user_id, trip_id, ticket_code, status,
    product_code, valid_from_utc, valid_to_utc,
    price, currency
)
VALUES (
    'TEST-NEG-07', 'U1', 'T1', 'NEG-CURRENCY-02', 'Pending',
    'SINGLE', NOW(), NOW() + INTERVAL '1 hour',
    25.00, 'DK'
);

-- 8. Ticket validity end cannot be before start. Expected: CHECK violation.
INSERT INTO tickets (
    id, user_id, trip_id, ticket_code, status,
    product_code, valid_from_utc, valid_to_utc,
    price, currency
)
VALUES (
    'TEST-NEG-08', 'U1', 'T1', 'NEG-WINDOW-01', 'Pending',
    'SINGLE',
    NOW(),
    NOW() - INTERVAL '1 hour',
    25.00, 'DKK'
);

-- 9. Ticket code must be unique. Expected: UNIQUE violation.
INSERT INTO tickets (
    id, user_id, trip_id, ticket_code, status,
    product_code, valid_from_utc, valid_to_utc,
    price, currency
)
VALUES (
    'TEST-NEG-09', 'U1', 'T1', 'CODE-M2-0001', 'Pending',
    'SINGLE', NOW(), NOW() + INTERVAL '1 hour',
    25.00, 'DKK'
);

-- 10. Ticket must reference an existing user. Expected: FOREIGN KEY violation.
INSERT INTO tickets (
    id, user_id, trip_id, ticket_code, status,
    product_code, valid_from_utc, valid_to_utc,
    price, currency
)
VALUES (
    'TEST-NEG-10', 'DOES-NOT-EXIST', 'T1', 'NEG-USER-01', 'Pending',
    'SINGLE', NOW(), NOW() + INTERVAL '1 hour',
    25.00, 'DKK'
);

-- 11. Ticket must reference an existing trip. Expected: FOREIGN KEY violation.
INSERT INTO tickets (
    id, user_id, trip_id, ticket_code, status,
    product_code, valid_from_utc, valid_to_utc,
    price, currency
)
VALUES (
    'TEST-NEG-11', 'U1', 'DOES-NOT-EXIST', 'NEG-TRIP-01', 'Pending',
    'SINGLE', NOW(), NOW() + INTERVAL '1 hour',
    25.00, 'DKK'
);

-- 12. Payment amount cannot be negative. Expected: CHECK violation.
INSERT INTO payments (
    id, user_id, ticket_id, external_payment_reference,
    amount, currency, status
)
VALUES (
    'TEST-NEG-12', 'U1', 'T1', 'NEG-PAYMENT-01',
    -10.00, 'DKK', 'Captured'
);


-- 13. Payment currency cannot be NULL. Expected: CHECK violation.
INSERT INTO payments (
    id, user_id, ticket_id, external_payment_reference,
    amount, currency, status
)
VALUES (
    'TEST-NEG-13', 'U1', 'T1', 'NEG-PAYMENT-02',
    10.00, NULL, 'Captured'
);


-- 14. Payment must reference an existing ticket. Expected: FOREIGN KEY violation.
INSERT INTO payments (
    id, user_id, ticket_id, external_payment_reference,
    amount, currency, status
)
VALUES (
    'TEST-NEG-14', 'U1', 'DOES-NOT-EXIST', 'NEG-PAYMENT-03',
    10.00, 'DKK', 'Captured'
);


-- 15. Payment status must be a known value. Expected: CHECK violation.
INSERT INTO payments (
    id, user_id, ticket_id, external_payment_reference,
    amount, currency, status
)
VALUES (
    'TEST-NEG-15', 'U1', 'T1', 'NEG-PAYMENT-04',
    10.00, 'DKK', 'SomethingInvalid'
);


-- 16. Product price cannot be negative. Expected: CHECK violation.
INSERT INTO products (
    code, name, price, currency
)
VALUES (
    'NEG-PRODUCT-01', 'Invalid Product', -10.00, 'DKK'
);


-- 17. Product currency cannot be NULL. Expected: CHECK violation.
INSERT INTO products (
    code, name, price, currency
)
VALUES (
    'NEG-PRODUCT-02', 'Invalid Product', 10.00, NULL
);


-- 18. Validation must reference the correct ticket identity. Expected: FOREIGN KEY violation.
INSERT INTO validations (
    id, ticket_id, ticket_code, vehicle_id,
    stop_id, device_id, result
)
VALUES (
    'VALIDATION-MISMATCH',
    'TICKET-1',
    'CODE-5C-0001',
    'V1',
    'S1',
    'D1',
    'Accepted'
);
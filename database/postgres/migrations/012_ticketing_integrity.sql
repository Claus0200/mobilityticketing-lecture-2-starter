BEGIN;

ALTER TABLE trips
    ALTER COLUMN capacity SET NOT NULL,
    ALTER COLUMN reserved_seats SET NOT NULL,
    ALTER COLUMN status SET NOT NULL,

    ADD CONSTRAINT trips_capacity_non_negative
        CHECK (capacity >= 0),

    ADD CONSTRAINT trips_reserved_seats_valid
        CHECK (reserved_seats BETWEEN 0 AND capacity),

    ADD CONSTRAINT trips_status_known
        CHECK (status IN ('Scheduled', 'Departed', 'Arrived', 'Cancelled'));


ALTER TABLE tickets
    ALTER COLUMN user_id SET NOT NULL,
    ALTER COLUMN trip_id SET NOT NULL,
    ALTER COLUMN ticket_code SET NOT NULL,
    ALTER COLUMN status SET NOT NULL,
    ALTER COLUMN product_code SET NOT NULL,
    ALTER COLUMN valid_from_utc SET NOT NULL,
    ALTER COLUMN valid_to_utc SET NOT NULL,
    ALTER COLUMN price SET NOT NULL,
    ALTER COLUMN currency SET NOT NULL,

    ADD CONSTRAINT tickets_user_fk
        FOREIGN KEY (user_id) REFERENCES users(id),

    ADD CONSTRAINT tickets_trip_fk
        FOREIGN KEY (trip_id) REFERENCES trips(id),

    ADD CONSTRAINT tickets_price_non_negative
        CHECK (price >= 0),

    ADD CONSTRAINT tickets_currency_format
        CHECK (length(currency) = 3),

    ADD CONSTRAINT tickets_ticket_code_unique
        UNIQUE (ticket_code),

    ADD CONSTRAINT tickets_id_ticket_code_unique
        UNIQUE (id, ticket_code),

    ADD CONSTRAINT tickets_validity_window_valid
        CHECK (valid_to_utc >= valid_from_utc),

    ADD CONSTRAINT tickets_status_known
        CHECK (status IN ('Pending', 'Active', 'Validated', 'Cancelled', 'Expired'));


ALTER TABLE payments
    ALTER COLUMN currency SET NOT NULL,

    ADD CONSTRAINT payments_amount_non_negative
        CHECK (amount >= 0),

    ADD CONSTRAINT payments_currency_format
        CHECK (length(currency) = 3),

    ADD CONSTRAINT payments_ticket_fk
        FOREIGN KEY (ticket_id) REFERENCES tickets(id),

    ADD CONSTRAINT payments_status_known
        CHECK (status IN ('Captured', 'Refunded', 'Failed', 'Pending'));


CREATE UNIQUE INDEX payments_captured_external_reference_unique
    ON payments (external_payment_reference)
    WHERE status = 'Captured';


ALTER TABLE products
    ALTER COLUMN name SET NOT NULL,
    ALTER COLUMN currency SET NOT NULL,
    ALTER COLUMN price SET NOT NULL,

    ADD CONSTRAINT products_price_non_negative
        CHECK (price >= 0),

    ADD CONSTRAINT products_currency_format
        CHECK (length(currency) = 3);


ALTER TABLE validations
    ADD CONSTRAINT validations_ticket_identity_fk
        FOREIGN KEY (ticket_id, ticket_code)
        REFERENCES tickets(id, ticket_code);


COMMIT;
-- App: Client Profile Module
-- Package: db
-- File: 01_seed_sample_customers.sql
-- Version: 0.0.2
-- Author: Bobwares
-- Date: 2025-06-09T20:32:51Z
-- Description: Insert a sample customer profile using relational tables.

DO $$
DECLARE
    cid UUID := gen_random_uuid();
BEGIN
    INSERT INTO customer_profile (
        id, first_name, middle_name, last_name,
        marketing_emails_enabled, two_factor_enabled
    ) VALUES (
        cid, 'Alice', NULL, 'Smith', TRUE, FALSE
    );

    INSERT INTO customer_email (customer_id, email)
    VALUES (cid, 'alice@example.com');

    INSERT INTO customer_phone_number (customer_id, type, number)
    VALUES (cid, 'mobile', '+15555550123');

    INSERT INTO customer_address (
        customer_id, line1, city, state, postal_code, country
    ) VALUES (
        cid, '123 Main St', 'Metropolis', 'NY', '10001', 'US'
    );
END $$;

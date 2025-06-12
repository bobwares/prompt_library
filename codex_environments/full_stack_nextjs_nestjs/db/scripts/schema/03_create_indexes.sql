-- App: Client Profile Module
-- Package: db
-- File: 03_create_indexes.sql
-- Version: 0.0.2
-- Author: Bobwares
-- Date: 2025-06-09T20:32:51Z
-- Description: Create indexes for customer profile tables.

CREATE INDEX IF NOT EXISTS idx_customer_profile_last_name ON customer_profile (last_name);
CREATE INDEX IF NOT EXISTS idx_customer_email_email ON customer_email (email);
CREATE INDEX IF NOT EXISTS idx_phone_number_customer ON customer_phone_number (customer_id);

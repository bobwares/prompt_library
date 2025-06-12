-- App: Client Profile Module
-- Package: db
-- File: 02_create_tables.sql
-- Version: 0.0.2
-- Author: Bobwares
-- Date: 2025-06-09T20:32:51Z
-- Description: Create tables for customer profiles using relational model.

CREATE TABLE IF NOT EXISTS customer_profile (
    id UUID PRIMARY KEY,
    first_name TEXT NOT NULL,
    middle_name TEXT,
    last_name TEXT NOT NULL,
    marketing_emails_enabled BOOLEAN NOT NULL,
    two_factor_enabled BOOLEAN NOT NULL
);

CREATE TABLE IF NOT EXISTS customer_email (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL REFERENCES customer_profile(id) ON DELETE CASCADE,
    email TEXT NOT NULL,
    UNIQUE (customer_id, email)
);

CREATE TABLE IF NOT EXISTS customer_phone_number (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL REFERENCES customer_profile(id) ON DELETE CASCADE,
    type TEXT NOT NULL CHECK (type IN ('mobile','home','work','other')),
    number TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS customer_address (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL UNIQUE REFERENCES customer_profile(id) ON DELETE CASCADE,
    line1 TEXT NOT NULL,
    line2 TEXT,
    city TEXT NOT NULL,
    state TEXT NOT NULL,
    postal_code TEXT NOT NULL,
    country CHAR(2) NOT NULL
);

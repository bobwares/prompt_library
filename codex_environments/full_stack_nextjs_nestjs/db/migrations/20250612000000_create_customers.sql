-- App: Client Profile Module
-- Package: db
-- File: 20250612000000_create_customers.sql
-- Version: 0.0.3
-- Author: Bobwares
-- Date: 2025-06-10T00:00:00Z
-- Description: Create customers table for new customer domain.

CREATE TABLE IF NOT EXISTS customers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    first_name TEXT NOT NULL,
    middle_name TEXT,
    last_name TEXT NOT NULL,
    emails TEXT[] NOT NULL,
    phone_numbers JSONB,
    address JSONB,
    privacy_settings JSONB NOT NULL
);

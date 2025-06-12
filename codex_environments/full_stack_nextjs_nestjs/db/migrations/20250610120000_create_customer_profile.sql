-- App: Client Profile Module
-- Package: db
-- File: 20250610120000_create_customer_profile.sql
-- Version: 0.0.1
-- Author: Bobwares
-- Date: 2025-06-10T00:00:00Z
-- Description: Initial table for customer profiles.

CREATE TABLE IF NOT EXISTS customer_profile (
    id UUID PRIMARY KEY,
    first_name TEXT NOT NULL,
    middle_name TEXT,
    last_name TEXT NOT NULL,
    emails TEXT[] NOT NULL,
    phone_numbers JSONB NOT NULL,
    address JSONB,
    privacy_settings JSONB NOT NULL
);

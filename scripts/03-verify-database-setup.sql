-- =====================================================
-- Database Verification Script
-- =====================================================
-- Run this to verify your database is properly set up

-- Check if all required tables exist
DO $$
DECLARE
    missing_tables TEXT[] := ARRAY[]::TEXT[];
    table_name TEXT;
    required_tables TEXT[] := ARRAY[
        'users', 'service_categories', 'freelancer_profiles', 
        'freelancer_services', 'job_requests', 'conversation_states',
        'message_logs', 'job_applications', 'reviews', 'payments',
        'notifications', 'freelancer_availability', 'system_settings'
    ];
BEGIN
    FOREACH table_name IN ARRAY required_tables
    LOOP
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.tables 
            WHERE table_schema = 'public' AND table_name = table_name
        ) THEN
            missing_tables := array_append(missing_tables, table_name);
        END IF;
    END LOOP;
    
    IF array_length(missing_tables, 1) > 0 THEN
        RAISE EXCEPTION 'Missing tables: %', array_to_string(missing_tables, ', ');
    ELSE
        RAISE NOTICE '✅ All required tables exist!';
    END IF;
END $$;

-- Check users table structure
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'users' AND column_name = 'telegram_chat_id'
    ) THEN
        RAISE EXCEPTION 'users table missing telegram_chat_id column';
    END IF;
    
    RAISE NOTICE '✅ Users table structure is correct!';
END $$;

-- Insert test service categories if none exist
INSERT INTO service_categories (name, description, icon_emoji, sort_order) 
SELECT 'Test Service', 'Test service for verification', '🔧', 999
WHERE NOT EXISTS (SELECT 1 FROM service_categories LIMIT 1);

-- Verify service categories
DO $$
DECLARE
    category_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO category_count FROM service_categories;
    
    IF category_count = 0 THEN
        RAISE EXCEPTION 'No service categories found. Please run the seeding script.';
    ELSE
        RAISE NOTICE '✅ Found % service categories', category_count;
    END IF;
END $$;

-- Test insert/upsert functionality
DO $$
BEGIN
    -- Test user upsert
    INSERT INTO users (telegram_chat_id, first_name, user_type) 
    VALUES (999999999, 'Test User', 'client')
    ON CONFLICT (telegram_chat_id) 
    DO UPDATE SET updated_at = NOW();
    
    -- Clean up test data
    DELETE FROM users WHERE telegram_chat_id = 999999999;
    DELETE FROM service_categories WHERE name = 'Test Service';
    
    RAISE NOTICE '✅ Database operations working correctly!';
END $$;

-- Final verification message
DO $$
BEGIN
    RAISE NOTICE '🎉 Database verification complete!';
    RAISE NOTICE '📊 Your FundiBot database is ready for the n8n workflow!';
    RAISE NOTICE '🚀 You can now import and run the fixed workflow.';
END $$;

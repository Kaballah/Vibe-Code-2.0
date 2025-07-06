-- =====================================================
-- FundiBot Database Schema Creation Script
-- =====================================================
-- This script creates all necessary tables for the freelancer booking platform

-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- USERS TABLE (Both clients and freelancers)
-- =====================================================
CREATE TABLE IF NOT EXISTS users (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    telegram_chat_id BIGINT UNIQUE NOT NULL,
    telegram_username VARCHAR(255),
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    phone_number VARCHAR(20),
    email VARCHAR(255),
    user_type VARCHAR(20) CHECK (user_type IN ('client', 'freelancer', 'both')) DEFAULT 'client',
    location_county VARCHAR(100),
    location_town VARCHAR(100),
    location_details TEXT,
    profile_completed BOOLEAN DEFAULT FALSE,
    verification_status VARCHAR(20) DEFAULT 'pending' CHECK (verification_status IN ('pending', 'verified', 'rejected')),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- SERVICE CATEGORIES TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS service_categories (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    icon_emoji VARCHAR(10),
    parent_category_id UUID REFERENCES service_categories(id),
    is_active BOOLEAN DEFAULT TRUE,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- FREELANCER PROFILES TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS freelancer_profiles (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE UNIQUE,
    bio TEXT,
    experience_years INTEGER DEFAULT 0,
    hourly_rate DECIMAL(10,2),
    daily_rate DECIMAL(10,2),
    project_rate DECIMAL(10,2),
    availability_status VARCHAR(20) DEFAULT 'available' CHECK (availability_status IN ('available', 'busy', 'offline', 'vacation')),
    portfolio_links TEXT[],
    skills TEXT[],
    certifications TEXT[],
    languages_spoken TEXT[] DEFAULT ARRAY['English', 'Swahili'],
    rating DECIMAL(3,2) DEFAULT 0.00 CHECK (rating >= 0 AND rating <= 5),
    total_jobs_completed INTEGER DEFAULT 0,
    total_jobs_cancelled INTEGER DEFAULT 0,
    total_earnings DECIMAL(12,2) DEFAULT 0.00,
    response_time_hours INTEGER DEFAULT 24,
    bank_account_number VARCHAR(50),
    bank_name VARCHAR(100),
    mpesa_number VARCHAR(15),
    id_number VARCHAR(20),
    id_document_url TEXT,
    profile_photo_url TEXT,
    is_verified BOOLEAN DEFAULT FALSE,
    verification_date TIMESTAMP WITH TIME ZONE,
    last_active TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- FREELANCER SERVICES TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS freelancer_services (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    freelancer_id UUID REFERENCES freelancer_profiles(id) ON DELETE CASCADE,
    category_id UUID REFERENCES service_categories(id),
    service_name VARCHAR(200) NOT NULL,
    description TEXT,
    price_min DECIMAL(10,2),
    price_max DECIMAL(10,2),
    price_type VARCHAR(20) CHECK (price_type IN ('fixed', 'hourly', 'daily', 'negotiable')) DEFAULT 'negotiable',
    service_duration VARCHAR(100),
    requirements TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- JOB REQUESTS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS job_requests (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    client_id UUID REFERENCES users(id) ON DELETE CASCADE,
    freelancer_id UUID REFERENCES freelancer_profiles(id),
    category_id UUID REFERENCES service_categories(id),
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    location_county VARCHAR(100),
    location_town VARCHAR(100),
    location_details TEXT,
    budget_min DECIMAL(10,2),
    budget_max DECIMAL(10,2),
    budget_type VARCHAR(20) CHECK (budget_type IN ('fixed', 'hourly', 'daily', 'negotiable')) DEFAULT 'negotiable',
    timeline VARCHAR(100),
    urgency VARCHAR(20) CHECK (urgency IN ('low', 'medium', 'high', 'urgent')) DEFAULT 'medium',
    required_skills TEXT[],
    preferred_experience_years INTEGER,
    job_type VARCHAR(20) CHECK (job_type IN ('one_time', 'recurring', 'contract')) DEFAULT 'one_time',
    status VARCHAR(20) DEFAULT 'open' CHECK (status IN ('draft', 'open', 'assigned', 'in_progress', 'completed', 'cancelled', 'disputed')),
    preferred_start_date DATE,
    estimated_duration VARCHAR(50),
    payment_status VARCHAR(20) DEFAULT 'pending' CHECK (payment_status IN ('pending', 'escrowed', 'released', 'refunded', 'disputed')),
    total_applications INTEGER DEFAULT 0,
    expires_at TIMESTAMP WITH TIME ZONE,
    assigned_at TIMESTAMP WITH TIME ZONE,
    started_at TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- CONVERSATION STATES TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS conversation_states (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE UNIQUE,
    current_state VARCHAR(50) NOT NULL DEFAULT 'new_user',
    state_data JSONB DEFAULT '{}',
    context_data JSONB DEFAULT '{}',
    step_number INTEGER DEFAULT 1,
    total_steps INTEGER DEFAULT 1,
    last_message_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expires_at TIMESTAMP WITH TIME ZONE DEFAULT (NOW() + INTERVAL '24 hours'),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- MESSAGE LOGS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS message_logs (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    message_type VARCHAR(20) CHECK (message_type IN ('text', 'voice', 'photo', 'document', 'location')) DEFAULT 'text',
    user_message TEXT,
    bot_response TEXT,
    intent_detected VARCHAR(100),
    entities_extracted JSONB DEFAULT '{}',
    conversation_state VARCHAR(50),
    processing_time_ms INTEGER,
    response_length INTEGER,
    session_id VARCHAR(100),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- JOB APPLICATIONS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS job_applications (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    job_request_id UUID REFERENCES job_requests(id) ON DELETE CASCADE,
    freelancer_id UUID REFERENCES freelancer_profiles(id) ON DELETE CASCADE,
    proposal_text TEXT NOT NULL,
    quoted_price DECIMAL(10,2),
    price_type VARCHAR(20) CHECK (price_type IN ('fixed', 'hourly', 'daily')) DEFAULT 'fixed',
    estimated_timeline VARCHAR(100),
    cover_letter TEXT,
    portfolio_samples TEXT[],
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'rejected', 'withdrawn', 'expired')),
    applied_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    responded_at TIMESTAMP WITH TIME ZONE,
    expires_at TIMESTAMP WITH TIME ZONE DEFAULT (NOW() + INTERVAL '7 days'),
    UNIQUE(job_request_id, freelancer_id)
);

-- =====================================================
-- REVIEWS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS reviews (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    job_request_id UUID REFERENCES job_requests(id) ON DELETE CASCADE,
    reviewer_id UUID REFERENCES users(id) ON DELETE CASCADE,
    reviewee_id UUID REFERENCES users(id) ON DELETE CASCADE,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5) NOT NULL,
    review_text TEXT,
    review_type VARCHAR(30) CHECK (review_type IN ('client_to_freelancer', 'freelancer_to_client')) NOT NULL,
    communication_rating INTEGER CHECK (communication_rating >= 1 AND communication_rating <= 5),
    quality_rating INTEGER CHECK (quality_rating >= 1 AND quality_rating <= 5),
    timeliness_rating INTEGER CHECK (timeliness_rating >= 1 AND timeliness_rating <= 5),
    is_public BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(job_request_id, reviewer_id, reviewee_id)
);

-- =====================================================
-- PAYMENTS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS payments (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    job_request_id UUID REFERENCES job_requests(id) ON DELETE CASCADE,
    payer_id UUID REFERENCES users(id) ON DELETE CASCADE,
    payee_id UUID REFERENCES users(id) ON DELETE CASCADE,
    amount DECIMAL(12,2) NOT NULL CHECK (amount > 0),
    platform_fee DECIMAL(12,2) DEFAULT 0.00,
    net_amount DECIMAL(12,2) NOT NULL,
    payment_method VARCHAR(20) CHECK (payment_method IN ('mpesa', 'bank_transfer', 'card', 'cash')) DEFAULT 'mpesa',
    transaction_reference VARCHAR(100) UNIQUE,
    external_transaction_id VARCHAR(100),
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'completed', 'failed', 'refunded', 'disputed')),
    payment_type VARCHAR(20) CHECK (payment_type IN ('escrow', 'release', 'refund', 'subscription', 'penalty')) NOT NULL,
    description TEXT,
    initiated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    completed_at TIMESTAMP WITH TIME ZONE,
    failed_at TIMESTAMP WITH TIME ZONE,
    failure_reason TEXT
);

-- =====================================================
-- NOTIFICATIONS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS notifications (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    notification_type VARCHAR(50) NOT NULL,
    priority VARCHAR(10) CHECK (priority IN ('low', 'medium', 'high', 'urgent')) DEFAULT 'medium',
    is_read BOOLEAN DEFAULT FALSE,
    is_sent BOOLEAN DEFAULT FALSE,
    action_url TEXT,
    action_data JSONB DEFAULT '{}',
    scheduled_for TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    sent_at TIMESTAMP WITH TIME ZONE,
    read_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- FREELANCER AVAILABILITY TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS freelancer_availability (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    freelancer_id UUID REFERENCES freelancer_profiles(id) ON DELETE CASCADE,
    day_of_week INTEGER CHECK (day_of_week >= 0 AND day_of_week <= 6), -- 0 = Sunday
    start_time TIME,
    end_time TIME,
    is_available BOOLEAN DEFAULT TRUE,
    timezone VARCHAR(50) DEFAULT 'Africa/Nairobi',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- SYSTEM SETTINGS TABLE
-- =====================================================
CREATE TABLE IF NOT EXISTS system_settings (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    setting_key VARCHAR(100) UNIQUE NOT NULL,
    setting_value TEXT NOT NULL,
    setting_type VARCHAR(20) CHECK (setting_type IN ('string', 'number', 'boolean', 'json')) DEFAULT 'string',
    description TEXT,
    is_public BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- CREATE INDEXES FOR PERFORMANCE
-- =====================================================

-- Users table indexes
CREATE INDEX IF NOT EXISTS idx_users_telegram_chat_id ON users(telegram_chat_id);
CREATE INDEX IF NOT EXISTS idx_users_user_type ON users(user_type);
CREATE INDEX IF NOT EXISTS idx_users_location ON users(location_county, location_town);
CREATE INDEX IF NOT EXISTS idx_users_verification_status ON users(verification_status);

-- Freelancer profiles indexes
CREATE INDEX IF NOT EXISTS idx_freelancer_profiles_user_id ON freelancer_profiles(user_id);
CREATE INDEX IF NOT EXISTS idx_freelancer_profiles_availability ON freelancer_profiles(availability_status);
CREATE INDEX IF NOT EXISTS idx_freelancer_profiles_rating ON freelancer_profiles(rating DESC);
CREATE INDEX IF NOT EXISTS idx_freelancer_profiles_location ON freelancer_profiles(user_id);

-- Job requests indexes
CREATE INDEX IF NOT EXISTS idx_job_requests_status ON job_requests(status);
CREATE INDEX IF NOT EXISTS idx_job_requests_client_id ON job_requests(client_id);
CREATE INDEX IF NOT EXISTS idx_job_requests_category_id ON job_requests(category_id);
CREATE INDEX IF NOT EXISTS idx_job_requests_location ON job_requests(location_county, location_town);
CREATE INDEX IF NOT EXISTS idx_job_requests_created_at ON job_requests(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_job_requests_budget ON job_requests(budget_min, budget_max);

-- Conversation states indexes
CREATE INDEX IF NOT EXISTS idx_conversation_states_user_id ON conversation_states(user_id);
CREATE INDEX IF NOT EXISTS idx_conversation_states_current_state ON conversation_states(current_state);
CREATE INDEX IF NOT EXISTS idx_conversation_states_expires_at ON conversation_states(expires_at);

-- Message logs indexes
CREATE INDEX IF NOT EXISTS idx_message_logs_user_id ON message_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_message_logs_created_at ON message_logs(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_message_logs_intent ON message_logs(intent_detected);

-- Job applications indexes
CREATE INDEX IF NOT EXISTS idx_job_applications_job_request_id ON job_applications(job_request_id);
CREATE INDEX IF NOT EXISTS idx_job_applications_freelancer_id ON job_applications(freelancer_id);
CREATE INDEX IF NOT EXISTS idx_job_applications_status ON job_applications(status);

-- Reviews indexes
CREATE INDEX IF NOT EXISTS idx_reviews_reviewee_id ON reviews(reviewee_id);
CREATE INDEX IF NOT EXISTS idx_reviews_job_request_id ON reviews(job_request_id);
CREATE INDEX IF NOT EXISTS idx_reviews_rating ON reviews(rating DESC);

-- Payments indexes
CREATE INDEX IF NOT EXISTS idx_payments_job_request_id ON payments(job_request_id);
CREATE INDEX IF NOT EXISTS idx_payments_status ON payments(status);
CREATE INDEX IF NOT EXISTS idx_payments_transaction_reference ON payments(transaction_reference);

-- Notifications indexes
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_is_read ON notifications(is_read);
CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON notifications(created_at DESC);

-- =====================================================
-- CREATE FUNCTIONS AND TRIGGERS
-- =====================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply updated_at triggers to relevant tables
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_freelancer_profiles_updated_at BEFORE UPDATE ON freelancer_profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_freelancer_services_updated_at BEFORE UPDATE ON freelancer_services FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_job_requests_updated_at BEFORE UPDATE ON job_requests FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_conversation_states_updated_at BEFORE UPDATE ON conversation_states FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_freelancer_availability_updated_at BEFORE UPDATE ON freelancer_availability FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_system_settings_updated_at BEFORE UPDATE ON system_settings FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to update freelancer rating when new review is added
CREATE OR REPLACE FUNCTION update_freelancer_rating()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.review_type = 'client_to_freelancer' THEN
        UPDATE freelancer_profiles 
        SET rating = (
            SELECT ROUND(AVG(rating)::numeric, 2)
            FROM reviews 
            WHERE reviewee_id = NEW.reviewee_id 
            AND review_type = 'client_to_freelancer'
        )
        WHERE user_id = NEW.reviewee_id;
    END IF;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger to update freelancer rating
CREATE TRIGGER update_freelancer_rating_trigger 
    AFTER INSERT ON reviews 
    FOR EACH ROW 
    EXECUTE FUNCTION update_freelancer_rating();

-- Function to increment job application count
CREATE OR REPLACE FUNCTION increment_job_applications()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE job_requests 
    SET total_applications = total_applications + 1 
    WHERE id = NEW.job_request_id;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger to increment application count
CREATE TRIGGER increment_job_applications_trigger 
    AFTER INSERT ON job_applications 
    FOR EACH ROW 
    EXECUTE FUNCTION increment_job_applications();

-- =====================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- =====================================================

-- Enable RLS on sensitive tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE freelancer_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE job_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE conversation_states ENABLE ROW LEVEL SECURITY;
ALTER TABLE message_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Note: RLS policies should be configured based on your authentication setup
-- These are basic examples - adjust according to your security requirements

-- Basic policy for users to access their own data
CREATE POLICY "Users can view own profile" ON users FOR SELECT USING (auth.uid()::text = id::text);
CREATE POLICY "Users can update own profile" ON users FOR UPDATE USING (auth.uid()::text = id::text);

-- =====================================================
-- COMPLETION MESSAGE
-- =====================================================

-- Insert a system log to confirm schema creation
INSERT INTO system_settings (setting_key, setting_value, setting_type, description, is_public) 
VALUES 
    ('schema_version', '1.0.0', 'string', 'Database schema version', false),
    ('schema_created_at', NOW()::text, 'string', 'Schema creation timestamp', false),
    ('platform_name', 'FundiBot', 'string', 'Platform name', true),
    ('platform_fee_percentage', '5.0', 'number', 'Platform fee percentage', false),
    ('max_job_applications', '50', 'number', 'Maximum applications per job', true),
    ('default_job_expiry_days', '30', 'number', 'Default job expiry in days', true)
ON CONFLICT (setting_key) DO NOTHING;

-- Success message
DO $$
BEGIN
    RAISE NOTICE '✅ FundiBot database schema created successfully!';
    RAISE NOTICE '📊 Created % tables with indexes and triggers', (
        SELECT COUNT(*) FROM information_schema.tables 
        WHERE table_schema = 'public' 
        AND table_name IN (
            'users', 'service_categories', 'freelancer_profiles', 
            'freelancer_services', 'job_requests', 'conversation_states',
            'message_logs', 'job_applications', 'reviews', 'payments',
            'notifications', 'freelancer_availability', 'system_settings'
        )
    );
END $$;

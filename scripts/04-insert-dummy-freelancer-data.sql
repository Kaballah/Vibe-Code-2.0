-- =====================================================
-- Dummy Freelancer Data for Testing
-- =====================================================
-- This script inserts sample freelancer profiles for testing the system

-- First, let's insert some test users (these will be our freelancers)
INSERT INTO users (telegram_chat_id, telegram_username, first_name, last_name, user_type, location_county, location_town, profile_completed, verification_status, is_active) VALUES
(1001, 'john_cleaner', 'John', 'Mwangi', 'freelancer', 'Nairobi', 'Westlands', true, 'verified', true),
(1002, 'mary_dev', 'Mary', 'Wanjiku', 'freelancer', 'Nairobi', 'Karen', true, 'verified', true),
(1003, 'peter_tutor', 'Peter', 'Kiprotich', 'freelancer', 'Nairobi', 'Kilimani', true, 'verified', true),
(1004, 'grace_designer', 'Grace', 'Akinyi', 'freelancer', 'Mombasa', 'Nyali', true, 'verified', true),
(1005, 'david_plumber', 'David', 'Mutua', 'freelancer', 'Nairobi', 'Kasarani', true, 'verified', true),
(1006, 'sarah_photographer', 'Sarah', 'Njeri', 'freelancer', 'Nakuru', 'Nakuru Town', true, 'verified', true),
(1007, 'james_electrician', 'James', 'Ochieng', 'freelancer', 'Kisumu', 'Kisumu Central', true, 'verified', true),
(1008, 'lucy_writer', 'Lucy', 'Wambui', 'freelancer', 'Nairobi', 'Parklands', true, 'verified', true),
(1009, 'michael_carpenter', 'Michael', 'Kipchoge', 'freelancer', 'Eldoret', 'Eldoret Town', true, 'verified', true),
(1010, 'ann_accountant', 'Ann', 'Chebet', 'freelancer', 'Nairobi', 'CBD', true, 'verified', true)
ON CONFLICT (telegram_chat_id) DO NOTHING;

-- Now let's create freelancer profiles for these users
INSERT INTO freelancer_profiles (
    user_id, 
    bio, 
    experience_years, 
    hourly_rate, 
    daily_rate, 
    availability_status, 
    skills, 
    languages_spoken, 
    rating, 
    total_jobs_completed, 
    mpesa_number, 
    is_verified, 
    verification_date
) 
SELECT 
    u.id,
    CASE u.telegram_username
        WHEN 'john_cleaner' THEN 'Professional house cleaner with 5+ years experience. I specialize in deep cleaning, office cleaning, and post-construction cleanup. Available 7 days a week.'
        WHEN 'mary_dev' THEN 'Full-stack web developer specializing in React, Node.js, and Python. I build modern, responsive websites and web applications for businesses of all sizes.'
        WHEN 'peter_tutor' THEN 'Experienced mathematics and science tutor. I help students from primary to university level achieve their academic goals. KCSE specialist.'
        WHEN 'grace_designer' THEN 'Creative graphic designer with expertise in branding, logo design, and digital marketing materials. I bring your vision to life!'
        WHEN 'david_plumber' THEN 'Licensed plumber with 8 years experience. I handle all plumbing issues - from leaky taps to complete bathroom installations. Emergency services available.'
        WHEN 'sarah_photographer' THEN 'Professional photographer specializing in events, portraits, and commercial photography. I capture your special moments beautifully.'
        WHEN 'james_electrician' THEN 'Certified electrician offering residential and commercial electrical services. Wiring, installations, repairs, and electrical maintenance.'
        WHEN 'lucy_writer' THEN 'Professional content writer and copywriter. I create engaging content for websites, blogs, marketing materials, and social media.'
        WHEN 'michael_carpenter' THEN 'Skilled carpenter and furniture maker. Custom furniture, home renovations, repairs, and woodworking projects of all sizes.'
        WHEN 'ann_accountant' THEN 'Qualified accountant offering bookkeeping, tax preparation, and financial consulting services for small and medium businesses.'
    END,
    CASE u.telegram_username
        WHEN 'john_cleaner' THEN 5
        WHEN 'mary_dev' THEN 4
        WHEN 'peter_tutor' THEN 6
        WHEN 'grace_designer' THEN 3
        WHEN 'david_plumber' THEN 8
        WHEN 'sarah_photographer' THEN 4
        WHEN 'james_electrician' THEN 7
        WHEN 'lucy_writer' THEN 3
        WHEN 'michael_carpenter' THEN 10
        WHEN 'ann_accountant' THEN 5
    END,
    CASE u.telegram_username
        WHEN 'john_cleaner' THEN 800.00
        WHEN 'mary_dev' THEN 2500.00
        WHEN 'peter_tutor' THEN 1200.00
        WHEN 'grace_designer' THEN 1800.00
        WHEN 'david_plumber' THEN 1500.00
        WHEN 'sarah_photographer' THEN 2000.00
        WHEN 'james_electrician' THEN 1600.00
        WHEN 'lucy_writer' THEN 1000.00
        WHEN 'michael_carpenter' THEN 1400.00
        WHEN 'ann_accountant' THEN 1800.00
    END,
    CASE u.telegram_username
        WHEN 'john_cleaner' THEN 5000.00
        WHEN 'mary_dev' THEN 15000.00
        WHEN 'peter_tutor' THEN 8000.00
        WHEN 'grace_designer' THEN 12000.00
        WHEN 'david_plumber' THEN 10000.00
        WHEN 'sarah_photographer' THEN 15000.00
        WHEN 'james_electrician' THEN 12000.00
        WHEN 'lucy_writer' THEN 7000.00
        WHEN 'michael_carpenter' THEN 10000.00
        WHEN 'ann_accountant' THEN 12000.00
    END,
    'available',
    CASE u.telegram_username
        WHEN 'john_cleaner' THEN ARRAY['House Cleaning', 'Office Cleaning', 'Deep Cleaning', 'Post-Construction Cleanup', 'Window Cleaning']
        WHEN 'mary_dev' THEN ARRAY['React', 'Node.js', 'Python', 'JavaScript', 'HTML/CSS', 'MongoDB', 'PostgreSQL', 'API Development']
        WHEN 'peter_tutor' THEN ARRAY['Mathematics', 'Physics', 'Chemistry', 'Biology', 'KCSE Preparation', 'University Math', 'Statistics']
        WHEN 'grace_designer' THEN ARRAY['Logo Design', 'Branding', 'Print Design', 'Digital Marketing', 'Adobe Creative Suite', 'UI/UX Design']
        WHEN 'david_plumber' THEN ARRAY['Pipe Installation', 'Leak Repairs', 'Bathroom Installation', 'Kitchen Plumbing', 'Drainage', 'Water Heaters']
        WHEN 'sarah_photographer' THEN ARRAY['Event Photography', 'Portrait Photography', 'Commercial Photography', 'Photo Editing', 'Wedding Photography']
        WHEN 'james_electrician' THEN ARRAY['Electrical Wiring', 'Lighting Installation', 'Power Systems', 'Electrical Repairs', 'Safety Inspections']
        WHEN 'lucy_writer' THEN ARRAY['Content Writing', 'Copywriting', 'Blog Writing', 'SEO Writing', 'Social Media Content', 'Technical Writing']
        WHEN 'michael_carpenter' THEN ARRAY['Custom Furniture', 'Home Renovations', 'Woodworking', 'Repairs', 'Kitchen Cabinets', 'Doors and Windows']
        WHEN 'ann_accountant' THEN ARRAY['Bookkeeping', 'Tax Preparation', 'Financial Planning', 'Payroll', 'Business Consulting', 'QuickBooks']
    END,
    ARRAY['English', 'Swahili'],
    CASE u.telegram_username
        WHEN 'john_cleaner' THEN 4.8
        WHEN 'mary_dev' THEN 4.9
        WHEN 'peter_tutor' THEN 4.7
        WHEN 'grace_designer' THEN 4.6
        WHEN 'david_plumber' THEN 4.9
        WHEN 'sarah_photographer' THEN 4.8
        WHEN 'james_electrician' THEN 4.7
        WHEN 'lucy_writer' THEN 4.5
        WHEN 'michael_carpenter' THEN 4.9
        WHEN 'ann_accountant' THEN 4.8
    END,
    CASE u.telegram_username
        WHEN 'john_cleaner' THEN 45
        WHEN 'mary_dev' THEN 23
        WHEN 'peter_tutor' THEN 67
        WHEN 'grace_designer' THEN 34
        WHEN 'david_plumber' THEN 89
        WHEN 'sarah_photographer' THEN 56
        WHEN 'james_electrician' THEN 78
        WHEN 'lucy_writer' THEN 42
        WHEN 'michael_carpenter' THEN 123
        WHEN 'ann_accountant' THEN 67
    END,
    CASE u.telegram_username
        WHEN 'john_cleaner' THEN '254712345001'
        WHEN 'mary_dev' THEN '254712345002'
        WHEN 'peter_tutor' THEN '254712345003'
        WHEN 'grace_designer' THEN '254712345004'
        WHEN 'david_plumber' THEN '254712345005'
        WHEN 'sarah_photographer' THEN '254712345006'
        WHEN 'james_electrician' THEN '254712345007'
        WHEN 'lucy_writer' THEN '254712345008'
        WHEN 'michael_carpenter' THEN '254712345009'
        WHEN 'ann_accountant' THEN '254712345010'
    END,
    true,
    NOW() - INTERVAL '30 days'
FROM users u 
WHERE u.telegram_username IN (
    'john_cleaner', 'mary_dev', 'peter_tutor', 'grace_designer', 'david_plumber',
    'sarah_photographer', 'james_electrician', 'lucy_writer', 'michael_carpenter', 'ann_accountant'
)
ON CONFLICT (user_id) DO NOTHING;

-- Create some freelancer services for better categorization
INSERT INTO freelancer_services (freelancer_id, category_id, service_name, description, price_min, price_max, price_type)
SELECT 
    fp.id,
    sc.id,
    CASE 
        WHEN u.telegram_username = 'john_cleaner' AND sc.name = 'Home Cleaning' THEN 'Professional House Cleaning'
        WHEN u.telegram_username = 'mary_dev' AND sc.name = 'Web Development' THEN 'Custom Website Development'
        WHEN u.telegram_username = 'peter_tutor' AND sc.name = 'Academic Tutoring' THEN 'Mathematics & Science Tutoring'
        WHEN u.telegram_username = 'grace_designer' AND sc.name = 'Graphic Design' THEN 'Logo & Brand Design'
        WHEN u.telegram_username = 'david_plumber' AND sc.name = 'Plumbing Services' THEN 'Complete Plumbing Solutions'
        WHEN u.telegram_username = 'sarah_photographer' AND sc.name = 'Photography' THEN 'Event & Portrait Photography'
        WHEN u.telegram_username = 'james_electrician' AND sc.name = 'Electrical Services' THEN 'Electrical Installation & Repair'
        WHEN u.telegram_username = 'lucy_writer' AND sc.name = 'Writing & Content Creation' THEN 'Professional Content Writing'
        WHEN u.telegram_username = 'michael_carpenter' AND sc.name = 'Carpentry & Woodwork' THEN 'Custom Furniture & Carpentry'
        WHEN u.telegram_username = 'ann_accountant' AND sc.name = 'Accounting & Bookkeeping' THEN 'Business Accounting Services'
    END,
    CASE 
        WHEN u.telegram_username = 'john_cleaner' THEN 'Complete house cleaning service including all rooms, kitchen, and bathrooms'
        WHEN u.telegram_username = 'mary_dev' THEN 'Modern, responsive websites built with latest technologies'
        WHEN u.telegram_username = 'peter_tutor' THEN 'One-on-one tutoring for mathematics and science subjects'
        WHEN u.telegram_username = 'grace_designer' THEN 'Professional logo design and complete brand identity packages'
        WHEN u.telegram_username = 'david_plumber' THEN 'All plumbing services from repairs to complete installations'
        WHEN u.telegram_username = 'sarah_photographer' THEN 'High-quality photography for events, portraits, and commercial use'
        WHEN u.telegram_username = 'james_electrician' THEN 'Safe and reliable electrical work for homes and businesses'
        WHEN u.telegram_username = 'lucy_writer' THEN 'Engaging content for websites, blogs, and marketing materials'
        WHEN u.telegram_username = 'michael_carpenter' THEN 'Custom-made furniture and professional carpentry work'
        WHEN u.telegram_username = 'ann_accountant' THEN 'Complete accounting and bookkeeping services for businesses'
    END,
    CASE 
        WHEN u.telegram_username = 'john_cleaner' THEN 2000.00
        WHEN u.telegram_username = 'mary_dev' THEN 25000.00
        WHEN u.telegram_username = 'peter_tutor' THEN 1500.00
        WHEN u.telegram_username = 'grace_designer' THEN 5000.00
        WHEN u.telegram_username = 'david_plumber' THEN 3000.00
        WHEN u.telegram_username = 'sarah_photographer' THEN 8000.00
        WHEN u.telegram_username = 'james_electrician' THEN 4000.00
        WHEN u.telegram_username = 'lucy_writer' THEN 2000.00
        WHEN u.telegram_username = 'michael_carpenter' THEN 5000.00
        WHEN u.telegram_username = 'ann_accountant' THEN 8000.00
    END,
    CASE 
        WHEN u.telegram_username = 'john_cleaner' THEN 8000.00
        WHEN u.telegram_username = 'mary_dev' THEN 150000.00
        WHEN u.telegram_username = 'peter_tutor' THEN 5000.00
        WHEN u.telegram_username = 'grace_designer' THEN 25000.00
        WHEN u.telegram_username = 'david_plumber' THEN 50000.00
        WHEN u.telegram_username = 'sarah_photographer' THEN 50000.00
        WHEN u.telegram_username = 'james_electrician' THEN 30000.00
        WHEN u.telegram_username = 'lucy_writer' THEN 15000.00
        WHEN u.telegram_username = 'michael_carpenter' THEN 100000.00
        WHEN u.telegram_username = 'ann_accountant' THEN 25000.00
    END,
    'negotiable'
FROM freelancer_profiles fp
JOIN users u ON fp.user_id = u.id
JOIN service_categories sc ON (
    (u.telegram_username = 'john_cleaner' AND sc.name = 'Home Cleaning') OR
    (u.telegram_username = 'mary_dev' AND sc.name = 'Web Development') OR
    (u.telegram_username = 'peter_tutor' AND sc.name = 'Academic Tutoring') OR
    (u.telegram_username = 'grace_designer' AND sc.name = 'Graphic Design') OR
    (u.telegram_username = 'david_plumber' AND sc.name = 'Plumbing Services') OR
    (u.telegram_username = 'sarah_photographer' AND sc.name = 'Photography') OR
    (u.telegram_username = 'james_electrician' AND sc.name = 'Electrical Services') OR
    (u.telegram_username = 'lucy_writer' AND sc.name = 'Writing & Content Creation') OR
    (u.telegram_username = 'michael_carpenter' AND sc.name = 'Carpentry & Woodwork') OR
    (u.telegram_username = 'ann_accountant' AND sc.name = 'Accounting & Bookkeeping')
)
WHERE u.telegram_username IN (
    'john_cleaner', 'mary_dev', 'peter_tutor', 'grace_designer', 'david_plumber',
    'sarah_photographer', 'james_electrician', 'lucy_writer', 'michael_carpenter', 'ann_accountant'
)
ON CONFLICT DO NOTHING;

-- Add some sample reviews for these freelancers
INSERT INTO reviews (job_request_id, reviewer_id, reviewee_id, rating, review_text, review_type, communication_rating, quality_rating, timeliness_rating)
SELECT 
    NULL, -- We'll create job requests later
    (SELECT id FROM users WHERE telegram_chat_id = 9999 LIMIT 1), -- Dummy client
    fp.user_id,
    CASE u.telegram_username
        WHEN 'john_cleaner' THEN 5
        WHEN 'mary_dev' THEN 5
        WHEN 'peter_tutor' THEN 5
        WHEN 'grace_designer' THEN 4
        WHEN 'david_plumber' THEN 5
        WHEN 'sarah_photographer' THEN 5
        WHEN 'james_electrician' THEN 5
        WHEN 'lucy_writer' THEN 4
        WHEN 'michael_carpenter' THEN 5
        WHEN 'ann_accountant' THEN 5
    END,
    CASE u.telegram_username
        WHEN 'john_cleaner' THEN 'Excellent cleaning service! John was thorough and professional. My house has never been cleaner!'
        WHEN 'mary_dev' THEN 'Mary built an amazing website for my business. Professional, fast, and exactly what I needed!'
        WHEN 'peter_tutor' THEN 'Peter helped my daughter improve her math grades significantly. Highly recommended tutor!'
        WHEN 'grace_designer' THEN 'Beautiful logo design! Grace understood my vision perfectly and delivered great work.'
        WHEN 'david_plumber' THEN 'David fixed our plumbing issues quickly and professionally. Very reliable service!'
        WHEN 'sarah_photographer' THEN 'Sarah captured our wedding beautifully! The photos are absolutely stunning.'
        WHEN 'james_electrician' THEN 'James did excellent electrical work in our new house. Safe and professional installation.'
        WHEN 'lucy_writer' THEN 'Lucy wrote great content for our website. Professional and delivered on time!'
        WHEN 'michael_carpenter' THEN 'Michael built custom furniture for our home. Excellent craftsmanship and attention to detail!'
        WHEN 'ann_accountant' THEN 'Ann handles our business accounting perfectly. Very organized and professional service.'
    END,
    'client_to_freelancer',
    5, 5, 5
FROM freelancer_profiles fp
JOIN users u ON fp.user_id = u.id
WHERE u.telegram_username IN (
    'john_cleaner', 'mary_dev', 'peter_tutor', 'grace_designer', 'david_plumber',
    'sarah_photographer', 'james_electrician', 'lucy_writer', 'michael_carpenter', 'ann_accountant'
);

-- Insert a dummy client for reviews (if not exists)
INSERT INTO users (telegram_chat_id, first_name, user_type, verification_status, is_active)
VALUES (9999, 'Test Client', 'client', 'verified', true)
ON CONFLICT (telegram_chat_id) DO NOTHING;

-- Update system settings with dummy data info
INSERT INTO system_settings (setting_key, setting_value, setting_type, description, is_public) VALUES
    ('dummy_data_inserted', 'true', 'boolean', 'Indicates if dummy freelancer data has been inserted', false),
    ('dummy_freelancers_count', '10', 'number', 'Number of dummy freelancers in the system', false),
    ('test_mode', 'true', 'boolean', 'System is in test mode with dummy data', false)
ON CONFLICT (setting_key) DO UPDATE SET
    setting_value = EXCLUDED.setting_value,
    updated_at = NOW();

-- Success message
DO $$
BEGIN
    RAISE NOTICE '✅ Dummy freelancer data inserted successfully!';
    RAISE NOTICE '👥 Created 10 verified freelancers with profiles';
    RAISE NOTICE '🛠️ Added services across different categories';
    RAISE NOTICE '⭐ Included sample reviews and ratings';
    RAISE NOTICE '🧪 Your system is ready for testing!';
    RAISE NOTICE '';
    RAISE NOTICE '📋 Test Freelancers Available:';
    RAISE NOTICE '   🧹 John Mwangi - House Cleaning (4.8⭐)';
    RAISE NOTICE '   💻 Mary Wanjiku - Web Development (4.9⭐)';
    RAISE NOTICE '   📚 Peter Kiprotich - Math Tutoring (4.7⭐)';
    RAISE NOTICE '   🎨 Grace Akinyi - Graphic Design (4.6⭐)';
    RAISE NOTICE '   🔧 David Mutua - Plumbing (4.9⭐)';
    RAISE NOTICE '   📸 Sarah Njeri - Photography (4.8⭐)';
    RAISE NOTICE '   ⚡ James Ochieng - Electrical (4.7⭐)';
    RAISE NOTICE '   ✍️ Lucy Wambui - Content Writing (4.5⭐)';
    RAISE NOTICE '   🔨 Michael Kipchoge - Carpentry (4.9⭐)';
    RAISE NOTICE '   📊 Ann Chebet - Accounting (4.8⭐)';
END $$;

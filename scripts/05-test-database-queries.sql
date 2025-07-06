-- =====================================================
-- Test Database Queries
-- =====================================================
-- Use these queries to test your database setup

-- Test 1: Check if all freelancers are properly inserted
SELECT 
    u.first_name,
    u.last_name,
    u.telegram_username,
    fp.bio,
    fp.rating,
    fp.total_jobs_completed,
    fp.availability_status
FROM users u
JOIN freelancer_profiles fp ON u.id = fp.user_id
WHERE u.user_type = 'freelancer'
ORDER BY fp.rating DESC;

-- Test 2: Search for available freelancers (this is what your bot will do)
SELECT 
    u.first_name || ' ' || u.last_name as full_name,
    u.telegram_username,
    fp.bio,
    fp.hourly_rate,
    fp.daily_rate,
    fp.rating,
    fp.total_jobs_completed,
    array_to_string(fp.skills, ', ') as skills,
    u.location_county,
    u.location_town
FROM freelancer_profiles fp
JOIN users u ON fp.user_id = u.id
WHERE fp.availability_status = 'available'
  AND fp.is_verified = true
ORDER BY fp.rating DESC, fp.total_jobs_completed DESC
LIMIT 10;

-- Test 3: Search freelancers by service category
SELECT 
    u.first_name || ' ' || u.last_name as full_name,
    sc.name as service_category,
    fs.service_name,
    fs.description,
    fs.price_min,
    fs.price_max,
    fp.rating
FROM freelancer_services fs
JOIN freelancer_profiles fp ON fs.freelancer_id = fp.id
JOIN users u ON fp.user_id = u.id
JOIN service_categories sc ON fs.category_id = sc.id
WHERE sc.name = 'Home Cleaning'  -- Change this to test different categories
  AND fp.availability_status = 'available'
  AND fp.is_verified = true
ORDER BY fp.rating DESC;

-- Test 4: Get service categories (for bot menu)
SELECT 
    name,
    description,
    icon_emoji,
    sort_order
FROM service_categories
WHERE is_active = true
  AND parent_category_id IS NULL
ORDER BY sort_order;

-- Test 5: Check user creation (simulate what happens when someone messages the bot)
-- This simulates checking if a user exists
SELECT * FROM users WHERE telegram_chat_id = 1001;

-- Test 6: Get freelancer profile with all details
SELECT 
    u.first_name || ' ' || u.last_name as full_name,
    u.telegram_username,
    u.location_county,
    u.location_town,
    fp.bio,
    fp.experience_years,
    fp.hourly_rate,
    fp.daily_rate,
    fp.rating,
    fp.total_jobs_completed,
    array_to_string(fp.skills, ', ') as skills,
    array_to_string(fp.languages_spoken, ', ') as languages,
    fp.mpesa_number
FROM freelancer_profiles fp
JOIN users u ON fp.user_id = u.id
WHERE u.telegram_username = 'mary_dev';  -- Change username to test different freelancers

-- Test 7: Search freelancers by location
SELECT 
    u.first_name || ' ' || u.last_name as full_name,
    u.location_county,
    u.location_town,
    fp.bio,
    fp.rating,
    array_to_string(fp.skills, ', ') as skills
FROM freelancer_profiles fp
JOIN users u ON fp.user_id = u.id
WHERE u.location_county = 'Nairobi'
  AND fp.availability_status = 'available'
  AND fp.is_verified = true
ORDER BY fp.rating DESC;

-- Test 8: Get freelancer reviews
SELECT 
    r.rating,
    r.review_text,
    r.communication_rating,
    r.quality_rating,
    r.timeliness_rating,
    r.created_at,
    reviewer.first_name as reviewer_name
FROM reviews r
JOIN users reviewer ON r.reviewer_id = reviewer.id
JOIN users reviewee ON r.reviewee_id = reviewee.id
WHERE reviewee.telegram_username = 'john_cleaner'  -- Change to test different freelancers
ORDER BY r.created_at DESC;

-- Test 9: Check system settings
SELECT 
    setting_key,
    setting_value,
    description
FROM system_settings
WHERE is_public = true
ORDER BY setting_key;

-- Test 10: Verify database integrity
DO $$
DECLARE
    user_count INTEGER;
    freelancer_count INTEGER;
    service_count INTEGER;
    category_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO user_count FROM users;
    SELECT COUNT(*) INTO freelancer_count FROM freelancer_profiles;
    SELECT COUNT(*) INTO service_count FROM freelancer_services;
    SELECT COUNT(*) INTO category_count FROM service_categories;
    
    RAISE NOTICE '📊 Database Statistics:';
    RAISE NOTICE '   👥 Total Users: %', user_count;
    RAISE NOTICE '   🛠️ Freelancer Profiles: %', freelancer_count;
    RAISE NOTICE '   📋 Freelancer Services: %', service_count;
    RAISE NOTICE '   📂 Service Categories: %', category_count;
    
    IF freelancer_count >= 10 THEN
        RAISE NOTICE '✅ Dummy data is properly loaded!';
    ELSE
        RAISE WARNING '⚠️ Expected at least 10 freelancers, found %', freelancer_count;
    END IF;
END $$;

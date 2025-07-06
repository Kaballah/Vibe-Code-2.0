-- =====================================================
-- FundiBot Service Categories Seeding Script
-- =====================================================
-- This script populates the service_categories table with initial data

-- Clear existing categories (optional - remove if you want to keep existing data)
-- DELETE FROM service_categories;

-- =====================================================
-- INSERT MAIN SERVICE CATEGORIES
-- =====================================================

INSERT INTO service_categories (name, description, icon_emoji, sort_order) VALUES
-- Home & Property Services
('Home Cleaning', 'Professional house cleaning, office cleaning, deep cleaning, and maintenance services', '🧹', 1),
('Plumbing Services', 'Pipe repairs, installations, water system maintenance, drainage solutions', '🔧', 2),
('Electrical Services', 'Wiring, installations, electrical repairs, power solutions, and maintenance', '⚡', 3),
('Carpentry & Woodwork', 'Furniture making, custom woodwork, repairs, installations, and renovations', '🔨', 4),
('Painting & Decoration', 'Interior and exterior painting, wall decorations, color consultation', '🎨', 5),
('Roofing Services', 'Roof repairs, installations, waterproofing, gutter cleaning and maintenance', '🏠', 6),
('Masonry & Construction', 'Brickwork, concrete work, building construction, and structural repairs', '🧱', 7),
('Landscaping & Gardening', 'Garden design, landscaping, lawn care, tree trimming, plant maintenance', '🌱', 8),

-- Technology & Digital Services
('Web Development', 'Website creation, web applications, e-commerce sites, and maintenance', '💻', 9),
('Mobile App Development', 'iOS and Android app development, mobile solutions, app maintenance', '📱', 10),
('Graphic Design', 'Logo design, branding, marketing materials, print design, digital graphics', '🎨', 11),
('Digital Marketing', 'Social media management, SEO, online advertising, content marketing', '📈', 12),
('IT Support & Repair', 'Computer repair, network setup, software installation, tech support', '🖥️', 13),
('Data Entry & Analysis', 'Data processing, spreadsheet work, database management, analytics', '📊', 14),

-- Creative & Media Services
('Photography', 'Event photography, portraits, product photography, photo editing', '📸', 15),
('Videography', 'Video production, editing, event coverage, promotional videos', '🎥', 16),
('Writing & Content Creation', 'Content writing, copywriting, blog posts, article writing', '✍️', 17),
('Translation Services', 'Document translation, interpretation, language services', '🌍', 18),
('Voice Over & Audio', 'Voice recording, audio editing, podcast production, sound design', '🎙️', 19),

-- Education & Training
('Academic Tutoring', 'Subject tutoring, exam preparation, homework assistance, study guidance', '📚', 20),
('Language Teaching', 'English, Swahili, French, and other language instruction', '🗣️', 21),
('Music Lessons', 'Piano, guitar, vocals, and other musical instrument instruction', '🎵', 22),
('Fitness Training', 'Personal training, yoga instruction, fitness coaching, workout plans', '💪', 23),
('Professional Training', 'Skills development, certification courses, workshop facilitation', '🎓', 24),

-- Business & Professional Services
('Accounting & Bookkeeping', 'Financial record keeping, tax preparation, business accounting', '📊', 25),
('Legal Services', 'Legal consultation, document preparation, contract review', '⚖️', 26),
('Business Consulting', 'Strategy development, business planning, market research', '💼', 27),
('Virtual Assistant', 'Administrative support, scheduling, email management, research', '👩‍💼', 28),
('Project Management', 'Project planning, coordination, timeline management, team leadership', '📋', 29),

-- Personal & Lifestyle Services
('Beauty & Grooming', 'Hair styling, makeup, nail services, beauty treatments', '💄', 30),
('Personal Shopping', 'Shopping assistance, wardrobe consultation, gift selection', '🛍️', 31),
('Event Planning', 'Wedding planning, party organization, event coordination, decoration', '🎉', 32),
('Catering Services', 'Event catering, meal preparation, cooking services, menu planning', '🍽️', 33),
('Childcare & Babysitting', 'Child supervision, babysitting, nanny services, child activities', '👶', 34),

-- Transportation & Delivery
('Delivery Services', 'Package delivery, food delivery, courier services, logistics', '🚚', 35),
('Moving Services', 'House moving, office relocation, packing, furniture transport', '📦', 36),
('Driver Services', 'Personal driver, chauffeur services, airport transfers', '🚗', 37),
('Logistics & Supply Chain', 'Inventory management, supply coordination, distribution', '📋', 38),

-- Specialized Services
('Pet Care Services', 'Pet sitting, dog walking, pet grooming, veterinary assistance', '🐕', 39),
('Security Services', 'Security guards, surveillance, safety consulting, risk assessment', '🛡️', 40),
('Cleaning Specialists', 'Carpet cleaning, window cleaning, pressure washing, specialized cleaning', '🧽', 41),
('Repair Services', 'Appliance repair, electronics repair, general maintenance, troubleshooting', '🔧', 42),
('Health & Wellness', 'Massage therapy, physiotherapy, nutrition consulting, wellness coaching', '🏥', 43),

-- Emerging & Niche Services
('Drone Services', 'Aerial photography, surveying, inspection, drone piloting', '🚁', 44),
('3D Printing', '3D modeling, printing services, prototyping, custom manufacturing', '🖨️', 45),
('Social Media Management', 'Content creation, community management, influencer marketing', '📱', 46),
('E-commerce Support', 'Online store setup, product listing, inventory management, customer service', '🛒', 47),
('Renewable Energy', 'Solar installation, energy audits, green technology consulting', '☀️', 48)

ON CONFLICT (name) DO UPDATE SET
    description = EXCLUDED.description,
    icon_emoji = EXCLUDED.icon_emoji,
    sort_order = EXCLUDED.sort_order,
    updated_at = NOW();

-- =====================================================
-- INSERT SUBCATEGORIES (Optional - for more specific services)
-- =====================================================

-- Get parent category IDs for subcategories
DO $$
DECLARE
    home_cleaning_id UUID;
    plumbing_id UUID;
    web_dev_id UUID;
    tutoring_id UUID;
BEGIN
    -- Get parent category IDs
    SELECT id INTO home_cleaning_id FROM service_categories WHERE name = 'Home Cleaning';
    SELECT id INTO plumbing_id FROM service_categories WHERE name = 'Plumbing Services';
    SELECT id INTO web_dev_id FROM service_categories WHERE name = 'Web Development';
    SELECT id INTO tutoring_id FROM service_categories WHERE name = 'Academic Tutoring';

    -- Insert subcategories
    INSERT INTO service_categories (name, description, icon_emoji, parent_category_id, sort_order) VALUES
    -- Home Cleaning Subcategories
    ('Regular House Cleaning', 'Weekly or monthly house cleaning services', '🏠', home_cleaning_id, 101),
    ('Deep Cleaning', 'Thorough one-time cleaning service', '🧼', home_cleaning_id, 102),
    ('Office Cleaning', 'Commercial and office space cleaning', '🏢', home_cleaning_id, 103),
    ('Post-Construction Cleaning', 'Cleanup after construction or renovation', '🚧', home_cleaning_id, 104),

    -- Plumbing Subcategories
    ('Emergency Plumbing', '24/7 emergency plumbing repairs', '🚨', plumbing_id, 201),
    ('Pipe Installation', 'New pipe installation and replacement', '🔧', plumbing_id, 202),
    ('Drain Cleaning', 'Blocked drain and sewer cleaning', '🚿', plumbing_id, 203),
    ('Water Heater Services', 'Water heater installation and repair', '🔥', plumbing_id, 204),

    -- Web Development Subcategories
    ('WordPress Development', 'WordPress website creation and customization', '📝', web_dev_id, 301),
    ('E-commerce Development', 'Online store and shopping cart development', '🛒', web_dev_id, 302),
    ('Custom Web Applications', 'Bespoke web application development', '⚙️', web_dev_id, 303),
    ('Website Maintenance', 'Ongoing website updates and maintenance', '🔄', web_dev_id, 304),

    -- Tutoring Subcategories
    ('Mathematics Tutoring', 'Math tutoring for all levels', '🔢', tutoring_id, 401),
    ('Science Tutoring', 'Physics, Chemistry, Biology tutoring', '🔬', tutoring_id, 402),
    ('Language Arts Tutoring', 'English, Literature, Writing assistance', '📖', tutoring_id, 403),
    ('Exam Preparation', 'KCSE, University entrance exam prep', '📝', tutoring_id, 404)

    ON CONFLICT (name) DO NOTHING;
END $$;

-- =====================================================
-- INSERT SYSTEM CONFIGURATION
-- =====================================================

-- Update system settings with category information
INSERT INTO system_settings (setting_key, setting_value, setting_type, description, is_public) VALUES
    ('total_service_categories', (SELECT COUNT(*)::text FROM service_categories WHERE parent_category_id IS NULL), 'number', 'Total number of main service categories', true),
    ('total_subcategories', (SELECT COUNT(*)::text FROM service_categories WHERE parent_category_id IS NOT NULL), 'number', 'Total number of subcategories', true),
    ('categories_last_updated', NOW()::text, 'string', 'Last time categories were updated', false),
    ('featured_categories', '["Home Cleaning", "Plumbing Services", "Web Development", "Academic Tutoring", "Graphic Design"]', 'json', 'Featured service categories for homepage', true)
ON CONFLICT (setting_key) DO UPDATE SET
    setting_value = EXCLUDED.setting_value,
    updated_at = NOW();

-- =====================================================
-- CREATE SAMPLE DATA FOR TESTING (Optional)
-- =====================================================

-- Insert sample freelancer skills based on categories
INSERT INTO system_settings (setting_key, setting_value, setting_type, description, is_public) VALUES
    ('common_skills', '[
        "Communication", "Time Management", "Problem Solving", "Customer Service",
        "Microsoft Office", "Data Entry", "Social Media", "Photography",
        "Writing", "Translation", "Teaching", "Cooking", "Cleaning",
        "Plumbing", "Electrical Work", "Carpentry", "Painting", "Gardening",
        "Web Development", "Graphic Design", "Digital Marketing", "Accounting"
    ]', 'json', 'Common skills for freelancers', true),
    ('popular_locations', '[
        "Nairobi", "Mombasa", "Kisumu", "Nakuru", "Eldoret", "Thika", "Machakos",
        "Meru", "Nyeri", "Kericho", "Kitale", "Garissa", "Kakamega", "Malindi"
    ]', 'json', 'Popular service locations in Kenya', true)
ON CONFLICT (setting_key) DO UPDATE SET
    setting_value = EXCLUDED.setting_value,
    updated_at = NOW();

-- =====================================================
-- COMPLETION MESSAGE AND STATISTICS
-- =====================================================

DO $$
DECLARE
    main_categories INTEGER;
    subcategories INTEGER;
    total_categories INTEGER;
BEGIN
    SELECT COUNT(*) INTO main_categories FROM service_categories WHERE parent_category_id IS NULL;
    SELECT COUNT(*) INTO subcategories FROM service_categories WHERE parent_category_id IS NOT NULL;
    SELECT COUNT(*) INTO total_categories FROM service_categories;

    RAISE NOTICE '✅ Service categories seeded successfully!';
    RAISE NOTICE '📊 Statistics:';
    RAISE NOTICE '   - Main Categories: %', main_categories;
    RAISE NOTICE '   - Subcategories: %', subcategories;
    RAISE NOTICE '   - Total Categories: %', total_categories;
    RAISE NOTICE '🎯 Categories cover: Home Services, Technology, Creative, Education, Business, Personal, Transportation, and Specialized services';
    RAISE NOTICE '🚀 Your FundiBot platform is ready for freelancers and clients!';
END $$;

-- =====================================================
-- VERIFY DATA INTEGRITY
-- =====================================================

-- Check for any issues
DO $$
BEGIN
    -- Verify all categories have descriptions
    IF EXISTS (SELECT 1 FROM service_categories WHERE description IS NULL OR description = '') THEN
        RAISE WARNING '⚠️  Some categories are missing descriptions';
    END IF;

    -- Verify all categories have emojis
    IF EXISTS (SELECT 1 FROM service_categories WHERE icon_emoji IS NULL OR icon_emoji = '') THEN
        RAISE WARNING '⚠️  Some categories are missing emojis';
    END IF;

    -- Success message if all checks pass
    IF NOT EXISTS (SELECT 1 FROM service_categories WHERE description IS NULL OR description = '' OR icon_emoji IS NULL OR icon_emoji = '') THEN
        RAISE NOTICE '✅ All data integrity checks passed!';
    END IF;
END $$;

-- ============================================
-- SAMPLE DATA FOR TESTING
-- ============================================

-- ============================================
-- 1. CATEGORIES
-- ============================================
INSERT INTO categories (name, image, created_by) VALUES
('Bún/Phở', 'https://example.com/pho.jpg', 'admin'),
('Cơm', 'https://example.com/com.jpg', 'admin'),
('Đồ ăn nhanh', 'https://example.com/fastfood.jpg', 'admin'),
('Đồ uống', 'https://example.com/drinks.jpg', 'admin'),
('Tráng miệng', 'https://example.com/dessert.jpg', 'admin'),
('Bánh mì', 'https://example.com/banhmi.jpg', 'admin');

-- ============================================
-- 2. RESTAURANTS
-- ============================================
INSERT INTO restaurants (name, address, status, is_open, latitude, longitude, delivery_radius, phone, description, created_by) VALUES
('Phở Thìn Bờ Hồ', 'Số 1 Đinh Tiên Hoàng, Hoàn Kiếm, Hà Nội', 'APPROVED', TRUE, 21.0285, 105.8542, 5.0, '0987654321', 'Phở truyền thống Hà Nội', 'admin'),
('Cơm Tấm Sài Gòn', '123 Nguyễn Văn Cừ, Quận 1, TP.HCM', 'APPROVED', TRUE, 10.7629, 106.6822, 8.0, '0912345678', 'Cơm tấm đặc biệt', 'admin'),
('Bún Chả Obama', '24 Lê Văn Hưu, Hai Bà Trưng, Hà Nội', 'APPROVED', TRUE, 21.0174, 105.8573, 4.0, '0934567890', 'Bún chả truyền thống', 'admin'),
('Pizza 4P''s', '8 Tống Duy Tân, Hoàn Kiếm, Hà Nội', 'PENDING', FALSE, 21.0342, 105.8501, 6.0, '0923456789', 'Pizza phong cách Nhật', 'admin'),
('Highlands Coffee', 'Toà nhà Keangnam, Nam Từ Liêm, Hà Nội', 'APPROVED', TRUE, 21.0191, 105.7836, 10.0, '0945678901', 'Cà phê Việt Nam', 'admin');

-- ============================================
-- 3. USERS
-- ============================================
-- Password for all: 'password' (BCrypt hashed)
INSERT INTO users (name, email, password, role, status, created_by) VALUES
('Admin User', 'admin@foodapp.com', '$2a$10$N9qo8uLO0gx.m0o3Hh9Eoe5jH9w8jXlqPd.9QLhKPJH5Ih.v.Lz6a', 'ADMIN', 'ACTIVE', 'system'),
('Staff Phở Thìn', 'staff@phothin.com', '$2a$10$N9qo8uLO0gx.m0o3Hh9Eoe5jH9w8jXlqPd.9QLhKPJH5Ih.v.Lz6a', 'STAFF', 'ACTIVE', 'admin'),
('Staff Cơm Tấm', 'staff@comtam.com', '$2a$10$N9qo8uLO0gx.m0o3Hh9Eoe5jH9w8jXlqPd.9QLhKPJH5Ih.v.Lz6a', 'STAFF', 'ACTIVE', 'admin'),
('Khách Hàng A', 'customer1@gmail.com', '$2a$10$N9qo8uLO0gx.m0o3Hh9Eoe5jH9w8jXlqPd.9QLhKPJH5Ih.v.Lz6a', 'CUSTOMER', 'ACTIVE', 'system'),
('Khách Hàng B', 'customer2@gmail.com', '$2a$10$N9qo8uLO0gx.m0o3Hh9Eoe5jH9w8jXlqPd.9QLhKPJH5Ih.v.Lz6a', 'CUSTOMER', 'ACTIVE', 'system'),
('Khách Hàng C', 'customer3@gmail.com', '$2a$10$N9qo8uLO0gx.m0o3Hh9Eoe5jH9w8jXlqPd.9QLhKPJH5Ih.v.Lz6a', 'CUSTOMER', 'SUSPENDED', 'system');

-- Update staff with restaurant
UPDATE users SET restaurant_id = 1 WHERE email = 'staff@phothin.com';
UPDATE users SET restaurant_id = 2 WHERE email = 'staff@comtam.com';

-- ============================================
-- 4. MENU ITEMS
-- ============================================
-- Phở Thìn (Restaurant 1)
INSERT INTO menu_items (name, price, discount_price, status, image, description, restaurant_id, category_id, created_by) VALUES
('Phở Bò Tái', 60000, 55000, 'AVAILABLE', 'https://example.com/pho-bo.jpg', 'Phở bò tái truyền thống', 1, 1, 'admin'),
('Phở Bò Nạm', 65000, NULL, 'AVAILABLE', 'https://example.com/pho-nam.jpg', 'Phở bò nạm gân', 1, 1, 'admin'),
('Phở Gà', 55000, 50000, 'AVAILABLE', 'https://example.com/pho-ga.jpg', 'Phở gà ta', 1, 1, 'admin'),
('Phở Xào', 70000, NULL, 'AVAILABLE', 'https://example.com/pho-xao.jpg', 'Phở xào thập cẩm', 1, 1, 'admin'),
('Trà Đá', 10000, NULL, 'AVAILABLE', 'https://example.com/tra-da.jpg', 'Trà đá miễn phí', 1, 4, 'admin'),
('Phở Đặc Biệt', 90000, 80000, 'OUT_OF_STOCK', 'https://example.com/pho-dac-biet.jpg', 'Phở đầy đủ topping', 1, 1, 'admin');

-- Cơm Tấm (Restaurant 2)
INSERT INTO menu_items (name, price, discount_price, status, image, description, restaurant_id, category_id, created_by) VALUES
('Cơm Tấm Sườn Bì', 50000, 45000, 'AVAILABLE', 'https://example.com/com-tam.jpg', 'Cơm tấm sườn nướng bì', 2, 2, 'admin'),
('Cơm Tấm Sườn Chả', 55000, NULL, 'AVAILABLE', 'https://example.com/com-tam-cha.jpg', 'Cơm tấm sườn chả', 2, 2, 'admin'),
('Cơm Tấm Đặc Biệt', 75000, 70000, 'AVAILABLE', 'https://example.com/com-tam-db.jpg', 'Cơm tấm đầy đủ', 2, 2, 'admin'),
('Canh Khổ Qua', 15000, NULL, 'AVAILABLE', 'https://example.com/canh.jpg', 'Canh khổ qua nhồi thịt', 2, 2, 'admin'),
('Sting Dâu', 12000, NULL, 'AVAILABLE', 'https://example.com/sting.jpg', 'Sting dâu đỏ', 2, 4, 'admin'),
('Cơm Thêm', 10000, NULL, 'AVAILABLE', 'https://example.com/com-them.jpg', 'Thêm cơm', 2, 2, 'admin');

-- Bún Chả (Restaurant 3)
INSERT INTO menu_items (name, price, discount_price, status, image, description, restaurant_id, category_id, created_by) VALUES
('Bún Chả Hà Nội', 50000, NULL, 'AVAILABLE', 'https://example.com/bun-cha.jpg', 'Bún chả truyền thống', 3, 1, 'admin'),
('Bún Chả Giò', 55000, 50000, 'AVAILABLE', 'https://example.com/bun-cha-gio.jpg', 'Bún chả giò nướng', 3, 1, 'admin'),
('Nem Cua Bể', 15000, NULL, 'AVAILABLE', 'https://example.com/nem.jpg', 'Nem cua bể', 3, 1, 'admin'),
('Chả Cá', 40000, NULL, 'AVAILABLE', 'https://example.com/cha-ca.jpg', 'Chả cá thêm', 3, 1, 'admin');

-- Highlands (Restaurant 5)
INSERT INTO menu_items (name, price, discount_price, status, image, description, restaurant_id, category_id, created_by) VALUES
('Phin Sữa Đá', 29000, NULL, 'AVAILABLE', 'https://example.com/phin.jpg', 'Cà phê phin sữa đá', 5, 4, 'admin'),
('Americano', 35000, NULL, 'AVAILABLE', 'https://example.com/americano.jpg', 'Cà phê Americano', 5, 4, 'admin'),
('Cappuccino', 45000, 40000, 'AVAILABLE', 'https://example.com/capu.jpg', 'Cappuccino', 5, 4, 'admin'),
('Trà Sen Vàng', 45000, NULL, 'AVAILABLE', 'https://example.com/tra-sen.jpg', 'Trà ô long sen vàng', 5, 4, 'admin'),
('Bánh Mì Que', 12000, NULL, 'AVAILABLE', 'https://example.com/banh-mi-que.jpg', 'Bánh mì que pate', 5, 6, 'admin'),
('Bánh Phô Mai', 25000, NULL, 'AVAILABLE', 'https://example.com/cheese-cake.jpg', 'Bánh phô mai chanh dây', 5, 5, 'admin');

-- ============================================
-- 5. VOUCHERS (Optional)
-- ============================================
INSERT INTO vouchers (code, discount_type, discount_value, min_order_amount, max_discount_amount, start_date, end_date, usage_limit, status) VALUES
('GIAM10K', 'FIXED', 10000, 50000, 10000, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), 100, 'ACTIVE'),
('GIAM30K', 'FIXED', 30000, 100000, 30000, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY), 50, 'ACTIVE'),
('SALE20', 'PERCENTAGE', 20, 100000, 50000, NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY), 200, 'ACTIVE'),
('FREESHIP', 'FIXED', 30000, 0, 30000, NOW(), DATE_ADD(NOW(), INTERVAL 14 DAY), 1000, 'ACTIVE'),
('WELCOME', 'FIXED', 15000, 0, 15000, NOW(), DATE_ADD(NOW(), INTERVAL 365 DAY), 1, 'ACTIVE');

-- ============================================
-- SAMPLE ORDERS DATA (for testing reports)
-- ============================================
-- Create some completed orders for reporting
-- INSERT INTO orders (user_id, restaurant_id, status, total_price, final_price, payment_method, payment_status, shipping_address, phone_number, created_at) VALUES
-- (4, 1, 'COMPLETED', 120000, 110000, 'COD', 'PAID', '84 Phúc Diễn, Hà Nội', '0987654321', DATE_SUB(NOW(), INTERVAL 1 DAY)),
-- (4, 2, 'COMPLETED', 150000, 150000, 'VNPAY', 'PAID', '123 Cầu Giấy, Hà Nội', '0987654321', DATE_SUB(NOW(), INTERVAL 2 DAY)),
-- (5, 1, 'COMPLETED', 80000, 75000, 'COD', 'PAID', '456 Hoàng Quốc Việt, Hà Nội', '0912345678', DATE_SUB(NOW(), INTERVAL 1 DAY));

-- ============================================
-- QUICK REFERENCE IDs
-- ============================================
-- Categories: 1=Phở, 2=Cơm, 3=Fast food, 4=Đồ uống, 5=Tráng miệng, 6=Bánh mì
-- Restaurants: 1=Phở Thìn, 2=Cơm Tấm, 3=Bún Chả, 4=Pizza (Pending), 5=Highlands
-- Users: 1=Admin, 2=Staff Phở Thìn, 3=Staff Cơm Tấm, 4-6=Customers

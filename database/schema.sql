CREATE DATABASE IF NOT EXISTS psu_canteen CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE psu_canteen;
CREATE TABLE IF NOT EXISTS users (
 id INT AUTO_INCREMENT PRIMARY KEY, username VARCHAR(60) NOT NULL UNIQUE,
 password_hash VARCHAR(255) NOT NULL, role ENUM('student','admin') NOT NULL DEFAULT 'student',
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS categories (
 id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(80) NOT NULL UNIQUE, description VARCHAR(255)
);
CREATE TABLE IF NOT EXISTS menu_items (
 id INT AUTO_INCREMENT PRIMARY KEY, category_id INT NOT NULL, name VARCHAR(120) NOT NULL,
 price DECIMAL(10,2) NOT NULL CHECK(price>0), stock INT NOT NULL DEFAULT 0 CHECK(stock>=0),
 is_active BOOLEAN NOT NULL DEFAULT TRUE, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_menu_category FOREIGN KEY(category_id) REFERENCES categories(id)
);
CREATE TABLE IF NOT EXISTS orders (
 id INT AUTO_INCREMENT PRIMARY KEY, user_id INT NULL, buyer VARCHAR(100) NOT NULL,
 pickup_time TIME NOT NULL, payment_method VARCHAR(50) NOT NULL DEFAULT 'Cash on Pickup',
 total DECIMAL(10,2) NOT NULL CHECK(total>=0),
 status ENUM('Pending','Preparing','Ready','Completed') NOT NULL DEFAULT 'Pending',
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_order_user FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE SET NULL
);
CREATE TABLE IF NOT EXISTS order_items (
 id INT AUTO_INCREMENT PRIMARY KEY, order_id INT NOT NULL, menu_item_id INT NULL,
 item_name_snapshot VARCHAR(120) NOT NULL, unit_price DECIMAL(10,2) NOT NULL CHECK(unit_price>=0),
 quantity INT NOT NULL CHECK(quantity>0),
 CONSTRAINT fk_item_order FOREIGN KEY(order_id) REFERENCES orders(id) ON DELETE CASCADE,
 CONSTRAINT fk_item_menu FOREIGN KEY(menu_item_id) REFERENCES menu_items(id) ON DELETE SET NULL
);
CREATE TABLE IF NOT EXISTS feedback (
 id INT AUTO_INCREMENT PRIMARY KEY, user_id INT NULL, rating TINYINT NOT NULL CHECK(rating BETWEEN 1 AND 5),
 comment TEXT NOT NULL, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 CONSTRAINT fk_feedback_user FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE SET NULL
);
CREATE OR REPLACE VIEW v_order_details AS
SELECT o.id AS order_id,o.buyer,o.pickup_time,o.payment_method,o.status,o.created_at,
 oi.item_name_snapshot AS item_name,oi.quantity,oi.unit_price,(oi.quantity*oi.unit_price) AS line_total
FROM orders o JOIN order_items oi ON oi.order_id=o.id;

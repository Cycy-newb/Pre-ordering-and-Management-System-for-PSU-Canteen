USE psu_canteen;
-- 1) Multi-table JOIN: orders, users (optional), order_items
SELECT o.id,o.buyer,u.username,oi.item_name_snapshot,oi.quantity,oi.unit_price,o.status
FROM orders o LEFT JOIN users u ON u.id=o.user_id
JOIN order_items oi ON oi.order_id=o.id ORDER BY o.id;
-- 2) GROUP BY + HAVING: popular menu items
SELECT item_name_snapshot,SUM(quantity) AS units_sold
FROM order_items GROUP BY item_name_snapshot HAVING SUM(quantity)>=2 ORDER BY units_sold DESC;
-- 3) Subquery: items priced above average
SELECT name,price FROM menu_items WHERE price>(SELECT AVG(price) FROM menu_items) ORDER BY price DESC;
-- 4) View
SELECT * FROM v_order_details ORDER BY order_id;
-- 5) Transaction example: make order + line + reduce stock (replace IDs/values as needed)
START TRANSACTION;
SELECT stock FROM menu_items WHERE id=1 FOR UPDATE;
INSERT INTO orders(buyer,pickup_time,payment_method,total,status) VALUES('Demo Customer','11:30:00','Cash on Pickup',100,'Pending');
SET @new_order_id=LAST_INSERT_ID();
INSERT INTO order_items(order_id,menu_item_id,item_name_snapshot,unit_price,quantity) VALUES(@new_order_id,1,'Sample Item',50,2);
UPDATE menu_items SET stock=stock-2 WHERE id=1 AND stock>=2;
-- If stock was insufficient, ROLLBACK; otherwise COMMIT.
COMMIT;
-- 6) Constraint test: should fail due to rating outside allowed range
INSERT INTO feedback(rating,comment) VALUES(6,'This should be rejected by CHECK constraint');
-- 7) Sales summary
SELECT status,COUNT(*) AS orders_count,SUM(total) AS sales FROM orders GROUP BY status;

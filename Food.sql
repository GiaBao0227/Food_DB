CREATE DATABASE IF NOT EXISTS Food_App;
USE Food_App;

-- Bảng user
CREATE TABLE `user` (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  user_name VARCHAR(100),
  email VARCHAR(100),
  password VARCHAR(100),
  phone VARCHAR(20),
  address VARCHAR(255)
);

-- Bảng restaurant
CREATE TABLE `restaurant` (
  res_id INT AUTO_INCREMENT PRIMARY KEY,
  res_name VARCHAR(100),
  address VARCHAR(255),
  `desc` VARCHAR(255)
);

-- Bảng order (đơn đặt hàng)
CREATE TABLE `order` (
  order_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  res_id INT,
  amount INT,
  total INT,
  CONSTRAINT fk_order_user FOREIGN KEY (user_id) REFERENCES `user`(user_id),
  CONSTRAINT fk_order_rest FOREIGN KEY (res_id) REFERENCES `restaurant`(res_id)
);

-- Bảng like_res (người dùng like nhà hàng)
CREATE TABLE `like_res` (
  user_id INT,
  res_id INT,
  PRIMARY KEY (user_id, res_id),
  CONSTRAINT fk_like_user FOREIGN KEY (user_id) REFERENCES `user`(user_id),
  CONSTRAINT fk_like_rest FOREIGN KEY (res_id) REFERENCES `restaurant`(res_id)
);

-- Bảng rate_res (người dùng đánh giá nhà hàng)
CREATE TABLE `rate_res` (
  user_id INT,
  res_id INT,
  rating INT,
  PRIMARY KEY (user_id, res_id),
  CONSTRAINT fk_rate_user FOREIGN KEY (user_id) REFERENCES `user`(user_id),
  CONSTRAINT fk_rate_rest FOREIGN KEY (res_id) REFERENCES `restaurant`(res_id)
);

-- Bảng food_type (phân loại món ăn)
CREATE TABLE `food_type` (
  type_id INT AUTO_INCREMENT PRIMARY KEY,
  type_name VARCHAR(100)
);

-- Bảng food (danh sách món ăn)
CREATE TABLE `food` (
  food_id INT AUTO_INCREMENT PRIMARY KEY,
  type_id INT,
  name VARCHAR(100),
  image VARCHAR(255),
  price INT,
  CONSTRAINT fk_food_type FOREIGN KEY (type_id) REFERENCES `food_type`(type_id)
);

-- Bảng sub_food (tùy chọn phụ cho món ăn)
CREATE TABLE `sub_food` (
  sub_id INT AUTO_INCREMENT PRIMARY KEY,
  food_id INT,
  sub_name VARCHAR(100),
  CONSTRAINT fk_sub_food FOREIGN KEY (food_id) REFERENCES `food`(food_id)
);

-- Bảng sub_price (giá thêm cho tùy chọn phụ)
CREATE TABLE `sub_price` (
  sub_id INT,
  price INT,
  PRIMARY KEY (sub_id),
  CONSTRAINT fk_sub_price FOREIGN KEY (sub_id) REFERENCES `sub_food`(sub_id)
);

-- Bảng user
INSERT INTO `user` (user_name, email, password, phone, address)
VALUES
('Alice', 'alice@example.com', 'alice123', '111111111', 'Address A'),
('Bob', 'bob@example.com', 'bob123', '222222222', 'Address B'),
('Charlie', 'charlie@example.com', 'charlie123', '333333333', 'Address C'),
('David', 'david@example.com', 'david123', '444444444', 'Address D'),
('Eve', 'eve@example.com', 'eve123', '555555555', 'Address E'),
('Frank', 'frank@example.com', 'frank123', '666666666', 'Address F');

-- Bảng restaurant
INSERT INTO `restaurant` (res_name, address, `desc`)
VALUES
('KFC', '123 Street', 'Fast Food'),
('McDonald', '234 Street', 'Fast Food'),
('Starbucks', '345 Street', 'Coffee'),
('Pizza Hut', '456 Street', 'Pizza Restaurant'),
('Highlands Coffee', '567 Street', 'Coffee Chain');

-- Bảng like_res
INSERT INTO `like_res` (user_id, res_id)
VALUES
(1,1),(1,2),       -- Alice likes KFC, McDonald
(2,1),(2,2),(2,3), -- Bob likes KFC, McDonald, Starbucks
(3,1),(3,3),       -- Charlie likes KFC, Starbucks
(4,4),             -- David likes Pizza Hut
(5,5),             -- Eve likes Highlands Coffee
(6,1);             -- Frank likes KFC

-- Bảng rate_res
INSERT INTO `rate_res` (user_id, res_id, rating)
VALUES
(1,1,5),(1,2,4),
(2,2,5),(2,3,3),
(3,1,4),
(4,4,5),
(5,5,4),
(6,1,3);

-- Bảng order
INSERT INTO `order` (user_id, res_id, amount, total)
VALUES
(1,1,2,200),
(1,2,1,100),
(2,3,2,120),
(2,2,1,90),
(3,1,1,100),
(4,4,2,300),
(5,5,1,150);

-- Bảng food_type
INSERT INTO `food_type` (type_name)
VALUES
('Fast Food'),
('Drink'),
('Pizza');

-- Bảng food
INSERT INTO `food` (type_id, name, image, price)
VALUES
(1, 'Fried Chicken', 'chicken.jpg', 50),
(1, 'Burger', 'burger.jpg', 30),
(2, 'Latte', 'latte.jpg', 40),
(2, 'Espresso', 'espresso.jpg', 35),
(3, 'Pepperoni Pizza', 'pepperoni.jpg', 80),
(3, 'Hawaiian Pizza', 'hawaiian.jpg', 90);

-- Bảng sub_food
INSERT INTO `sub_food` (food_id, sub_name)
VALUES
(1, 'Extra Spicy'),
(1, 'Extra Crispy'),
(2, 'Double Cheese'),
(3, 'No Sugar'),
(4, 'Double Shot'),
(5, 'Extra Cheese'),
(6, 'Stuffed Crust');

-- Bảng sub_price
INSERT INTO `sub_price` (sub_id, price)
VALUES
(1, 5),
(2, 10),
(3, 15),
(4, 10),
(5, 10),
(6, 20),
(7, 25);

-- Tìm 5 người đã like nhà hàng nhiều nhất
SELECT u.user_id,
       u.user_name,
       COUNT(*) AS total_likes
FROM like_res lr
JOIN `user` u ON u.user_id = lr.user_id
GROUP BY u.user_id, u.user_name
ORDER BY total_likes DESC
LIMIT 5;

-- Tìm 2 nhà hàng có lượt like nhiều nhất
SELECT r.res_id,
       r.res_name,
       COUNT(*) AS total_likes
FROM like_res lr
JOIN `restaurant` r ON r.res_id = lr.res_id
GROUP BY r.res_id, r.res_name
ORDER BY total_likes DESC
LIMIT 2;


-- Tìm người dùng đã đặt hàng nhiều nhất
SELECT u.user_id,
       u.user_name,
       COUNT(*) AS total_orders
FROM `order` o
JOIN `user` u ON u.user_id = o.user_id
GROUP BY u.user_id, u.user_name
ORDER BY total_orders DESC
LIMIT 1;

-- Tìm người dùng không hoạt động (không đặt hàng, không like, không đánh giá)
SELECT u.user_id,
       u.user_name
FROM `user` u
LEFT JOIN `order` o ON u.user_id = o.user_id
LEFT JOIN like_res lr ON u.user_id = lr.user_id
LEFT JOIN rate_res rr ON u.user_id = rr.user_id
WHERE o.user_id IS NULL
  AND lr.user_id IS NULL
  AND rr.user_id IS NULL;

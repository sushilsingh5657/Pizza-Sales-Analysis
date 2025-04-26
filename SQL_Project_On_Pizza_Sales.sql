CREATE DATABASE pizzahut;
USE pizzahut;

CREATE TABLE orders (
order_id INT NOT NULL,
order_date DATE NOT NULL,
order_time TIME NOT NULL,
PRIMARY KEY (order_id)
);


CREATE TABLE order_details (
order_details_id INT NOT NULL,
order_id INT NOT NULL,
pizza_id TEXT NOT NULL,
quantity INT NOT NULL,
PRIMARY KEY (order_details_id)
);


-- Que1:- Retrieve the total number of orders placed.
SELECT COUNT(order_id) AS total_orders FROM ORDERS;


-- Que2:- calculate the total revenue generated from pizza sales.

 SELECT 
ROUND(SUM(order_details.quantity * pizzas.price),2) AS total_sales 
 FROM order_details JOIN pizzas 
 ON order_details.pizza_id = pizzas.pizza_id;
 
 
 -- Que3:- identify the highest-priced pizza.

SELECT pizza_types.name, pizzas.price
FROM pizza_types JOIN pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC LIMIT 1;


#Que4:- Identify the most common pizza size ordered.

SELECT pizzas.size, COUNT(order_details.order_details_id) AS order_count
FROM pizzas join order_details
ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size ORDER BY order_count DESC;


#Que5 list the top 5 most ordered pizza types along with their quantities.

SELECT pizza_types.name,SUM(order_details.quantity) AS quantity
FROM pizza_types JOIN pizzas 
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details
ON order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name ORDER BY quantity DESC LIMIT 5;


-- QUE6:- join the necessary tables to find the total quantity of each pizza category ordered.

SELECT pizza_types.category, SUM(order_details.quantity) AS quantity 
FROM pizza_types JOIN pizzas 
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details
ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category ORDER BY quantity DESC;


#Que7:- determine the distribution of orders by hour of the day.

SELECT hour(order_time) as hour, COUNT(order_id) AS order_count FROM orders
GROUP BY hour (order_time);


#Que8:- join relevant tables to find the category-wise distribution of pizzas.

SELECT category , COUNT(name) FROM pizza_types
GROUP BY category;


#Que9:- groups the orders by date and calculate the average number of pizzas ordered per day.

SELECT ROUND(AVG(quantity),0) AS avg_pizza_ordered_per_day FROM
(SELECT orders.order_date, SUM(order_details.quantity) AS quantity
FROM orders JOIN order_details
ON orders.order_id = order_details.order_id
GROUP BY orders.order_date) AS order_quantity;


-- Que10:- determine the top 3 most ordered pizza types based on revenue.

SELECT pizza_types.name, SUM(order_details.quantity*pizzas.price)AS revenue
FROM pizza_types JOIN pizzas
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details
ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name ORDER BY revenue DESC LIMIT 3;


-- Que11:- calculate the percentage contribution of each pizza type to total revenue.

SELECT pizza_types.category,ROUND(sum(order_details.quantity*pizzas.price) / (SELECT 
ROUND(SUM(order_details.quantity * pizzas.price),2) AS total_sales 
 FROM order_details JOIN pizzas 
 ON order_details.pizza_id = pizzas.pizza_id) * 100, 2) AS revenue
FROM pizza_types JOIN pizzas
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details
ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category ORDER BY revenue DESC;


#Que12:- analyze the cumulative revenue generated over time.

SELECT order_date, SUM(revenue) OVER(order by order_date) AS cum_revenue FROM
(SELECT orders.order_date,sum(order_details.quantity*pizzas.price) AS revenue
FROM order_details JOIN pizzas
ON order_details.pizza_id = pizzas.pizza_id
JOIN orders
ON orders.order_id = order_details.order_id
GROUP BY orders.order_date) AS sales;


#Que13:- determine the top 3 most ordered pizza types based on revenue for each pizza category.

SELECT name, revenue FROM
(SELECT category, name, revenue, RANK() OVER(partition by category ORDER BY revenue DESC) AS rn FROM
(SELECT pizza_types.category, pizza_types.name, sum(order_details.quantity * pizzas.price) AS revenue
FROM pizza_types JOIN pizzas
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details
ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category, pizza_types.name) AS a) AS b
WHERE rn<=3;








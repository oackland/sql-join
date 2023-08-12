-- Week 5 - Wednesday Questions

-- 1. List all customers who live in Texas (use JOINs)
-- select district
-- from address
-- where district = 'Texas';

select first_name, last_name
    from customer c
    left join address a
    on c.address_id = a.address_id
where district = 'Texas';

--                 +----------+---------+
--                 |first_name|last_name|
--                 +----------+---------+
--                 |Jennifer  |Davis    |
--                 |Kim       |Cruz     |
--                 |Richard   |Mccrary  |
--                 |Bryan     |Hardison |
--                 |Ian       |Still    |
--                 +----------+---------+


-- 2. Get all payments above $6.99 with the Customer's Full Name
select customer.first_name || ' ' || customer.last_name as customer_name, payment.amount
from payment
         join customer on payment.customer_id = customer.customer_id
where payment.amount > 6.99;

--                  +---------------+------+
--                  |customer_name  |amount|
--                  +---------------+------+
--                  |Douglas Graf   |919.67|
--                  |Mary Smith     |478.86|
--                  |Alfredo Mcadams|74.94 |
--                  |~~~~~shorting~~|~~~~~~|
--                  |Peter Menard   |121.99|
--                  |Peter Menard   |127.99|
--                  |Peter Menard   |125.99|
--                  |Peter Menard   |123.99|
--                  |Peter Menard   |125.99|
--                  |Peter Menard   |121.99|
--                  |Peter Menard   |123.99|
--                  |Peter Menard   |123.99|
--                  |Peter Menard   |130.99|
--                  +---------------+------+

-- 3. Show all customers names who have made payments over $175(use subqueries)

select first_name || ' ' || last_name as names
from customer
where customer_id in (select customer_id
                      from payment
                      where amount > 175.00);

-- +------------+
-- |names       |
-- +------------+
-- |Mary Smith  |
-- |Douglas Graf|
-- +------------+

---------------------------------------------------------------------------------------------------------------------
-- 4. List all customers that live in Nepal (use the city table)

-- to achieve this target which is 3 tables away we need to state what do we want to pull from each table to confirm
-- we can actually getting the right data.

-- need country, city, address, customer

-- select country
-- from country
-- where country = 'Nepal';

-- +-------+
-- |country|
-- +-------+
-- |Nepal  |
-- +-------+


-- select country, city
-- from country
--          left join city
--                    on country.country_id = city.country_id
-- where country = 'Nepal';

-- +-------+-------+
-- |country|city   |
-- +-------+-------+
-- |Nepal  |Birgunj|
-- +-------+-------+


-- select country, city, address
-- from country
--          left join city
--                    on country.country_id = city.country_id
--          left join address a on city.city_id = a.city_id
-- where country = 'Nepal';

-- +-------+-------+-------------------+
-- |country|city   |address            |
-- +-------+-------+-------------------+
-- |Nepal  |Birgunj|470 Boksburg Street|
-- +-------+-------+-------------------+

--
-- select country, city, address, first_name
-- from country
--          left join city
--                    on country.country_id = city.country_id
--          left join address a on city.city_id = a.city_id
--          left join public.customer c on a.address_id = c.address_id
-- where country = 'Nepal';
-- Now we can clean table format...

SELECT first_name
FROM (SELECT country_id, country
      FROM country
      WHERE country = 'Nepal') AS filtered_country
         LEFT JOIN city ON filtered_country.country_id = city.country_id
         LEFT JOIN address a ON city.city_id = a.city_id
         LEFT JOIN customer c ON a.address_id = c.address_id;

                    -- +----------+
                    -- |first_name|
                    -- +----------+
                    -- |Kevin     |
                    -- +----------+




-- 5. Which staff member had the most
-- transactions?
-- by defaul we already know we need two tables. probably can be staff and payment but also can be rental
select customer_id, payment_id, first_name  from  payment
                               left join staff s on payment.staff_id = s.staff_id
group by payment_id, first_name
order by payment_id desc limit 1;
--     +-----------+----------+----------+
--    |customer_id | payment_id | first_name |
--    +-----------+----------+----------+
--     |264       | 32098       | Jon      |
--    +-----------+----------+----------+

-- 6. How many movies of each rating are
-- there?
-- like riding bike...

select rating, count(rating) as movies
from film
group by rating;


-- +------+------+
-- |rating|movies|
-- +------+------+
-- |NC-17 |209   |
-- |G     |178   |
-- |PG-13 |223   |
-- |PG    |194   |
-- |R     |196   |
-- +------+------+




-- 7.Show all customers who have made a single payment above $6.99 (Use Subqueries)
select first_name || ' ' ||last_name as Customers_with_single_value
from customer
where (select count(payment_id) from payment
                       where payment.customer_id = customer.customer_id and
                               payment.amount > 6.99) = 1;

-- +---------------------------+
-- |customers_with_single_value|
-- +---------------------------+
-- |Harold Martino             |
-- |Douglas Graf               |
-- |Alvin Deloach              |
-- |Alfredo Mcadams            |
-- +---------------------------+


-- 8. How many free rentals did our stores give away?
-- Long way
select count(amount) as freeFall
from rental r
join payment p on r.rental_id = p.rental_id
where amount = 0;



-- +--------+
-- |freefall|
-- +--------+
-- |0       |
-- +--------+


-- same result
select count(amount) as freeFall
from payment
where amount = 0;
-- +--------+
-- |freefall|
-- +--------+
-- |0       |
-- +--------+


select customer_id, payment_id, first_name
from payment
         left join staff s on payment.staff_id = s.staff_id
group by payment_id, first_name
order by payment_id desc
limit 1;
-- +-----------+----------+----------+
-- |customer_id|payment_id|first_name|
-- +-----------+----------+----------+
-- |264        |32098     |Jon       |
-- +-----------+----------+----------+

<h1>
Week 5 - Wednesday Questions
</h1>
<h3>1. List all customers who live in Texas (use JOINs)</h3>

```postgresql
select first_name, last_name
from customer c
         left join address a
                   on c.address_id = a.address_id
where district = 'Texas';
```

<p>This is a simple example of how a database is used to retrieve data <br>
user need First Name and Last Name, Database send data back to user.<br>
</p>

```mermaid
sequenceDiagram
    participant User
    participant Database
    User ->> Database: Execute SQL Query
    Database ->> Database: Retrieve Data
    Database -->> User: Result: First Name, Last Name

```
### Answer:
  |     | first\_name | last\_name |
  |-----|:------------|:-----------|
  |     | Jennifer    | Davis      |
  |     | Kim         | Cruz       |
  |     | Richard     | Mccrary    |      
  |     | Bryan       | Hardison   |
  |     | Ian         | Still      |
<hr/>

### 2. Get all payments above $6.99 with the Customer's Full Name

<p>
The important part of this query is to <strong style="color: orangered;
text-transform:uppercase">concatenate</strong> using  <code><"First Name">|| ' ' ||<"Last-Name"> </code>to get your 
<code><"Full Name">.</code>
</p>

```postgresql
select customer.first_name || ' ' || customer.last_name AS customer, payment.amount
from payment
join customer ON payment.customer_id = customer.customer_id
where payment.amount > 6.99;
```
```mermaid
graph TD
A[ User ] -->| 1 . Execute Query | B[ Application ];
B -->| 2 . Send Query | C[ Database ];
C -->| 3 . Process Query | D[ Retrieve Data ];
D -->|4 . Return Data | B;
B -->| 5 . Display Data | A;
```

### Answer:
shorted to fix document, copy the snip code to read in your computer 

| customer     | amount |
|:-------------|:-------|
| Douglas Graf | 919.67 |
| Mary Smith   | 478.86 |
| ~~~~~~~~~~~~ | ~~~~~~ |  
| Peter Menard | 123.99 |
| Peter Menard | 125.99 |
| Peter Menard | 121.99 |
| Peter Menard | 123.99 |
| Peter Menard | 123.99 |
| Peter Menard | 130.99 |

<hr/>

### 3. Show all customers names who have made payments over $175(use subquery)

```postgresql
select first_name || ' ' || last_name as names
from customer
where customer_id in (select customer_id
from payment
where amount > 175.00);
```

```mermaid
sequenceDiagram
    participant User
    participant Application
    participant Database

    User ->> Application: Execute SQL Query
    Application ->> Database: Query
    Database ->> Database: Process Outer Query
    Database ->> Database: Execute Subquery
    Database ->> Database: Process Subquery
    Database ->> Application: Return Subquery Result
    Database -->> Application: Subquery Result
    Database ->> Application: Return Result Set
    Application ->> User: Display Result Set
```

  ## Answer:
| customer\_name |
|:--------------:|
|   Mary Smith   |
|  Douglas Graf  |  


<hr/>

### 4. List all customers that live in Nepal (use the city table)

- to achieve this target which is 3 tables away we need to state what do we want to pull from each table to confirm
- we can actually getting the right data.

    - need country, city, address, customer
```mermaid
graph TD
A[ Retrieve Country Data ] --> B[ Filter by Country = 'Nepal' ];
B --> C[ Return Result ];
```
```postgresql
select country from country where country = 'Nepal';
```
```mermaid
graph TD
    A[Execute SQL Query] --> B[Retrieve Country and City Data];
    B --> C[Perform Left Join];
    C --> D[Filter by Country = 'Nepal'];
    D --> E[Return Result];
```
```postgresql
select country, city
from country
left join city
on country.country_id = city.country_id
where country = 'Nepal';
```
```mermaid
graph TD
    A[Execute SQL Query] --> B[Retrieve Country, City, and Address Data];
    B --> C[Perform First Left Join];
    C --> D[Perform Second Left Join];
    D --> E[Filter by Country = 'Nepal'];
    E --> F[Return Result];
```
```postgresql
select country, city, address
from country
left join city
on country.country_id = city.country_id
left join address a on city.city_id = a.city_id
where country = 'Nepal';
```
```mermaid
graph TD
    A[Execute SQL Query] --> B[Retrieve Country, City, and Address Data];
    B --> C[Perform First Left Join];
    C --> D[Perform Second Left Join];
    D --> E[Filter by Country = 'Nepal'];
    E --> F[Return Result];
```
```postgresql
select country, city, address, first_name
from country
left join city
on country.country_id = city.country_id
left join address a on city.city_id = a.city_id
left join public.customer c on a.address_id = c.address_id
where country = 'Nepal';
```
```mermaid
graph TD
A[ Execute SQL Query ] --> B[Retrieve Country, City, Address, and First Name Data ];
B --> C[ Perform First Left Join ];
C --> D[ Perform Second Left Join];
D --> E[ Perform Third Left Join ];
E --> F[ Filter by Country = 'Nepal' ];
F --> G[ Return Result ];
```
## Now we can clean table format...

```postgresql
SELECT first_name
FROM (SELECT country_id, country
FROM country
WHERE country = 'Nepal') AS filtered_country
LEFT JOIN city ON filtered_country.country_id = city.country_id
LEFT JOIN address a ON city.city_id = a.city_id
LEFT JOIN customer c ON a.address_id = c.address_id;
```

| first\_name |
| :--- |
| Kevin |

<hr/>

### 5. Which staff member had the most transactions?
By default, we know we need two tables.\
probably can be [staff] and [payment] but also can be [rental] table payment;

```postgresql
select customer_id, payment_id, first_name from payment
left join staff s on payment.staff_id = s.staff_id
group by payment_id, first_name
order by payment_id desc limit 1;
```
### Answer:
| customer\_id | payment\_id | first\_name |
|:-------------|:------------|:------------|
| 264          | 32098       | Jon         |

```mermaid
sequenceDiagram
  participant User
  participant Application
  participant Database

  User ->> Application: Execute SQL Query
  Application ->> Database: Query
  Database ->> Database: Process Query
  Database ->> Database: Perform Left Join
  Database ->> Database: Group Data by payment_id, first_name
  Database ->> Database: Order Data by payment_id DESC
  Database ->> Database: Limit Result to 1
  Database -->> Application: Result Set
  Application -->> User: Display Result Set
```
<hr/>
## 6. How many movies of each rating are there?

```postgresql
select rating, count(rating) as movies
from film
group by rating;
```
### Answer:
| rating | movie | 
|:-------|:------|
| NC-17  | 209   |
| G      | 178c  |
| PG-13  | 223   |
| PG     | 194   |
| R      | 196   |
<hr/>

### 7.Show all customers who have made a single payment above $6.99 (Use Subquery)

```postgresql
select first_name || ' ' ||last_name as Customers_with_single_value
from customer
where (select count(payment_id) from payment
where payment.customer_id = customer.customer_id and
payment.amount > 6.99) = 1;
```

| freefall |
| :--- |
| 0 |

<hr/>

### 8. How many free rentals did our stores give away?\
Long way
```postgresql
select count(amount) as freeFall
from rental r
join payment p on r.rental_id = p.rental_id
where amount = 0;
```

#### same result:

```postgresql
select count(amount) as freeFall
from payment
where amount = 0;
```

| customer\_id | payment\_id | first\_name |
|:-------------|:------------|:------------|
| 264          | 32098       | Jon         |

<hr/>
END

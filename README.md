# ETL:
ETL Pipeline and SQL You are a member of the Bebop, an eclectic interplanetary bar/ship dealing mostly in rare weapons. Your boss has recently tasked you with organizing the ship’s transactional data, as he is looking to make operations more efficient and increase booty for the ship. Section A: The transaction log includes invoice number, customer id, purchases, date, and planet of each transaction from 2010-2011. The log itself is in chronological order, but its fields are messy (e.g. dates can be strings or integers). Your boss anticipates you will turn the raw data into something that he will be able to examine and use easily. Please use Python to read the raw data file (located here: https://www.dropbox.com/s/11t5bbgggrekt85/data.csv.zip?dl=0) and clean and transform its fields.

# Database Design:
Load the processed data into a database of your choice (e.g. MySQL, PostgreSQL, etc.). You will need to install a database server on your computer if you don’t have one already.
Feel free to design the database schema as you see fit. However, it should at minimum include multiple dimension tables. We are looking for a sensible design that delivers efficient queries to the following questions. Please give us the SQL code you write to create the database/tables.

Please write SQL queries to answer the following questions. Give us both your SQL query and your answer. Specify any assumptions you make.
* How many unique customers does the Bebop have?
* Which customer is the second biggest customer by revenue, excluding cancellations?
* How many customers have visited the Bebop on multiple planets?
* Which product has had the most price changes?
* Which item attracts the most new customers?
* Which customer has the shortest average length of time between purchases?
* For each invoice, calculate the total revenue for each item and return the combined revenue of the top 3 items by revenue.
You can ignore invoices that have fewer than 3 items.

# Code Optimization:
Finish the Code Optimization Problem given in the notebook.

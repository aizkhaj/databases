# Answers

1. **In your own words, explain the benefits of normalization. Include a real-world scenario where normalization is necessary.**

    One of the main benefits of normalization is reducing data redundancy. What this means is having less duplicate data stored in your database, and it is organized into a separate table where things aren't overlapping with other similar data. This improves updating/writing efficiency to the database. A real world scenario where normalization could be necessary: A large retail store with many categories of items in their inventory. This would result in a large database that could require tables for each category of item sold.

2. **List and explain the different normal forms and how they relate to one another, with regard to your real-world scenario in the first question.**

    1NF: All occurences of an entity must contain the same number of columns. (aka don't have lists/arrays of varying amounts of information stored in a column/attribute).

    Suppose we have a table/entity for the different potato chips available by company. Instead of storing all flavors of the chips available by one company as a list, we want to create a new record for each available flavor in that table.

    2NF: The table must be 1NF, and all non-key fields must be a function of the primary key.

    In our scenario, suppose we have a table of 'products' with attributes 'suppliers' and 'prices'. To make this table 2NF, we can separate this table and create two tables where we products and suppliers + products and prices. This is because prices are a function of the product, but not necessarily the function of which supplier they come from - which is also a function of product.

    3NF: The table must be 2NF, and the table needs to ensure that transitive relationships between attributes don't exist.

    Suppose in our table of product and suppliers, we also have fields for the supplier's address by attributes of zip, city and state. In order to ensure 3NF, you want to create a table for suppliers and its address attributes since that would be transitive information in one table if we included it with the original table with products.

    BCNF: The table must be 3NF, as well as for every dependency X -> Y, X needs to be the super key of the table.

    Suppose we have a table where candidate keys: supplier_id, zip and functional dependencies: supplier_id -> supplier_name, and zip -> city, state. In order to make this table BCNF compliant, we would have the following tables:
     - Supplier_id (key) and supplier name,
     - zip (key) and city, state attributes,
     - supplier_id (key) and zip.

3. **This student_records table contains students and their grades in different subjects. The schema is already in first normal form (1NF). Convert this schema to the third normal form (3NF) using the techniques you learned in this checkpoint.**

    student_records:
    entry_id | student_id | professor_id | subject | grade
    ---|---|---|---|---
     1 | 1 | 2 | Philosophy | A
     2 | 2 | 2 | Philosophy | C
     3 | 3 | 1 | Economics | A
     4 | 4 | 3 | Mathematics | B
     5 | 5 | 1 | Economics | B

    student_information:
    student_id | student_email | student_name
    -----------|---------------|--------------
     1 | john.b20@hogwarts.edu | John B
     2 | sarah.s20@hogwarts.edu | Sarah S
     3 | martha.l20@hogwarts.edu| Martha L
     4 | james.g20@hogwarts.edu | James G
    5 | stanley.p20@hogwarts.edu| Stanley P

    professor_information:
    professor_id  |  professor_name
    --------------|-----------------
     1 | Natalie M
     2 | William C
     3 | Mark W

4. **In your own words, explain the potential disadvantages of normalizing the data above. What are its trade-offs? Submit your findings in the submission table and discuss them with your mentor in your next session.**

    Normalizing the above data can cause a slowdown in querying for the student's grades because you will now need to join a few tables in order to get to the same data that you could've queried without JOINs in place. However, on the plus side, you would have a quicker time updating student information since the tables are logically separated from the student's professor and grades.

5. **Looking at the tables you have normalized. If you need to denormalize to improve query performance or speed up reporting, how would you carry out denormalization for this database design? Submit potential strategies in the submission tab and discuss them with your mentor in your next session.**

    I would denormalize by including student and professor names to the student records table since an ad hoc query report may usually require such information alongside a student's grades.

6. **Explore the trade-offs between data normalization and denormalization in this scenario, submit your findings in the submission tab, and discuss them with your mentor in your next session.**

    This scenario would make it easier to check on available professors, student performance, and performance of different departments. However, things will run slower for queries involving the entire student population.
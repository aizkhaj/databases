# Answers to Subqueries Assignment

1. Explain a subquery in your own words.
  A subquery is where we use a nested query within another query. We can nest a query within WHERE, FROM or SELECT clauses.

2. Where can you use a subquery within a SELECT statement?
  Whenever you need to retrieve a calculation from another query, a subquery in the SELECT clause would work well.

3. When would you employ a subquery?
  When you are faced with problems that require you to solve "get facts from A, given conditionals from B". It's also more readable compared to a query with JOINs.

4. Explain a row constructor in your own words.
  A row constructor used in a subquery allows you to match and lookup values from different fields in a table.

5. What happens if a row in the subquery result provides a NULL value to the comparison?
  It returns NULL.

6. What are the ways to use a subquery within a WHERE clause? If you can't remember them, do these flashcards until you can.
  You can use the following within a WHERE clause: IN, NOT IN, EXISTS, NOT EXISTS, ALL, SOME, ANY.

7. Using this Adoption schema and data, please write queries to retrieve the following information and include the results:
    - All volunteers. If the volunteer is fostering a dog, include each dog as well.
      ```sql
      SELECT concat_ws(' ', volunteers.first_name, volunteers.last_name) AS volunteer_name, (SELECT dogs.name FROM dogs WHERE dogs.id = volunteers.foster_dog_id) AS dog_name
      FROM volunteers;
      ```

      volunteer_name | dog_name
      ----|----
      Albus Dumbledore | (null)
      Rubeus Hagrid | Munchkin
      Remus Lupin | (null)
      Sirius Black | (null)
      Marjorie Dursley | Marmaduke

    - The cat's name, adopter's name, and adopted date for each cat adopted within the past month to be displayed as part of the "Happy Tail" social media promotion which posts recent successful adoptions.

      ```sql
      SELECT cats.name AS cat_name, ad.adopter_name, ad.adoption_date
      FROM cats
      JOIN
        (SELECT concat_ws(' ', a.first_name, a.last_name) AS adopter_name, ca.date AS adoption_date, ca.cat_id
        FROM cat_adoptions ca
        JOIN adopters a
        ON ca.adopter_id = a.id) ad
      ON cats.id = ad.cat_id
      WHERE ad.adoption_date > '2018-05-01';
      ```

      cat_name | adopter_name | adoption_date
      ---|---|---
      Mushi | Arabella Figg | 2018-05-02
      Victoire | Argus Filch | 2018-05-07

    - Adopters who have not yet chosen a dog to adopt and generate all possible combinations of adopters and available dogs.

      ```sql
      SELECT concat_ws(' ', adopters.first_name, adopters.last_name) AS adopter_name, dogs.name as dog_name
      FROM adopters
      JOIN (
        dogs JOIN dog_adoptions ON dogs.id NOT IN (SELECT dog_adoptions.dog_id FROM dog_adoptions)
      ) ON adopters.id NOT IN (SELECT dog_adoptions.adopter_id FROM dog_adoptions)
      ORDER BY adopters.id;
      ```

      adopter_name | dog_name
      ---|---|---
      Hermione Granger | Boujee
      Hermione Granger | Munchkin
      Hermione Granger | Marley
      Hermione Granger | Lassie
      Hermione Granger | Marmaduke
      Arabella Figg | Boujee
      Arabella Figg | Munchkin
      Arabella Figg | Marley
      Arabella Figg | Lassie
      Arabella Figg | Marmaduke

    - Lists of all cats and all dogs who have not been adopted.

      ```sql
      SELECT cats.name AS pet_name
      FROM cats
      JOIN cat_adoptions ON cats.id NOT IN (SELECT cat_adoptions.cat_id FROM cat_adoptions)
      UNION
      SELECT dogs.name AS pet_name
      FROM dogs
      JOIN dog_adoptions ON dogs.id NOT IN (SELECT dog_adoptions.dog_id FROM dog_adoptions);
      ```

      pet_name |
      ----|
      Boujee |
      Lassie |
      Marley |
      Marmaduke |
      Munchkin |
      Nala |
      Seashell |

    - The name of the person who adopted Rosco.

      ```sql
      SELECT concat_ws(' ', adopters.first_name, adopters.last_name) AS adopter_name
      FROM adopters
      JOIN dog_adoptions ON adopters.id = dog_adoptions.adopter_id
      WHERE 'Rosco' IN
        (SELECT dogs.name
        FROM dogs
        JOIN dog_adoptions ON dogs.id = dog_adoptions.dog_id);
      ```

      adopter_name |
      ---|
      Argus Filch |

8. Using this Library schema and data, write queries applying the following scenarios, and include the results:
    - To determine if the library should buy more copies of a given book, please provide the names and position, in order, of all of the patrons with a hold (request for a book with all copies checked out) on "Advanced Potion-Making".
      ```sql
      SELECT holds.rank, (SELECT patrons.name FROM patrons WHERE patrons.id = holds.patron_id) AS name
      FROM holds
      WHERE isbn IN
        (SELECT books.isbn
        FROM books
        WHERE books.title = 'Advanced Potion-Making')
      ORDER BY holds.rank;
      ```

      | rank | name |
      |---|---|
      | 1 | Terry Boot|
      | 2 | Cedric Diggory|

    - Make a list of all book titles and denote whether or not a copy of that book is checked out.
      ```sql
      SELECT books.title,
        max(CASE WHEN transactions.checked_in_date is NULL THEN 'true'
            ELSE 'false'
        END) AS "checked out"
      FROM books
      LEFT OUTER JOIN transactions ON books.isbn IN
        (SELECT transactions.isbn
        FROM transactions)
      WHERE books.isbn = transactions.isbn
      GROUP BY books.title;
      ```

      title | checked out
      ---|---
      Fantastic Beasts and Where to Find Them | true
      Advanced Potion-Making | true
      Hogwarts: A History | false

    - In an effort to learn which books take longer to read, the librarians would like you to create a list of average checked out time by book name in the past month.
      ```sql
      SELECT books.title, avg(t.check_out_duration) as average_check_out_duration_past_month
      FROM books
      JOIN (
        SELECT isbn, date_part('day', age(checked_in_date, checked_out_date)) as check_out_duration
        FROM transactions
        WHERE checked_out_date > '2018-05-01'
        AND checked_in_date IS NOT NULL) t
        ON books.isbn = t.isbn
      GROUP BY books.title;
      ```

      title | average_check_out_duration_past_month
      ---|---
      Fantastic Beasts and Where to Find Them | 2.5

    - In order to learn which items should be retired, make a list of all books that have not been checked out in the past 5 years.
      ```sql
      SELECT books.title
      FROM books
      JOIN transactions ON books.isbn NOT IN
        (SELECT transactions.isbn
        FROM transactions
        WHERE transactions.checked_out_date > CURRENT_DATE - INTERVAL '5 years')
      WHERE books.isbn = transactions.isbn;
      ```

      title |
      ---|
      Hogwarts: A History |

    - List all of the library patrons. If they have one or more books checked out, correspond the books to the patrons.
      ```sql
      SELECT patrons.name,
      CASE WHEN book.title IS NULL THEN 'none'
      ELSE book.title
      END AS books_checked_out
      FROM patrons
      LEFT JOIN (
          SELECT books.title, transactions.patron_id
          FROM books
          JOIN transactions ON books.isbn = transactions.isbn
          WHERE transactions.checked_in_date IS NULL
        ) book
      ON patrons.id = book.patron_id;
      ```

      name | books_checked_out
      ---|---
      Hermione Granger | none
      Terry Boot | Advanced Potion-Making
      Padma Patil | none
      Cho Chang | none
      Cedric Diggory | Fantastic Beasts and Where to Find Them

9. Using this Flight schema and data, write queries applying the following scenarios, and include the results:
    - To determine the most profitable airplanes, find all airplane models where each flight has had over 250 paying customers in the past month.
      ```sql
      SELECT airplanes.model
      FROM airplanes
      JOIN (
          SELECT flights.flight_number, flights.airplane_model, date
          FROM flights
          JOIN transactions ON flights.flight_number = transactions.flight_number
          WHERE transactions.seats_sold > 250
        ) f
      ON airplanes.model = f.airplane_model
      WHERE date > '2018-05-01';
      ```

      model |
      ---|
      Airbus A330 |
      Boeing 777 |
      Airbus A380 |

    - To determine the most profitable flights, find all destination-origin pairs where 90% or more of the seats have been sold in the past month.
      ```sql
      SELECT ft.flight_number, ROUND(ft.seats_sold * 100.0 / airplanes.seat_capacity, 1) AS percent_capacity_sold
      FROM airplanes
      JOIN (
        SELECT f.flight_number, t.seats_sold, f.airplane_model, t.date
        FROM flights f
        JOIN transactions t ON f.flight_number = t.flight_number
        ) ft
      ON airplanes.model = ft.airplane_model
      WHERE ROUND(ft.seats_sold * 100.0 / airplanes.seat_capacity, 1) > 90 AND ft.date > '2018-05-01';
      ```

      flight_number | percent_capacity_sold
      ---|---
      137 | 100
      8932 | 95
      57 | 90.1

    - The airline is looking to expand its presence in Asia and globally. Find the total revenue of any flight (not time restricted) arriving at or departing from Singapore (SIN).
      ```sql
      SELECT t.total_revenue AS total_revenue_for_flights_from_to_sin
      FROM transactions t
      JOIN (
        SELECT flight_number
        FROM flights
        WHERE flights.origin = 'SIN' OR flights.destination = 'SIN') f
      ON t.flight_number = f.flight_number;
      ```

      total_revenue_for_flights_from_to_sin |
      ---|
      250394.7 |
      131992.12 |

10. Compare the subqueries you've written above. Compare them to the joins you wrote in Checkpoint 6. Which ones are more readable? Which were more logical to write?

    Subqueries are a lot more logical to read and write for me. It is easier to visualize, in one SQL statement, what to do with data without going through multiple JOIN clauses connecting multiple tables.
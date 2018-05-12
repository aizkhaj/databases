CREATE TABLE guests (
  id integer,
  name text,
  email text,
  city text,
  phone_number numeric(10)
);

CREATE TABLE rooms (
  room_number integer,
  bed_type text
);

CREATE TABLE bookings (
  id integer,
  guest_id integer,
  room_number integer,
  check_in_date date,
  check_out_date date
);

INSERT INTO guests (id, name, email, city, phone_number)
VALUES
(1, 'Woody', 'woody@gmail.com', 'Houston', 1234567890),
(2, 'Buzz', 'buzz@gmail.com', 'Seoul', 7890123456),
(3, 'Andy', 'andy@gmail.com', 'Toronto', 6476011234),
(4, 'Deadpool', 'deadpool@gmail.com', 'New York', 9876543210);

INSERT INTO rooms (room_number, bed_type)
VALUES
(101, 'King'),
(102, 'King'),
(103, 'Double'),
(104, 'Double'),
(105, 'Double');

INSERT INTO bookings (id, guest_id, room_number, check_in_date, check_out_date)
VALUES
(1, 2, 103, '01-05-2018', '01-07-2018'),
(2, 3, 104, '01-19-2018', '01-20-2018'),
(3, 3, 105, '01-19-2018', '01-20-2018'),
(4, 4, 101, '01-20-2018', '01-21-2018'),
(5, 4, 101, '01-29-2018', '01-30-2018'),
(6, 2, 104, '02-01-2018', '02-03-2018');

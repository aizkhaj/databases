CREATE TABLE students (
  student_id integer,
  name text
);

CREATE TABLE classes (
  class_id integer,
  subject_name text
);

CREATE TABLE enrollments (
  enrollment_id integer,
  student_id integer,
  class_id integer,
  grades text
);

INSERT INTO students (student_id, name)
VALUES
(1, 'Aizaz'),
(2, 'Rob'),
(3, 'Will'),
(4, 'Harambe'),
(5, 'Judo');

INSERT INTO classes (class_id, subject_name)
VALUES
(1, 'history'),
(2, 'art'),
(3, 'english'),
(4, 'math'),
(5, 'IT');

INSERT INTO enrollments (enrollment_id, student_id, class_id, grades)
VALUES
(1, 1, 5, 'A'),
(2, 1, 2, 'B'),
(3, 2, 3, 'C'),
(4, 2, 4, 'F'),
(5, 3, 5, 'B'),
(6, 3, 4, 'A'),
(7, 4, 1, 'D'),
(8, 4, 2, 'A'),
(9, 4, 4, 'A'),
(10, 5, 5, 'C'),
(11, 5, 4, 'B');
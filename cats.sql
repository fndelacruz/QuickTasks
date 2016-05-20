CREATE TABLE cats (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  owner_id INTEGER,

  FOREIGN KEY(owner_id) REFERENCES user(id)
);

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
);

INSERT INTO
  users (id, fname, lname, house_id)
VALUES
  (1, "Devon", "Watts", 1),
  (2, "Matt", "Rubens", 1),
  (3, "Ned", "Ruggeri", 2),
  (4, "Catless", "User", NULL);

INSERT INTO
  cats (id, name, owner_id)
VALUES
  (1, "Breakfast", 1),
  (2, "Earl", 2),
  (3, "Haskell", 3),
  (4, "Markov", 3),
  (5, "Stray Cat", NULL);

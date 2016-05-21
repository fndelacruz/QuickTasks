CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  username VARCHAR(255) NOT NULL UNIQUE,
  password_digest VARCHAR(255) NOT NULL,
  session_token VARCHAR(255) NOT NULL
);

CREATE TABLE cats (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  owner_id INTEGER,

  FOREIGN KEY(owner_id) REFERENCES user(id)
);

INSERT INTO
  users (id, username, password_digest, session_token)
VALUES
  (1, "ann", "$2a$10$3RJS57NpWPzzE0CnmtKlIOgLHycTzUdbBFLU7IYaxMURma3mVSfMy", "aj2ap_dhZY8_xe7jyw_Qiw"),
  (2, "bob", "$2a$10$aRu6vSmdKAwjognexU1NA.oFwKzSYAed1hv.Lfzzw/KPPHVa6l8GO", "D1tvalzlpTNoZzmFPYJDdw"),
  (3, "cat", "$2a$10$jR3lq4aMT4luapJvdGU3P.xuwlyGgLEJ2b6Q2d6nvUsE9/f8BGMFy", "-erk19yI4qE7Pi-zAS6vKw"),
  (4, "dan", "$2a$10$QDW/103lax4PBypIbo8K1.11rGphao6re19e5zC6pUe/WbYzpHxXq", "owncOQuezi_19Whe-PG27g");

INSERT INTO
  cats (id, name, owner_id)
VALUES
  (1, "Breakfast", 1),
  (2, "Earl", 2),
  (3, "Haskell", 3),
  (4, "Markov", 3),
  (5, "Stray Cat", NULL);

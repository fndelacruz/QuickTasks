CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  username VARCHAR(255) NOT NULL UNIQUE,
  password_digest VARCHAR(255) NOT NULL,
  session_token VARCHAR(255) NOT NULL
);

CREATE TABLE tasks (
  id INTEGER PRIMARY KEY,
  complete INTEGER DEFAULT 0,
  content VARCHAR(255) NOT NULL,
  owner_id INTEGER NOT NULL,

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
  tasks (id, content, owner_id)
VALUES
  (1, "Play ball", 1),
  (2, "Buy food", 2),
  (3, "Order pizza", 3),
  (4, "Harvest carrots", 3);

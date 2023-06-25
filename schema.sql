DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS posts;
DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS likes;
DROP TABLE IF EXISTS follows;
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS post_tags;
DROP TABLE IF EXISTS clients;
DROP TABLE IF EXISTS projects;
DROP TABLE IF EXISTS invoices;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS expenses;
DROP TABLE IF EXISTS project_expenses;
DROP TABLE IF EXISTS project_tasks;


CREATE TABLE users (
  user_id SERIAL PRIMARY KEY,
  username VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE posts (
  post_id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  author_id INTEGER NOT NULL,
  FOREIGN KEY (author_id) REFERENCES user(user_id)
);

CREATE TABLE comments (
  comment_id SERIAL PRIMARY KEY,
  body TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  author_id INTEGER NOT NULL,
  post_id INTEGER NOT NULL,
  FOREIGN KEY (author_id) REFERENCES user(user_id),
  FOREIGN KEY (post_id) REFERENCES post(post_id)
);

CREATE TABLE likes (
  like_id SERIAL PRIMARY KEY,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  author_id INTEGER NOT NULL,
  post_id INTEGER NOT NULL,
  FOREIGN KEY (author_id) REFERENCES user(user_id),
  FOREIGN KEY (post_id) REFERENCES post(post_id)
);

CREATE TABLE follows (
  follow_id SERIAL PRIMARY KEY,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  follower_id INTEGER NOT NULL,
  followee_id INTEGER NOT NULL,
  FOREIGN KEY (follower_id) REFERENCES user(user_id),
  FOREIGN KEY (followee_id) REFERENCES user(user_id)
);

CREATE TABLE tags (
  tag_id SERIAL PRIMARY KEY,
  tag_name VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE post_tags (
  post_tag_id SERIAL PRIMARY KEY,
  post_id INTEGER NOT NULL,
  tag_id INTEGER NOT NULL,
  FOREIGN KEY (post_id) REFERENCES post(post_id),
  FOREIGN KEY (tag_id) REFERENCES tag(tag_id)
);

CREATE TABLE clients (
  client_id SERIAL PRIMARY KEY,
  first_name VARCHAR(255) UNIQUE NOT NULL,
  last_name VARCHAR(255) UNIQUE NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  phone VARCHAR(255) UNIQUE NOT NULL,
  address_1 VARCHAR(255),
  address_2 VARCHAR(255),
  address_3 VARCHAR(255),
  city VARCHAR(255),
  state VARCHAR(2),
  zipcode VARCHAR(5),
  added_on TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  preferred_payment_method VARCHAR(255),
  client_notes TEXT,
  referral VARCHAR(255)
);

CREATE TABLE projects (
  project_id SERIAL PRIMARY KEY,
  client_id INTEGER NOT NULL,
  project_name VARCHAR(255) NOT NULL UNIQUE,
  project_description TEXT NOT NULL,
  project_notes TEXT,
  project_status VARCHAR(255),
  project_type VARCHAR(255),
  project_start_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  project_end_date TIMESTAMP,
  due_date DATE,
  estimated_time VARCHAR(255),
  estimated_hours INTEGER,
  isHourly BOOLEAN,
  isProjectFee BOOLEAN,
  hourly_rate NUMERIC(10,2),
  project_fee NUMERIC(10,2),
  isFinished BOOLEAN DEFAULT FALSE,
  finished_on TIMESTAMP,
  FOREIGN KEY (client_id) REFERENCES client(client_id)
);

CREATE TABLE invoices (
  invoice_id SERIAL PRIMARY KEY,
  project_id INTEGER NOT NULL,
  invoice_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  due_date DATE,
  amount_due NUMERIC(10,2),
  amount_paid NUMERIC(10,2),
  remaining_balance NUMERIC(10,2),
  FOREIGN KEY (project_id) REFERENCES project(project_id)
);

CREATE TABLE payments (
  payment_id SERIAL PRIMARY KEY,
  invoice_id INTEGER NOT NULL,
  payment_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  payment_amount NUMERIC(10,2),
  payment_method VARCHAR(255),
  FOREIGN KEY (invoice_id) REFERENCES invoice(invoice_id)
);

CREATE TABLE expenses (
  expense_id SERIAL PRIMARY KEY,
  expense_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  expense_amount NUMERIC(10,2),
  expense_description TEXT,
  expense_type VARCHAR(255),
  project_id INTEGER,
  FOREIGN KEY (project_id) REFERENCES project(project_id)
);

CREATE TABLE project_expenses (
  project_expense_id SERIAL PRIMARY KEY,
  project_id INTEGER NOT NULL,
  expense_id INTEGER NOT NULL,
  FOREIGN KEY (project_id) REFERENCES project(project_id),
  FOREIGN KEY (expense_id) REFERENCES expense(expense_id)
);

CREATE TABLE project_tasks (
  project_task_id SERIAL PRIMARY KEY,
  project_id INTEGER NOT NULL,
  task_name VARCHAR(255) NOT NULL,
  task_description TEXT NOT NULL,
  task_status VARCHAR(255),
  task_start_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  task_end_date TIMESTAMP,
  due_date DATE,
  hours_spent INTEGER,
  isFinished BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (project_id) REFERENCES project(project_id)
);
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS user;
DROP TABLE IF EXISTS task;
DROP TABLE IF EXISTS activity;

CREATE TABLE category (
	id int auto_increment primary key NOT NULL,
    name varchar(10) NOT NULL,
    is_deleted boolean NOT NULL DEFAULT FALSE,
    created_date_time datetime NOT NULL DEFAULT current_timestamp
);

CREATE TABLE user (
	id int auto_increment primary key NOT NULL,
    name varchar(16) NOT NULL,
    password varchar(15) NOT NULL
);

CREATE TABLE task (
	id int auto_increment primary key NOT NULL,
    title varchar(500) NOT NULL,
    content varchar(500) NOT NULL,
    is_deleted boolean NOT NULL DEFAULT FALSE,
    user_name varchar(500),
    priority int NOT NULL,
    category int NOT NULL references category(id) ON UPDATE CASCADE,
    category_key int NOT NULL,
    user int NOT NULL references user(id) ON UPDATE CASCADE,
    user_key int NOT NULL
);

CREATE TABLE activity (
	id int auto_increment primary key NOT NULL,
    created_date datetime NOT NULL DEFAULT current_timestamp,
    action varchar(45) NOT NULL,
    category_from varchar(45),
    category_to varchar(45),
    task int NOT NULL references task(id) ON UPDATE CASCADE,
    task_key int NOT NULL
);
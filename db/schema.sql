CREATE TABLE projects (
	id SERIAL PRIMARY KEY,
	title VARCHAR(256) UNIQUE NOT NULL,
	description VARCHAR(1024),
	start_date TIMESTAMP NOT NULL,
	end_date TIMESTAMP NOT NULL CHECK (end_date > start_date),
	goal NUMERIC(16, 2) NOT NULL CHECK (goal > 0)
);

CREATE TABLE users (
	email VARCHAR(256) PRIMARY KEY,
	first_name VARCHAR(256) NOT NULL,
	last_name VARCHAR(256) NOT NULL,
	is_admin BOOLEAN NOT NULL
);

CREATE TABLE keywords (
	word VARCHAR(64) PRIMARY KEY
);

CREATE TABLE funds (
	amount NUMERIC(16, 2) NOT NULL CHECK (amount > 0),
	project_id INT NOT NULL,
	user_email VARCHAR(256) NOT NULL,
	PRIMARY KEY (project_id, user_email),
	FOREIGN KEY (project_id)
		REFERENCES projects(id)
		ON DELETE CASCADE,
	FOREIGN KEY (user_email)
		REFERENCES users(email)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE created_by (
	user_email VARCHAR(256) NOT NULL,
	project_id INT UNIQUE NOT NULL,
	PRIMARY KEY (user_email, project_id),
	FOREIGN KEY (project_id)
		REFERENCES projects(id)
		ON DELETE CASCADE,
	FOREIGN KEY (user_email)
		REFERENCES users(email)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE has_keyword (
	keyword VARCHAR(64) NOT NULL,
	project_id INT NOT NULL,
	PRIMARY KEY (keyword, project_id),
	FOREIGN KEY (keyword)
		REFERENCES keywords(word)
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY (project_id)
		REFERENCES projects(id)
		ON DELETE CASCADE
);

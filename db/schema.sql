CREATE TABLE users (
	email VARCHAR(256) PRIMARY KEY,
	first_name VARCHAR(256) NOT NULL,
	last_name VARCHAR(256) NOT NULL,
    password VARCHAR(256) NOT NULL,
	is_admin BOOLEAN NOT NULL
);

CREATE TABLE projects (
	project_id SERIAL PRIMARY KEY,
	title VARCHAR(256) NOT NULL,
	description VARCHAR(1024),
	start_date TIMESTAMP NOT NULL,
	end_date TIMESTAMP NOT NULL CHECK (end_date > start_date),
	goal NUMERIC NOT NULL CHECK (goal > 0),
    current_funding NUMERIC NOT NULL CHECK (current_funding >= 0) DEFAULT 0,
    creator_email VARCHAR(256),
    status VARCHAR(16) CHECK (status='ongoing' OR status='closed'),
    FOREIGN KEY (creator_email)
        REFERENCES users(email)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE keywords (
	word VARCHAR(64) PRIMARY KEY
);

CREATE TABLE funds (
    fund_id SERIAL,
    date_funded TIMESTAMP NOT NULL DEFAULT NOW(),
	amount NUMERIC(16, 2) NOT NULL CHECK (amount > 0),
	project_id INT NOT NULL,
	user_email VARCHAR(256) NOT NULL,
	PRIMARY KEY (fund_id),
	FOREIGN KEY (project_id)
		REFERENCES projects(project_id)
        ON UPDATE CASCADE
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
		REFERENCES projects(project_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


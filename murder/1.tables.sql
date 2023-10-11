CREATE OR REPLACE TABLE crime_scene_report (
	date	integer,
	type	VARCHAR,
	description	VARCHAR,
	city	VARCHAR
);
CREATE OR REPLACE TABLE drivers_license (
	id	integer,
	age	integer,
	height	integer,
	eye_color	VARCHAR,
	hair_color	VARCHAR,
	gender	VARCHAR,
	plate_number	VARCHAR,
	car_make	VARCHAR,
	car_model	VARCHAR,
	PRIMARY KEY(id)
);

CREATE OR REPLACE TABLE income (
	ssn	VARCHAR,
	annual_income	integer,
	PRIMARY KEY(ssn)
);
CREATE OR REPLACE TABLE person (
	id	integer,
	name	VARCHAR,
	license_id	integer,
	address_number	integer,
	address_street_name	VARCHAR,
	ssn	VARCHAR,
	PRIMARY KEY(id),
	FOREIGN KEY(ssn) REFERENCES income(ssn),
	FOREIGN KEY(license_id) REFERENCES drivers_license(id)
);
CREATE OR REPLACE TABLE get_fit_now_member (
	id	VARCHAR,
	person_id	integer,
	name	VARCHAR,
	membership_start_date	integer,
	membership_status	VARCHAR,
	PRIMARY KEY(id),
	FOREIGN KEY(person_id) REFERENCES person(id)
);



CREATE OR REPLACE TABLE get_fit_now_check_in (
	membership_id	VARCHAR,
	check_in_date	integer,
	check_in_time	integer,
	check_out_time	integer,
	FOREIGN KEY(membership_id) REFERENCES get_fit_now_member(id)
);
CREATE OR REPLACE TABLE solution (
	user	integer,
	value	VARCHAR
);


CREATE OR REPLACE TABLE facebook_event_checkin (
	person_id	integer,
	event_id	integer,
	event_name	VARCHAR,
	date	integer,
	FOREIGN KEY(person_id) REFERENCES person(id)
);
CREATE OR REPLACE TABLE interview (
	person_id	integer,
	transcript	VARCHAR,
	FOREIGN KEY(person_id) REFERENCES person(id)
);

-- create table for intense fires
BEGIN;
	CREATE TABLE intense (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		acq_date TEXT,
		frp REAL,
		frp_str TEXT,
		brightness REAL,
		temp_c REAL
	);
	SELECT AddGeometryColumn('intense', 'geom', 4326, 'POINT', 'XY');
	SELECT CreateSpatialIndex('intense', 'geom');
	CREATE INDEX acq_date_intense_index ON intense (acq_date);
	CREATE INDEX frp_intense_index ON intense (frp);
	CREATE INDEX frp_str_intense_index ON intense (frp_str);
	CREATE INDEX brightness_intense_index ON intense (brightness);
	CREATE INDEX temp_c_intense_index ON intense (temp_c);
COMMIT;

-- create table for recent fires
BEGIN;
	CREATE TABLE recent (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		acq_date TEXT,
		frp REAL,
		frp_str TEXT,		
		brightness REAL,
		temp_c REAL
	);
	SELECT AddGeometryColumn('recent', 'geom', 4326, 'POINT', 'XY');
	SELECT CreateSpatialIndex('recent', 'geom');	
	CREATE INDEX acq_date_recent_index ON recent (acq_date);
	CREATE INDEX frp_recent_index ON recent (frp);
	CREATE INDEX frp_str_recent_index ON recent (frp_str);
	CREATE INDEX brightness_recent_index ON recent (brightness);
	CREATE INDEX temp_c_recent_index ON recent (temp_c);
COMMIT;

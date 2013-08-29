-- INTENSE FIRES TABLE 
BEGIN;

	-- insert top 200 intense fires from fires table
	INSERT INTO intense	(acq_date, frp, frp_str, brightness, temp_c, geom)
		SELECT 
			strftime('%Y-%m-%d', acq_date),			
			frp,
			frp,
			BRIGHTNESS,
			round((brightness - 273.15), 2),
			Geometry
		FROM
			fires
		ORDER BY frp DESC
			LIMIT 200;

	-- delete duplicates
	DELETE FROM intense
		WHERE rowid NOT IN
        (
        SELECT  min(rowid)
        FROM    intense
        GROUP BY
                ACQ_DATE
        ,       frp
        );
        
  -- keep only 200 records
  delete 
  	from intense 
  	where frp < (
  		select min(frp) 
  			from (
  				select frp 
  				from intense 
  				ORDER BY frp DESC 
  				LIMIT 200
  			)
  		);

	-- format FRP_STR to string with thousand separator 
	UPDATE intense 
		SET FRP_STR = 
			cast(cast(frp as integer)/1000 as text) || '.'  || cast(cast(frp as integer) % 1000 as text) || ',' || substr(frp,length(cast(frp as text)),1) 
		WHERE FRP >= 1000 ;

COMMIT;




-- insert fires from last month
BEGIN;
	DELETE FROM recent; -- clear recent fires table
	INSERT INTO recent (acq_date, frp, frp_str, brightness, temp_c, geom)
		SELECT
			strftime('%Y-%m-%d', acq_date) as date,			
			frp,
			frp,
			BRIGHTNESS,
			round((brightness - 273.15), 2),
			Geometry
		FROM fires
		WHERE 
			date >= 
			(SELECT date(acq_date,'-1 month') FROM fires ORDER BY acq_date DESC LIMIT 1) -- 1 month prior latest observation
		ORDER BY acq_date DESC;
		
	-- format FRP_STR to string with thousand separator 
	UPDATE recent 
		SET FRP_STR = 
			cast(cast(frp as integer)/1000 as text) || '.'  || cast(cast(frp as integer) % 1000 as text) || ',' || substr(frp,length(cast(frp as text)),1) 
		WHERE FRP >= 1000 ;
COMMIT;

-- delete fires table
BEGIN;
	DROP TABLE FIRES;
	SELECT DiscardGeometryColumn('fires','Geometry');
COMMIT;

VACUUM;

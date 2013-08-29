## Fires

## Updating data

1. Clone this repository locally;

1. Unzip data.zip at 'data' folder;

1. Download source file (extents West South East North: -85 -59 -29 16 ) at:

		http://firms.modaps.eosdis.nasa.gov/download/

1. Unzip the downloaded file at `data` folder;

1. Import downloaded files, replacing {new_data_file} with download filename without extension:

		spatialite_tool -i -shp data/{new_data_file} -d data/fires.sqlite -t fires -c UTF-8 -s 4326
	
1. Update recent and intense fires information at database:

		spatialite data/fires.sqlite < sql/update.sql

1. Symlink TileMill projects:

		ln -s /path/to/repository/tilemill/fires-intense ~/Documents/Mapbox/project 
		ln -s /path/to/repository/tilemill/fires-recent ~/Documents/Mapbox/project	

1. Regenerate maps and upload to Mapbox:

1. Commit changes to GitHub.

## Regenarating data from scratch

Download source files, spliting by 3-4 years periods, e.g. 2000 to 2003, 2004-2006, 2007-2009,2010-2012, and so forth.

Merge then with the following commands:

		ogr2ogr -select "ACQ_DATE","BRIGHTNESS","FRP" fires.shp fires_2000-2003.shp
		ogr2ogr -append -select "ACQ_DATE","BRIGHTNESS","FRP" fires.shp fires_2004-2006.shp
		ogr2ogr -append -select "ACQ_DATE","BRIGHTNESS","FRP" fires.shp fires_2007-2009.shp
		ogr2ogr -append -select "ACQ_DATE","BRIGHTNESS","FRP" fires.shp fires_2010-2012.shp
		ogr2ogr -append -select "ACQ_DATE","BRIGHTNESS","FRP" fires.shp fires_2013.shp
	
Init a Spatialite database with this data:

		spatialite_tool -i -shp data/fires -d data/fires.sqlite -t fires -c UTF-8 -s 4326
	
Create recent and intense tables:

		spatialite data/fires.sqlite < sql/create.sql

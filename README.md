## Fires

This is the repository for TileMill project of maps for intense and recent fires at infoamazonia.org.

### Loading maps locally

1. Clone this repository at your machine;

1. Symlink TileMill projects:

		ln -s /path/to/repository/tilemill/fires-intense ~/Documents/Mapbox/project 
		ln -s /path/to/repository/tilemill/fires-recent ~/Documents/Mapbox/project	

### Updating data

1. Download new data setting extents (West South East North) = (-85 -59 -29 16):

    http://firms.modaps.eosdis.nasa.gov/download/

1. Unzip the downloaded file at `data` folder;

1. Import downloaded files, replacing {new_data_file} with downloaded filename, without extension:

		spatialite_tool -i -shp data/{new_data_file} -d data/fires.sqlite -t fires -c UTF-8 -s 4326
	
1. Update recent and intense fires information at database:

		spatialite data/fires.sqlite < sql/update.sql

1. Regenerate maps and upload to Mapbox:

1. Commit changes to GitHub.

### Regenarating data from scratch

If you need to regenate from scratch, download source files spliting by 3-4 years periods, e.g. 2000 to 2003, 2004-2006, 2007-2009,2010-2012, and so forth.

Merge then:

		ogr2ogr -select "ACQ_DATE","BRIGHTNESS","FRP" fires.shp fires_2000-2003.shp
		ogr2ogr -append -select "ACQ_DATE","BRIGHTNESS","FRP" fires.shp fires_2004-2006.shp
		ogr2ogr -append -select "ACQ_DATE","BRIGHTNESS","FRP" fires.shp fires_2007-2009.shp
		ogr2ogr -append -select "ACQ_DATE","BRIGHTNESS","FRP" fires.shp fires_2010-2012.shp
		ogr2ogr -append -select "ACQ_DATE","BRIGHTNESS","FRP" fires.shp fires_2013.shp
	
Init a Spatialite database with this data:

		spatialite_tool -i -shp data/fires -d data/fires.sqlite -t fires -c UTF-8 -s 4326
	
Create recent and intense tables:

		spatialite data/fires.sqlite < sql/create.sql

## Fires

This is the repository for TileMill project of maps for intense and recent fires at infoamazonia.org.

### Loading maps locally

1. Clone this repository at your machine;

```    
    git clone git@github.com:oeco/tm-fires-nasa.git
```

1. Symlink TileMill projects:

		ln -s /path/to/repository/tilemill/fires-intense ~/Documents/Mapbox/project/fires-intense 
		ln -s /path/to/repository/tilemill/fires-recent ~/Documents/Mapbox/project/fires-recent	

### Updating data

1. Download new data setting extents (West South East North) = (-85 -59 -29 16):

    http://firms.modaps.eosdis.nasa.gov/download/

1. Unzip the downloaded file at `data` folder;

1. Import downloaded files, replacing 'new_data_filename' with downloaded filename **without extension**:

		cd data
		spatialite_tool -i -shp new_data_filename -d fires.sqlite -t fires -c UTF-8 -s 4326
		spatialite fires.sqlite < ../sql/update.sql

1. Update month and year at legend and teaser texts. 

1. Regenerate maps and upload to Mapbox:

1. Commit changes to GitHub.

### Changing the legends

1. Log in at the InfoAmazonia Wordpress JEO platform
2. Go to the 'Maps' section and enter on Fire map
3. On the 'HTML Legend' box, on the right hand column change the legend according to the month in 3 languages 

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
		

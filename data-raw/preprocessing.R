library(dplyr)
library(readr)
library(devtools)

################################################################################
# The following files are not included in git and have to be dropped into      #
# data-raw manually:                                                           #
#   - 3_Catchment_streamflow_mm.csv                                            #
#   - 1_Catchment_attributes.csv                                               #
#   - cr2_qflxDaily_2017_stations.txt                                          #
#                                                                              #
# Source:                                                                      #
# http://www.cr2.cl/recursos-y-publicaciones/bases-de-datos/datos-de-caudales/ #
# http://www.cr2.cl/download/camels-cl/                                        #
#                                                                              #
################################################################################



################################################################################
# Reformat discharge data into multivariate series readable by zoo             #
################################################################################

cl_streamflow_mm <- read_csv("data-raw/3_Catchment_streamflow_mm.csv") %>%
  mutate(Date=as.Date(paste(year,month,day,sep="-"))) %>%
  select(Date,everything(),-c(X1,year,month,day)) %>%
  mutate_at(vars(-Date),as.double) %>%
  mutate_at(vars(-Date),round,10)

# subset to remove leading and trailing all(NA) rows
ixna <- apply(cl_streamflow_mm[,-1],1,function(x) all(is.na(x)))
ixmin <- min(which(ixna == FALSE))
ixmax <- max(which(ixna == FALSE))
cl_streamflow_mm <- cl_streamflow_mm[ixmin:ixmax,]
# save to disk
use_data(cl_streamflow_mm, overwrite=TRUE)

################################################################################
# Compile Metadata                                                             #
################################################################################

# read station metadata to get elevation, start, end
md_stations <- read_csv("data-raw/cr2_qflxDaily_2017_stations.txt") %>%
  select(stationcode=codigo_estacion, elevation=altura,
         start=inicio_observaciones,end=fin_observaciones)

# some stations have elevation set to 0, which should be NA
# elevation for these stations has been extracted from DEM
missing_elevation <- read_csv("data-raw/missing-elev-from-DEM.csv") %>%
  transmute(stationcode=stationcod,elevation_DEM=elevation)

# stitching everything together
cl_catchment_md <- read_csv("data-raw/1_Catchment_attributes.csv") %>%
  rename(stationcode=gage_id, station_name=gage_name,latitude=gage_lat,
         longitude=gage_lon) %>%
  # add elevation, start, end from station metadata file
  left_join(md_stations) %>%
  # add missing elevation
  left_join(missing_elevation) %>%
  mutate(elevation=coalesce(na_if(elevation,0),elevation_DEM)) %>%
  select(-elevation_DEM) %>%
  # reorder
  select(-starts_with("lc"),-starts_with("wu"),everything())

# save metadata
use_data(cl_catchment_md, overwrite=TRUE)

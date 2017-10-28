library(dplyr)
library(magrittr)
library(readr)
library(zoo)
library(hydroTSM)
library(lubridate)

################################################################################
# Files to drop into rawdir:                                                   #
#   - 3_Catchment_streamflow_mm.csv                                            #
#   - 1_Catchment_attributes.csv                                               #
#   - cr2_qflxDaily_2017_stations.txt                                          #
#                                                                              #
# Source:                                                                      #
# http://www.cr2.cl/recursos-y-publicaciones/bases-de-datos/datos-de-caudales/ #
# http://www.cr2.cl/download/camels-cl/                                        #
#                                                                              #
################################################################################

basedir <- "/home/joschka/Dropbox/ITT/chile/baseflow-chile"

# import helper functions
source(file.path(basedir,"utils.R"))
rawdir <- file.path(basedir,"raw")

################################################################################
# STEP 1: Reformat discharge data into multivariate series readable by zoo and #
#         exclude stations for which no catchment attributes are available.    #
################################################################################

dc_all <- read_csv(file.path(rawdir,"3_Catchment_streamflow_mm.csv")) %>%
  mutate(Date=as.Date(paste(year,month,day,sep="-"))) %>%
  select(Date,everything(),-c(X1,year,month,day)) %>%
  mutate_at(vars(-Date),as.double)%>%
  mutate_at(vars(-Date),round,10)


# subset to remove leading and trailing all(NA) rows
ixna <- apply(dc_all[,-1],1,function(x) all(is.na(x)))
ixmin <- min(which(ixna == FALSE))
ixmax <- max(which(ixna == FALSE))
dc_all <- dc_all[ixmin:ixmax,]
# save to disk
write_delim(dc_all,file.path(basedir,"discharge_mm.csv"),na="")

################################################################################
# STEP 2: Create gap statistics for different date ranges and collect all      #
#         metadata in single table                                             #
################################################################################

# threshold in percent of data vs NA. when aggregating to monthly, a given month
# is considered NA if the percentage of days with data is below this variable
completeness_threshold = 80
# set up date ranges for gap analysis: character vector in the format year-year
date_ranges <- c("1985-1994","1995-2004","2005-2015","2005-2016","1985-2016","1985-2015")
# file name for writing the final metadata table to disk
md_filename <- "Metadata V1.csv"

# read discharge data
dc_all <- read_delim(file.path(basedir,"discharge_mm.csv")," ",
                     col_types = cols(Date="D",.default = "d"))

# compile gap statistics
md_gaps <- gap_statistics(dc_all,date_ranges,completeness_threshold)

# read station metadata to get elevation, start, end
md_stations <- read_csv(file.path(rawdir,"cr2_qflxDaily_2017_stations.txt")) %>%
  select(stationcode=codigo_estacion, elevation=altura,
         start=inicio_observaciones,end=fin_observaciones)

# some stations have elevation set to 0, which should be NA
# elevation for these stations has been extracted from DEM
missing_elevation <- read_csv(file.path(rawdir,"missing-elev-from-DEM.csv")) %>%
  transmute(stationcode=stationcod,elevation_DEM=elevation)

# compile metadata
md <- read_csv(file.path(rawdir,"1_Catchment_attributes.csv")) %>%
  rename(stationcode=gage_id, station_name=gage_name,latitude=gage_lat,
         longitude=gage_lon) %>%
  # add elevation, start, end from station metadata file
  left_join(md_stations) %>%
  # add missing elevation
  left_join(missing_elevation) %>%
  mutate(elevation=coalesce(na_if(elevation,0),elevation_DEM)) %>%
  select(-elevation_DEM) %>%
  # add gap statistics
  left_join(md_gaps) %>%
  # reorder
  select(-starts_with("lc"),-starts_with("wu"),everything()) %<>%
  # save to disk
  write_delim(file.path(basedir,md_filename))

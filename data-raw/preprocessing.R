library(dplyr)
library(tidyr)
library(readr)
library(devtools)
library(stringr)

################################################################################
# The following files are not included in git and have to be dropped into      #
# data-raw manually:                                                           #
#   - 3_CAMELScl_streamflow_mm.csv, 2018-01-29                                 #
#   - 1_Catchment_attributes.csv, 2018-01-29                                   #
#   - cr2_qflxDaily_2018_stations.txt, 2018-01-10                              #
#                                                                              #
# Source:                                                                      #
# http://www.cr2.cl/recursos-y-publicaciones/bases-de-datos/datos-de-caudales/ #
# http://www.cr2.cl/download/camels-cl/                                        #
#                                                                              #
################################################################################


################################################################################
# Reformat discharge data into multivariate series readable by zoo             #
################################################################################
streamflow_mm_src <- "data-raw/3_CAMELScl_streamflow_mm.csv"

# read column names
header <- scan(streamflow_mm_src, what="",nlines = 1, sep=",") %>%
  str_replace(" ", "0") %>%
  paste0("q",.) %>%
  magrittr::inset(1, "Date")

# read data
cl_streamflow_mm <- read_csv(
  streamflow_mm_src,
  col_names = header,
  col_types = cols(Date = col_date(format = "%Y-%m-%d"), .default = "d"),
  skip = 8)

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

# read discharge station metadata to get elevation, start, end
md_stations <- read_csv("data-raw/cr2_qflxDaily_2018_stations.txt",
                        cols_only(codigo_estacion = "c",
                                  inicio_observaciones = col_date(),
                                  fin_observaciones = col_date()),
                                  col_names = TRUE) %>%
  rename(stationcode=codigo_estacion, q_start=inicio_observaciones,
         q_end=fin_observaciones)

# reformat CAMELS CL metadata
cl_catchment_md <- read_csv("data-raw/1_Catchment_attributes.csv",
                            cols(.default="c"), col_names=TRUE) %>%
  # save table to keep order of variables
  {. ->> table_original} %>%
  # transpose
  gather(stationcode, val, 2:ncol(.)) %>%
  spread(names(.)[1], 'val') %>%
  # add  q_start, q_end from station metadata file
  left_join(md_stations) %>%
  # reorder
  select(stationcode, pull(table_original,1),q_end, q_start) %>%
  # rename
  rename(station_name=gauge_name,latitude=gauge_lat,
          longitude=gauge_lon, elev_station=elev_gauge) %>%
  # prefix stationcode
  mutate(stationcode = if_else(as.integer(stationcode) < 10000000,
                       paste0("q0",stationcode),
                       paste0("q",stationcode)))
# save metadata
use_data(cl_catchment_md, overwrite=TRUE)

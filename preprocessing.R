library(dplyr)
library(magrittr)
library(readr)
library(zoo)

################################################################################
# Files to drop into rawdir:                                                   #
#   - cr2_qflxDaily_2017_stations.txt                                          #
#   - 1_Catchment_attributes.csv                                               #
#                                                                              #
# Source:                                                                      #
# http://www.cr2.cl/recursos-y-publicaciones/bases-de-datos/datos-de-caudales/ #
# http://www.cr2.cl/download/camels-cl/                                        #
#                                                                              #
################################################################################


basedir <- "/home/joschka/Dropbox/ITT/chile/baseflow-chile"
rawdir <- file.path(basedir,"raw")

################################################################################
# STEP 1: Reformat discharge data into multivariate series readable by zoo and #
#         exclude stations for which no catchment attributes are available.    #
################################################################################

# extract stationcodes present in metadata table
sc_md <- read_csv(file.path(rawdir, "1_Catchment_attributes.csv")) %>%
  pull(gage_id) %>%
  as.character()

dc_all <- read_csv(file.path(rawdir, "cr2_qflxDaily_2017.txt")) %>%
  # get rid of the metadata header
  extract(-c(1:14),) %>%
  # fix leading zero in station names
  rename_at(vars(starts_with("0")),funs(substring(., 2))) %>%
  rename(Date=codigo_estacion) %>%
  # filter down to stations available in metadata table
  select(Date,one_of(sc_md)) %>%
  # reformat data columns
  mutate_at(vars(-Date),as.double) %>%
  mutate_at(vars(-Date),funs(na_if(.,-9999)))

# subset to remove leading and trailing all(NA) rows
ixna <- apply(dc_all[,-1],1,function(x) all(is.na(x)))
ixmin <- min(which(ixna == FALSE))
ixmax <- max(which(ixna == FALSE))
dc_all <- dc_all[ixmin:ixmax,]
# save to disk
write_delim(dc_all,file.path(basedir,"discharge_all.csv"))

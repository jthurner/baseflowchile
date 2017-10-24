library(dplyr)
library(magrittr)
library(readr)
library(zoo)
library(hydroTSM)

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

library(readr)
library(dplyr)
library(zoo)
library(openxlsx)

basedir <- "/home/joschka/Dropbox/ITT/chile/baseflow-chile"
# date ranges used in gap analysis: character vector in the format year-year
date_ranges <- c("1985-1994","1995-2004","2005-2015","2005-2016","1985-2016","1985-2015")
# name of preprocessed metadata file
mdfile <- "Metadata V1.csv"

# longest (monthly) gap allowed
lg_max <- 6
# minimum completeness percentage (daily)
c_d_min <- 80
# minimum completeness percentage (monthly)
c_m_min <- 80

# import helper functions
source(file.path(basedir,"utils.R"))

# read metadata table
md <- read_delim(file.path(basedir,mdfile)," ")

# !! apply additional filters here, e.g. to only include stations above 700m:
# md %<>% filter(elevation >= 700)

# list of metadata tables with the selected stations per date range
md_ranges_filtered <- sapply(date_ranges, gap_filter, x = md, lg_max = lg_max,
                          c_d_min = c_d_min, c_m_min = c_m_min, simplify = FALSE)
# list of vectors with the selected stationcodes per date range
# sc_ranges_filtered <- sapply(ranges_filtered,pull,stationcode)

# export selected metadata per date range into excel workbooks
md_excel <- md_ranges_filtered
md_excel$all<- md
write.xlsx(md_excel,
           file.path(basedir, paste(strsplit(mdfile, '[.]')[[1]][1],"date_ranges.xlsx")),
           asTable=TRUE, firstRow=TRUE, colWidths="auto")

# read discharge data
dc_all <- read_delim(file.path(basedir,"discharge_mm.csv")," ",
                     col_types = cols(Date="D",.default = "d"))

# create list of discharge timeseries with the selected stations for each date range
dc_filtered <- mapply(extract_by_sc,
                      md_ranges_filtered, names(md_ranges_filtered),
                      MoreArgs=list(x=dc_all))

# dc_filtered <- mapply(extract_by_sc,
#                       sc_ranges_filtered, names(sc_ranges_filtered),
#                       MoreArgs=list(x=dc_all))

# write out each time series into seperate files, seperate directory per date range
# can be easily read into zoo with: read.zoo(filepath,header=TRUE,drop=FALSE)
mapply(write_seperate,
       md_ranges_filtered, names(md_ranges_filtered),
       MoreArgs=list(x=dc_all,outdir=file.path(basedir,"V1")))

## convert to zoo if needed
#dc_filtered_zoo <- lapply(dc_filtered,function(x) read.zoo(as.data.frame(x)))



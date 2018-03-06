
<!-- README.md is generated from README.Rmd. Please edit that file -->

# baseflowchile

Pre-processed streamflow data (1913-2016) from Chile for
baseflow-analysis. Contains helper functions to calculate gap statistics
for selected date ranges.

Install from github with
`devtools::install_github("jthurner/baseflowchile")`.

Created at [ITT Cologne](http://www.tt.th-koeln.de/).

## Data Source

*Alvarez-Garreton, C., Mendoza, P., Boisier, J. P., Galleguillos, M.,
Zambrano-Bigiarini, M., Lara, A., Addor, N., Puelma, C., Cortes, G.,
Garreaud, R., and McPhee, J.:* [The CAMELS-CL dataset: catchment
attributes and meteorology for large sample studies – Chile dataset, to
be submitted to Hydrol. Earth Syst.
Sci.](https://doi.org/10.5194/hess-2018-23)

The original dataset can be downloaded from
[here](http://www.cr2.cl/recursos-y-publicaciones/bases-de-datos/datos-informacion-integrada-por-cuencas/).

## Usage

The package contains cleaned-up streamflow data in mm and associated
catchment characteristics from the CAMELS-CL dataset (the script used
for preprocessing can be found in the source package).

``` r
library(baseflowchile)
# streamflow time series as tibble
cl_streamflow_mm
# converting to zoo if needed
zoo::read.zoo(as.data.frame(cl_streamflow_mm))
# catchment characteristics - see link above for description of columns
cl_catchment_md
```

The function gap\_statistics() adds daily and monthly completeness
percentages (c\_d, c\_m) and the longest monthly gap (l\_g) to the
metadata table. Gap analysis is performed seperately for the specified
date ranges.

``` r
date_ranges <- c("1985-1994","1995-2004","2005-2015","1985-2015")
cl_md_gaps <- gap_statistics(cl_streamflow_mm, date_ranges,completeness_threshold=80)
cl_md_gaps
## filter down further as needed, e.g. to include only stations above 700m:
# library(dplyr)
# cl_md_gaps <- filter(cl_md_gaps, elevation >= 700)
```

With the gap statistics added to the metadata, extract\_ts() filters out
stations with certain gap characteristics for each date range and
returns the resulting streamflow time series as well as separate
metadata tables containing only the stations used. Optionally, the
metadata tables can be written out as an excel file and the time series
as seperate csv files per station (sorted into directories for each date
range).

``` r
# for each date range, consider only stations which have at least 80% of data (daily + monthly) and no 
# consecutive gap longer than 6 months
cl_v1 <- extract_ts(cl_streamflow_mm, cl_md_gaps, date_ranges, c_d_min = 80, c_m_min = 80, lg_max = 6, 
                    excelfile="Metadata V1.xlsx", outdir ="V1")
# list of time series for each date range
cl_v1$streamflow
# list of corresponding metadata tables
cl_v1$metadata
```

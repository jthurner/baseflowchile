#' Calculate completeness as percentage of non-NA values
#'
#' @param x vector of values
#' @param logical if TRUE, x must be a logical vector with FALSE representing NA
#'
#' @return completeness in percent rounded to one decimal place
#' @export

percent_complete <- function(x,logical=FALSE) {
  # mapping to logical: FALSE means NA, TRUE means DATA
  if (!logical) {
    x <- !is.na(x)
  }
  round(sum(x) / length(x) * 100 ,1)
}

#' Assert completeness by threshold in percent of of non-NA values
#'
#' @param x vector of values
#' @param na.rm completeness percentage below which the input should be considered NA
#'
#' @return TRUE if less than na.rm percent of values are NA, FALSE otherwise
#' @export
#'

is_complete <- function(x,na.rm) {
  if (na.rm < 100) {
    return(percent_complete(x) >= na.rm)
  } else {
    return(!anyNA(x))
  }
}

#' Calculate Longest Contiguous Stretch of NAs
#'
#' @param x vector of values
#' @param logical if TRUE, x must be a logical vector with FALSE representing NA
#'
#' @return length of longest contiguous Stretch of NAs
#' @export
#'
#' @importFrom magrittr "%>%"

longest_gap <- function(x,logical=FALSE) {
  # mapping to logical: FALSE means NA, TRUE means DATA
  if (!logical) {
    x <- !is.na(x)
  }
  if (all(x)) {
    return(0)
  } else {
    # invert NA/DATA so na.contiguos returns longest gap
    return(x %>% na_if(TRUE) %>% na.contiguous() %>% length)
  }
}

#' Calculate Gap Statistics for different time ranges
#'
#' Given a univariate daily time series, the following statistics are computed for the specified date ranges:
#' * Completeness Percentage, daily (c_d): Percentage of non-NA values in the time series
#' * Completeness Percentage, monthly (c_m): Percentage of non-NA values after aggregating to monthly
#' * Longest Gap,monthly (l_g): Longest consecutive stretch of NA values after aggregating to monthly
#'
#' The time ranges are specified in years as "start-end", with "2000-2009" meaning from 2000-01-01 to 2009-12-31.
#'
#' @param x daily timeseries as tibble with Date and data columns named with the stationcode
#' @param date_ranges character vector of date ranges
#' @param completeness_threshold completeness percentage below which a month is marked as NA when calculating monthly statistics (c_m, l_g)
#' @param md metadata table (tibble) with stationcode column
#'
#' @return the metadata table `md` with the following vars added: stationcode + c_d, c_m, l_g for each date range
#' @export
#' @importFrom magrittr "%>%"
#' @importFrom lubridate make_date
#' @import zoo dplyr hydroTSM
gap_statistics <- function(x, date_ranges, completeness_threshold=100,md=cl_catchment_md) {
  gaps_statistics_single <- function(x,date_range,completeness_threshold) {
    range <- strsplit(date_range,"-")[[1]]
    start <- lubridate::make_date(range[1])
    end <- lubridate::make_date(range[2],12,31)
    x %<>% dplyr::filter(Date >= start, Date <= end) %>%
      as.data.frame() %>%
      zoo::read.zoo()
    x_m <- hydroTSM::daily2monthly(x,FUN=is_complete,na.rm=completeness_threshold)
    compl_d <- apply(x, 2 ,percent_complete)
    compl_m <- apply(x_m, 2, percent_complete, logical=TRUE)
    lg_m <- apply(x_m, 2 ,longest_gap, logical = TRUE)
    list_names <- paste(c("c_d","c_m","l_g"),date_range)
    return(setNames(list(compl_d,compl_m,lg_m),list_names))
  }
  all_ranges <- lapply(date_ranges,gaps_statistics_single,x=x,
                         completeness_threshold=completeness_threshold)
  dplyr::as_tibble(unlist(all_ranges,recursive = FALSE))%>%
    dplyr::mutate(stationcode=as.integer(colnames(x)[-1])) %>%
    dplyr::left_join(md,.) %>%
    dplyr::select(-starts_with("lc"),-starts_with("wu"),everything())
}

#' Filter on gap statistics for a given date range
#'
#' Extract rows matching the given gap statistics criteria created with [gap_statistics()].
#'
#' @param x tibble containing columns with gaps statistics (c_d, c_m and l_g)
#' @param date_range date range for the gap statistics, character formatted as "start-end" in years
#' @param c_d_min minimum daily completeness
#' @param c_m_min minimum monthly completeness
#' @param lg_max maximum gap length
#'
#' @return x filtered according to c_d_min, c_m_min and lg_max for the given date range
#' @export
#' @importFrom magrittr "%>%"
#' @import dplyr
gap_filter <- function(x,date_range, c_d_min = 80, c_m_min = 80, lg_max = 6) {
  lg <- as.name(paste("l_g",date_range))
  c_d <- as.name(paste("c_d",date_range))
  c_m <- as.name(paste("c_m",date_range))
  x %>% dplyr::filter((!!lg) <= lg_max,
               (!!c_d) >= c_d_min,
               (!!c_m) >= c_m_min)
}


#' Filter times series by stationcode and/or date range
#'
#' @param x daily timeseries (tibble) with Date and data columns named with the stationcode
#' @param md metadata table (tibble) with a stationcode column containing the stations to be extracted
#' @param date_range date range (character) formatted as "start-end" in years, optional
#'
#' @return x subset according to md and date_range (tibble)
#' @export
#'
#' @importFrom lubridate make_date
#' @import dplyr

filter_ts_from_md <- function(x, md=NULL, date_range=NULL) {
  if (!is.null(date_range)) {
    range <- strsplit(date_range, "-")[[1]]
    start <- lubridate::make_date(range[1])
    end <- lubridate::make_date(range[2], 12, 31)
    x <- dplyr::filter(x, Date >= start, Date <= end)
  }
  if (!is.null(md)) {
    sc <- as.character(pull(md, stationcode))
    x <- dplyr::select(x, Date, one_of(sc))
  }
  return(x)
}


#' Write out multivariate time series into separate files per variable
#'
#' If a metadata table is given, only the stationcodes present in the stationcode column will be written out.
#' If a date range is given, the time series is first subset accordingly (e.g. "2000-2004" translates to 2000-01-01-2004-12-31),
#' and files will be written into a sub-directory of `outdir` named by `date_range`.
#'
#' @param x daily timeseries (tibble) with Date and data columns named with the stationcode
#' @param outdir directory path to write
#' @param md metadata table (tibble) with a stationcode column containing the stations to be used, optional
#' @param date_range date range (character) formatted as "start-end" in years, optional
#'
#' @return invisible, writes variables of `x` into seperate files named <stationcode>.csv (delimited by space) into `outdir`.
#' @export
#' @import dplyr readr

write_univariate <- function(x, outdir, md=NULL, date_range=NULL) {
  write_single <- function(x, sc, outdir) {
    outfile <- file.path(outdir, paste0(sc,".csv"))
    sc <- as.name(sc)
    x <- dplyr::select(x, Date, !!sc)
    readr::write_delim(x, outfile)
  }
  if (!is.null(date_range)) {
    outdir <- file.path(outdir, date_range)
  }
  if (!dir.exists(outdir)) {
    dir.create(outdir, recursive=TRUE)
  }
  x <- filter_ts_from_md(x, md, date_range)
  if (!is.null(md)) {
    sc <- as.character(dplyr::pull(md, stationcode))
  } else {
    sc <- colnames(x)[-1]
  }
  sapply(sc, write_single, x=x, outdir=outdir)
  invisible()
}


#' Extract gap filtered time series
#'
#' The metadata table must have gap statistics columns matching the date range(s), as created by `gap_statistics`.
#'
#'
#' @param x x daily timeseries (tibble) with Date and data columns named with the stationcode
#' @param md metadata table (tibble) with a stationcode column containing the stations to be used
#' @param date_ranges date range(s) (character or character vector) formatted as "start-end" in years
#' @param c_d_min minimum daily completeness
#' @param c_m_min minimum monthly completeness
#' @param lg_max maximum gap length
#' @param excelfile file path to write excel table with metadata per date range as workbooks, optional
#' @param outdir directory path for saving timeseries into univariate files (see `write_univariate`), optional
#'
#' @return a list of two objects:
#' * streamflow: a list of daily time series, named by date ranges
#' * metadata: a list of metadata tables, named by date ranges
#' @export
#'
#' @import openxlsx
extract_ts <- function(x=cl_streamflow_mm, md, date_ranges, c_d_min = 80,
                       c_m_min = 80, lg_max = 6, excelfile=NULL, outdir=NULL){

  # list of metadata tables with the selected stations per date range
  md_ranges_filtered <- sapply(date_ranges, gap_filter, x = md, lg_max = lg_max,
                               c_d_min = c_d_min, c_m_min = c_m_min, simplify = FALSE)
  # create list of discharge timeseries with the selected stations for each date range
  dc_filtered <- mapply(filter_ts_from_md,
                        md_ranges_filtered, names(md_ranges_filtered),
                        MoreArgs=list(x=x),SIMPLIFY=FALSE)
  # export selected metadata per date range into excel workbooks
  if (!is.null(excelfile)) {
    md_excel <- md_ranges_filtered
    md_excel$all<- md
    openxlsx::write.xlsx(md_excel, excelfile, asTable=TRUE,
               firstRow=TRUE, colWidths="auto")
  }
  # write out each time series into seperate files, seperate directory per date range
  # can be easily read into zoo with: read.zoo(filepath,header=TRUE,drop=FALSE)
  if (!is.null(outdir)) {
    mapply(write_univariate,
           md_ranges_filtered, names(md_ranges_filtered),
           MoreArgs=list(x=x,outdir=file.path(outdir)))
  }
  return(list(streamflow=dc_filtered,metadata=md_ranges_filtered))
}

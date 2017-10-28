library(lubridate)
library(dplyr)


#' Calculate completeness as percentage of non-NA values
#'
#' @param x vector of values
#' @param logical if TRUE, x must be a logical vector with FALSE representing NA
#'
#' @return
#' @export
#'
#' @examples
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
#' @examples
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
#' @examples
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
#'
#' @return tibble with the following vars: stationcode + c_d, c_m, l_g for each date range
gap_statistics <- function(x,date_ranges, completeness_threshold=100) {
  gaps_statistics_single <- function(x,date_range,completeness_threshold) {
    range <- strsplit(date_range,"-")[[1]]
    start <- make_date(range[1])
    end <- make_date(range[2],12,31)
    x %<>% filter(Date >= start, Date <= end) %>%
      as.data.frame() %>%
      read.zoo()
    # x_a_mean <- daily2annual(x, mean) %>% apply(2,mean)
    x_m <- daily2monthly(x,FUN=is_complete,na.rm=completeness_threshold)
    compl_d <- apply(x, 2 ,percent_complete)
    compl_m <- apply(x_m, 2, percent_complete, logical=TRUE)
    lg_m <- apply(x_m, 2 ,longest_gap, logical = TRUE)
    list_names <- paste(c("c_d","c_m","l_g"),date_range)
    return(setNames(list(compl_d,compl_m,lg_m),list_names))
  }
  all_ranges <- lapply(date_ranges,gaps_statistics_single,x=x,
                         completeness_threshold=completeness_threshold)
  as_tibble(unlist(all_ranges,recursive = FALSE))%>%
    mutate(stationcode=as.integer(colnames(x)[-1]))
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
#'
#' @examples
gap_filter <- function(x,date_range, c_d_min = 80, c_m_min = 80, lg_max = 6) {
  lg <- as.name(paste("l_g",date_range))
  c_d <- as.name(paste("c_d",date_range))
  c_m <- as.name(paste("c_m",date_range))
  x %>% filter((!!lg) <= lg_max,
               (!!c_d) >= c_d_min,
               (!!c_m) >= c_m_min)
}


#' Title
#'
#' @param x
#' @param sc
#' @param date_range
#'
#' @return
#' @export
#'
#' @examples
extract_by_sc <- function(x,md,date_range) {
  sc <- as.character(pull(md,stationcode))
  range <- strsplit(date_range,"-")[[1]]
  start <- make_date(range[1])
  end <- make_date(range[2],12,31)
  x %>% select(Date,one_of(sc)) %>%
    filter(Date >= start, Date <= end)
}



#' Title
#'
#' @param x
#' @param outdir
#' @param sc
#' @param date_range
#'
#' @return
#' @export
#'
#' @examples
write_seperate <- function(x,md,date_range,outdir) {
  write_single <- function(x,sc,outdir) {
    outfile <- file.path(outdir,paste0(sc,".csv"))
    sc <- as.name(sc)
    x %>% select(Date,!!sc) %>%
      write_delim(outfile)
  }
  outdir <- file.path(outdir,date_range)
  # sc <- as.character(pull(md,stationcode))
  x <- extract_by_sc(x,md,date_range)
  if (!dir.exists(outdir)) {
    dir.create(outdir,recursive = TRUE)
  }
  sc <- as.character(pull(md,stationcode))
  sapply(sc,write_single,x=x,outdir=outdir)
}
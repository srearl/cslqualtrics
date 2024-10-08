% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/helper_activity_types.R
\name{generate_activity_types}
\alias{generate_activity_types}
\title{R code to construct activity_types package data object}
\usage{
generate_activity_types()
}
\description{
R code to construct the \code{activity_types} data object in
the cslqualtrics package; included for reference (not exported).

importFrom tibble tribble
}
\examples{
\dontrun{
activity_types <- generate_activity_types()
usethis::use_data(activity_types, overwrite = TRUE)
}

}

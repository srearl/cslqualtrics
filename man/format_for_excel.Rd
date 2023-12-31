% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/format_for_excel.R
\name{format_for_excel}
\alias{format_for_excel}
\title{Format raw observation data downloaded from Qualtrics to match the
structure expected by the interactive Observation Query spreadsheet}
\usage{
format_for_excel(qualtrics_file, class, semester)
}
\arguments{
\item{qualtrics_file}{(character) the quoted name of the csv file to format}

\item{class}{(character) the quoted name of the class associated with the data in the
downloaded file in one of the prescribed formats expected by the Observation
Query spreadsheet.}

\item{semester}{(character) the quoted name of the semester and year associated with data in
the downloaded file in one of the prescribed formats expected by the
Observation Query spreadsheet: (S)pring or (F)all, YY (e.g., "S23")}
}
\value{
A formatted csv file with the name \code{class_semester.csv}
}
\description{
\code{format_for_excel} accepts as input a csv file downloaded
from Qualtrics from the set of observation behaviour data. The function
formats the data in the input file into a format expected by the interactive
Observation Query Excel spreadsheet that provides functionality to explore
the data in graphical and tabular format.
}
\note{
\code{format_for_excel} was purposefully built with only base R
function so as to minimize installation overhead.
}
\examples{
\dontrun{

format_for_excel(
  qualtrics_file = "Fall 2022 CSL Observation Sheets MWF Multi-Age_October 4, 2023_07.45.csv",
  class          = "MWFMulti",
  semester       = "S23"
)

}

}

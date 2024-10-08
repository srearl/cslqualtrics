#' @title Tools to facilitate uploading to a database formatted observation
#' data
#'
#' @description Tools and a workflow for fetching from Qualtrics, formatting,
#' then uploading to an sqlite database observation data.
#'
#' import dplyr
#' importFrom qualtRics fetch_survey
#' importFrom janitor clean_names
#' importFrom tidyselect everything starts_with
#' importFrom DBI dbWriteTable
#' importFrom tidyr pivot_longer matches
#'
#' @param survey_id
#' (character) id of Qualtrics survey for which to query observations
#' @param upload
#' (logical) logical indicating whether to upload formatted observation data to
#' the database (TRUE, default) or return them in the form of a tibble
#' @param connection
#' (character) database connection
#'
#' @export
#'
fetch_survey_data <- function(
  survey_id,
  upload = TRUE,
  connection
) {

  # query qualtrics API

  suppressMessages(

    single_survey_df <- qualtRics::fetch_survey(
      surveyID = survey_id,
      verbose  = TRUE
    ) |>
      janitor::clean_names()

  )

  message("survey: ", survey_id, " rows: ", nrow(single_survey_df))


  # format observation data

  single_survey_df <- single_survey_df |> 
    dplyr::mutate(
      survey_id           = as.character(survey_id),
      start_date          = as.character(start_date),
      end_date            = as.character(end_date),
      progress            = as.integer(progress),
      duration_in_seconds = as.integer(duration_in_seconds),
      finished            = as.logical(finished),
      recorded_date       = as.character(recorded_date),
      dplyr::across(tidyselect::starts_with("q"), as.character)
    ) |> 
    dplyr::select(survey_id, tidyselect::everything())


  # remove line breaks from Q32

  if ("q32" %in% names(single_survey_df)) {

    single_survey_df$q32 <- gsub("[\r\n]", ".", single_survey_df$q32) 

  }


  # coordinates to numeric

  if ("location_latitude" %in% names(single_survey_df)) {

    single_survey_df$location_latitude <- as.numeric(single_survey_df$location_latitude)

  }

  if ("location_longitude" %in% names(single_survey_df)) {

    single_survey_df$location_longitude <- as.numeric(single_survey_df$location_longitude)

  }

  # wide to long

  single_survey_df <- single_survey_df |> 
    tidyr::pivot_longer(
      cols      = tidyr::matches("^Q[0-9]+"),
      names_to  = "question",
      values_to = "response"
    ) |> 
    dplyr::filter(!is.na(response))


  # write

  if (!all(colnames(single_survey_df) %in% c(observation_expected_cols))) {

    warning("unexpected data structure for survey ", survey_id, " (data not loaded)") 

  } else {

    if (upload == FALSE) {

      return(single_survey_df)

    } else {

      DBI::dbWriteTable(
        conn      = connection,
        name      = "observations",
        value     = single_survey_df,
        overwrite = FALSE,
        append    = TRUE,
        row.names = FALSE
      )

    }

  }

}

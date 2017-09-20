#' ISCO88 relabeling in different languages
#'
#' @description This function takes ISCO88 codes (2 to 4 digits) as its argument and changes the
#' labels in the specified column (second argument) to the desired language.
#'
#' @param isco_col Column in which the ISCO88 codes(2 to 4 digits) are stored. Please indicate
#' via subsetting.
#' @param label_col Column where the ISCO88 labels are stored. Please indicate via subsetting.
#' @param dest_language Destination language. Indicate on of "german", "english", "french"
#' as a string. Defaults to "english".
#'
#' @details
#' \strong{Treatment of missing or unknown ISCO88 codes:} If the ISCO88 code in a row cannot be
#' matched to a ISCO88 code in risco::labels data the label_col of the line in question is marked
#' with "NO MATCH_".
#'
#' Technically the string "NO MATCH_" is pasted together with the label of the line with a missing ISCO88 code.
#' @return
#' @export
#'
#' @examples
#' # Setup result container
#' res1 <- risco::risco_test_1
#' res2 <- risco::risco_test_2
#'
# add German labels to the data
#'res1$german <- isco_relabel(isco_col = res1$isco_code,
#'                            label_col = res1$english, dest_language = "german")
#'
#'# add German labels to the data with missings
#'res2$german <- isco_relabel(isco_col = res2$isco_code,
#'                            label_col = res2$english, dest_language = "german")
#'
#'
isco_relabel <- function(isco_col, label_col, dest_language = "english"){
  #checks
  labels <- risco::labels
  languages <- c("german", "english", "french")

  stopifnot(typeof(isco_col) %in% c("integer", "double"),
            typeof(label_col) == "character",
            length(dest_language) == 1,
            dest_language %in% languages)

  #main body
  #extract the matching labels
  replacements <- labels[match(isco_col, labels$isco_code), dest_language]

  # converting to a data frame, otherwhise there are problems later
  replacements <- as.data.frame(replacements, stringsAsFactors = FALSE)


  # if there are nonmatches mark them
  if (any(is.na(replacements))) {
    warning("Some isco codes could not be matched! They are labeled with 'NO MATCH' ")
  }

  if (any(is.na(replacements))){
    #construct data frame with original row number where the NA's came from and the
    # original label
    nonmatches <- data.frame(index = which(is.na(replacements)),
                             label_col[which(is.na(replacements))])

    #mark them with NO MATCH by pasting the strings together
    #browser()
    nonmatches[, 2] <- paste("NO MATCH_", nonmatches[, 2], sep = "")

    #reintroduce to the modified strings into replacements
    replacements[nonmatches$index, 1] <- nonmatches[, 2]
  }
  return(unlist(replacements[,1]))
}



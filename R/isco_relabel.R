#' ISCO relabeling in different languages
#'
#' @description Thisfunction takes isco88 codes (2 to 4 digits) as its argument and changes the
#' labels in the specified column (second argument) to the desired language.
#'
#' @param isco_col Column in where the ISCO codes(2 to 4 digits) are stored. Please indicate
#' via subsetting.
#' @param label_col Column where the isco labels are stored. Please indicate via subsetting.
#' @param dest_language Denstination language. Indicate on of "german", "english", "french"
#' as a string. Defaults to "english".
#'
#' @return
#' @export
#'
#' @examples
isco_relabel <- function(isco_col, label_col, dest_language = "english"){
  #checks
  labels <- risco::labels
  #browser()
  languages <- c("german", "english", "french")

  stopifnot(typeof(isco_col) %in% c("integer", "double"),
            typeof(label_col) == "character",
            length(dest_language) == 1,
            dest_language %in% languages)

  #main body
  #extract the matching labels
  replacements <- labels[match(isco_col, labels$isco_code), dest_language]


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
    nonmatches[, 2] <- lapply(nonmatches[, 2], function(x){
      paste("NO MATCH_", x, sep = "")
    })

    #reintroduce to the modified strings into replacements
    replacements[nonmatches$index, 1] <- nonmatches[, 2]
  }
  return(replacements)
}



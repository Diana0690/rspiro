#' Calculate LLN of spirometry parameters using GLI-2012 equations
#'
#' This function calculates LLNs (Lower Limits of Normal) for the various spirometry
#' parameters, using the GLI-2012 equations. It accepts as input age, height, gender and ethnicity.
#'
#' @param age Age in years
#' @param height Height in meters
#' @param gender Gender (1 = male, 2 = female) or a factor with two levels (first = male). Default is 1.
#' @param ethnicity Ethnicity (1 = Caucasian, 2 = African-American, 3 = NE Asian, 4 = SE Asian,
#' 5 = Other/mixed). Default is 1.
#' @param param A character vector, containing one of more of the following parameters (case insensitive):
#' "FEV1", "FVC", "FEV1FVC", "FEF2575", "FEF75", "FEV075", "FEV075FVC"
#'
#' @details Arguments \code{age}, \code{height}, \code{gender} and \code{ethnicity} are vectors
#' of equal length, or of length one, in which case the value is recycled; if the four vectors are
#' not of equal length, the function stops with an error.
#'
#' @return If \code{param} has length one, the function returns a numeric vector. If \code{param}
#' has length >1, it returns a data.frame with \code{length(param)} columns.
#'
#' @examples
#' # Find LLN of FEV1 and FVC for Caucasian women aged 20 to 70 and with a height of 1.70 meters.
#' LLN_GLI(20:70, 1.7, 2, param=c("FEV1","FVC"))
#'
#' @export
LLN_GLI <- function(age, height, gender=1, ethnicity=1, param="FEV1") {
  dat <- getLMS(age, height, gender, ethnicity, param)
  dat$LLN <- with(dat, exp(log(1 - 1.645 * L * S)/L + log(M)))

  datw <- reshape(dat[,c("id","f", "age","height","ethnicity","gender","LLN")],
    v.names="LLN", idvar="id", direction="wide", timevar="f")
  rownames(datw) <- NULL
  datw <- datw[order(datw$id),]

  datw[,paste("LLN", unique(param), sep=".")]
}

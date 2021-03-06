#' EvalPlot automatically builds calibration plots for model evaluation
#'
#' This function automatically builds calibration plots and calibration boxplots for model evaluation using regression, quantile regression, and binary and multinomial classification
#' @author Adrian Antico
#' @family Model Evaluation and Interpretation
#' @param data Data containing predicted values and actual values for comparison
#' @param MaxRows Defaults to 100000 rows
#' @param PredictionColName String representation of column name with predicted values from model
#' @param TargetColName String representation of column name with target values from model
#' @param GraphType Calibration or boxplot - calibration aggregated data based on summary statistic; boxplot shows variation
#' @param PercentileBucket Number of buckets to partition the space on (0,1) for evaluation
#' @param aggrfun The statistics function used in aggregation, listed as a function
#' @return Calibration plot or boxplot
#' @examples
#' # Create fake data
#' data <- RemixAutoML::FakeDataGenerator(Correlation = 0.70, N = 10000000, Classification = TRUE)
#' data.table::setnames(data, "IDcol_1", "Predict")
#' 
#' # Run function
#' EvalPlot(data,
#'          MaxRows = 100000L,
#'          PredictionColName = "Predict",
#'          TargetColName = "Adrian",
#'          GraphType = "calibration",
#'          PercentileBucket = 0.05,
#'          aggrfun = function(x) mean(x, na.rm = TRUE))
#' @export
EvalPlot <- function(data,
                     MaxRows = 100000L,
                     PredictionColName = c("PredictedValues"),
                     TargetColName  = c("ActualValues"),
                     GraphType        = c("calibration"),
                     PercentileBucket = 0.05,
                     aggrfun     = function(x) mean(x, na.rm = TRUE)) {
  
  # Turn data into data.table if not already----
  if(!data.table::is.data.table(data)) data.table::setDT(data)
  
  # Structure data
  data <- data[, .SD, .SDcols = c(eval(PredictionColName), eval(TargetColName))]
  data.table::setcolorder(data, c(PredictionColName, TargetColName))
  data.table::setnames(data, c(PredictionColName, TargetColName), c("preds", "acts"))
  
  # If actual is in factor form, convert to numeric----
  if(!is.numeric(data[["acts"]])) {
    data.table::set(data, j = "acts", value = as.numeric(as.character(data[["acts"]])))
    GraphType <- "calibration"
  }
  
  # Subset data if too big----
  if(data[,.N] > MaxRows) data <- data[order(runif(data[,.N]))][1L:MaxRows]
  
  # Add a column that ranks predicted values----
  data[, rank := 100 * (round(percRank(preds) / PercentileBucket) * PercentileBucket)]
  
  # Plot----
  if(GraphType == "boxplot") {
    data.table::set(data, j = "rank", value = as.factor(data[["rank"]]))
    cols <- c("rank", "preds")
    zz1 <- data[, ..cols]
    zz1[, Type := 'predicted']
    data.table::setnames(zz1, c("preds"), c("output"))
    cols <- c("rank", "acts")
    zz2 <- data[, ..cols]
    zz2[, Type := 'actual']
    data.table::setnames(zz2, c("acts"), c("output"))
    data <- data.table::rbindlist(list(zz1, zz2))
    plot <- ggplot2::ggplot(data, ggplot2::aes(x = rank, y = output, fill = Type)) +
      ggplot2::geom_boxplot(outlier.color = "red", color = "black") +
      ggplot2::ggtitle("Calibration Evaluation Boxplot") +
      ggplot2::xlab("Predicted Percentile") +
      ggplot2::ylab("Observed Values") +
      ChartTheme(Size = 15) +
      ggplot2::scale_fill_manual(values = c("blue", "red"))
    
  } else {
    data <- data[, lapply(.SD, noquote(aggrfun)), by = list(rank)]
    plot  <- ggplot2::ggplot(data, ggplot2::aes(x = rank))  +
      ggplot2::geom_line(ggplot2::aes(y = data[[3L]], color = "Actual")) +
      ggplot2::geom_line(ggplot2::aes(y = data[[2L]], color = "Predicted")) +
      ggplot2::xlab("Predicted Percentile") +
      ggplot2::ylab("Observed Values") +
      ggplot2::scale_color_manual(values = c("red", "blue")) +
      ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90, hjust = 1)) +
      ggplot2::theme(legend.position = "bottom") +
      ggplot2::ggtitle("Calibration Evaluation Plot") +
      ChartTheme(Size = 15) +
      ggplot2::scale_fill_manual(values = c("blue", "gold"))
  }
  return(plot)
}

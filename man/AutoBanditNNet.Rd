% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/AutomatedTimeSeriesModels.R
\name{AutoBanditNNet}
\alias{AutoBanditNNet}
\title{AutoBanditNNet}
\usage{
AutoBanditNNet(
  data,
  TargetVariableName,
  DateColumnName,
  TimeAggLevel = "week",
  EvaluationMetric = "MAE",
  NumHoldOutPeriods = 5L,
  NumFCPeriods = 5L,
  MaxLags = 5L,
  MaxSeasonalLags = 1L,
  MaxFourierPairs = 2L,
  TrainWeighting = 0.5,
  MaxConsecutiveFails = 12L,
  MaxNumberModels = 100L,
  MaxRunTimeMinutes = 10L
)
}
\arguments{
\item{data}{Source data.table}

\item{TargetVariableName}{Name of your time series target variable}

\item{DateColumnName}{Name of your date column}

\item{TimeAggLevel}{Choose from "year", "quarter", "month", "week", "day", "hour"}

\item{EvaluationMetric}{Choose from MAE, MSE, and MAPE}

\item{NumHoldOutPeriods}{Number of time periods to use in the out of sample testing}

\item{NumFCPeriods}{Number of periods to forecast}

\item{MaxLags}{A single value of the max number of lags to test}

\item{MaxSeasonalLags}{A single value of the max number of seasonal lags to test}

\item{MaxFourierPairs}{A single value of the max number of fourier pairs to test}

\item{TrainWeighting}{Model ranking is based on a weighted average of training metrics and out of sample metrics. Supply the weight of the training metrics, such as 0.50 for 50 percent.}

\item{MaxConsecutiveFails}{When a new best model is found MaxConsecutiveFails resets to zero. Indicated the number of model attemps without a new winner before terminating the procedure.}

\item{MaxNumberModels}{Indicate the maximum number of models to test.}

\item{MaxRunTimeMinutes}{Indicate the maximum number of minutes to wait for a result.}
}
\description{
AutoBanditNNet is a multi-armed bandit model testing framework for AR and SAR NNets. Randomized probability matching is the underlying bandit algorithm. Model evaluation is done by blending the training error and the validation error from testing the model on out of sample data. The bandit algorithm compares the performance of the current build against the previous builds which starts with the classic nnetar model from the forecast package. Depending on how many lags, seasonal lags, and fourier pairs you test the number of combinations of features to test begins to approach 10,000 different combinations of settings. The function tests out transformations, differencing, and variations of the lags, seasonal lags, and fourier pairs. The paramter space is broken up into various buckets that are increasing in sophistication. The bandit algorithm samples from those buckets and based on many rounds of testing it determines which buckets to generate samples from more frequently based on the models performance coming from that bucket. All of the models have performance data collected on them and a final rebuild is initiated when a winner is found. The rebuild process begins by retraining the model with the settings that produced the best performance. If the model fails to build, for whatever reason, the next best buildable model is rebuilt.
}
\seealso{
Other Time Series: 
\code{\link{AutoBanditSarima}()},
\code{\link{AutoTBATS}()},
\code{\link{CarmaHoldoutMetrics}()},
\code{\link{DifferenceDataReverse}()},
\code{\link{DifferenceData}()},
\code{\link{FinalBuildArfima}()},
\code{\link{FinalBuildArima}()},
\code{\link{FinalBuildETS}()},
\code{\link{FinalBuildNNET}()},
\code{\link{FinalBuildTBATS}()},
\code{\link{FinalBuildTSLM}()},
\code{\link{GenerateParameterGrids}()},
\code{\link{OptimizeArfima}()},
\code{\link{OptimizeArima}()},
\code{\link{OptimizeETS}()},
\code{\link{OptimizeNNET}()},
\code{\link{OptimizeTBATS}()},
\code{\link{OptimizeTSLM}()},
\code{\link{ParallelAutoARIMA}()},
\code{\link{ParallelAutoArfima}()},
\code{\link{ParallelAutoETS}()},
\code{\link{ParallelAutoNNET}()},
\code{\link{ParallelAutoTBATS}()},
\code{\link{ParallelAutoTSLM}()},
\code{\link{RL_Performance}()},
\code{\link{Regular_Performance}()},
\code{\link{StackedTimeSeriesEnsembleForecast}()},
\code{\link{TimeSeriesDataPrepare}()},
\code{\link{WideTimeSeriesEnsembleForecast}()}
}
\author{
Adrian Antico
}
\concept{Time Series}

% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/computations.R
\name{.calc_score}
\alias{.calc_score}
\title{helper function to calculate score from raw data}
\usage{
.calc_score(name, table, M, SD, min, max)
}
\arguments{
\item{name}{of the variable for standardization}

\item{table}{frequency table for standardized variable}

\item{M}{mean of output scale}

\item{SD}{sd of output scale}

\item{min}{min of output scale}

\item{max}{max of output scale}
}
\value{
tibble with normalized values for each raw score
}
\description{
helper function to calculate score from raw data
}

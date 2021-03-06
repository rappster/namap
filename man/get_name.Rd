% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get.R
\name{get_name}
\alias{get_name}
\title{Get name from config \lifecycle{experimental}}
\usage{
get_name(x, type = valid__name_types(), mapping = list(), as_character = FALSE)
}
\arguments{
\item{x}{[\link{character}] Name identifier}

\item{type}{[\link{character}] Name type, on of \code{valid__name_types()}}

\item{as_character}{[\link{logical}] Return name as \code{name} (\code{FALSE}) or \code{character}
(\code{TRUE})}
}
\value{
[\link{name} or \link{character}] Desired name that can e.g. be used in
\verb{dplyr::selet(!!<return_value>)} or the like
}
\description{
Get name from config, either as a \code{name} or \code{character}.
Uses file path stored in environment variable \code{R_CONFIG_NAMES} (if set) or
\verb{./config.yml)} instead
}

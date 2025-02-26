% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/summarise.R
\name{summarise}
\alias{summarise}
\alias{summarize}
\title{Summarise each group to fewer rows}
\usage{
summarise(.data, ..., .groups = NULL)

summarize(.data, ..., .groups = NULL)
}
\arguments{
\item{.data}{A data frame, data frame extension (e.g. a tibble), or a
lazy data frame (e.g. from dbplyr or dtplyr). See \emph{Methods}, below, for
more details.}

\item{...}{<\code{\link[=dplyr_data_masking]{data-masking}}> Name-value pairs of summary
functions. The name will be the name of the variable in the result.

The value can be:
\itemize{
\item A vector of length 1, e.g. \code{min(x)}, \code{n()}, or \code{sum(is.na(y))}.
\item A vector of length \code{n}, e.g. \code{quantile()}.
\item A data frame, to add multiple columns from a single expression.
}}

\item{.groups}{\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#experimental}{\figure{lifecycle-experimental.svg}{options: alt='[Experimental]'}}}{\strong{[Experimental]}} Grouping structure of the result.
\itemize{
\item "drop_last": dropping the last level of grouping. This was the
only supported option before version 1.0.0.
\item "drop": All levels of grouping are dropped.
\item "keep": Same grouping structure as \code{.data}.
\item "rowwise": Each row is its own group.
}

When \code{.groups} is not specified, it is chosen
based on the number of rows of the results:
\itemize{
\item If all the results have 1 row, you get "drop_last".
\item If the number of rows varies, you get "keep".
}

In addition, a message informs you of that choice, unless the result is ungrouped,
the option "dplyr.summarise.inform" is set to \code{FALSE},
or when \code{summarise()} is called from a function in a package.}
}
\value{
An object \emph{usually} of the same type as \code{.data}.
\itemize{
\item The rows come from the underlying \code{\link[=group_keys]{group_keys()}}.
\item The columns are a combination of the grouping keys and the summary
expressions that you provide.
\item The grouping structure is controlled by the \verb{.groups=} argument, the
output may be another \link{grouped_df}, a \link{tibble} or a \link{rowwise} data frame.
\item Data frame attributes are \strong{not} preserved, because \code{summarise()}
fundamentally creates a new data frame.
}
}
\description{
\code{summarise()} creates a new data frame. It will have one (or more) rows for
each combination of grouping variables; if there are no grouping variables,
the output will have a single row summarising all observations in the input.
It will contain one column for each grouping variable and one column
for each of the summary statistics that you have specified.

\code{summarise()} and \code{summarize()} are synonyms.
}
\section{Useful functions}{

\itemize{
\item Center: \code{\link[=mean]{mean()}}, \code{\link[=median]{median()}}
\item Spread: \code{\link[=sd]{sd()}}, \code{\link[=IQR]{IQR()}}, \code{\link[=mad]{mad()}}
\item Range: \code{\link[=min]{min()}}, \code{\link[=max]{max()}}, \code{\link[=quantile]{quantile()}}
\item Position: \code{\link[=first]{first()}}, \code{\link[=last]{last()}}, \code{\link[=nth]{nth()}},
\item Count: \code{\link[=n]{n()}}, \code{\link[=n_distinct]{n_distinct()}}
\item Logical: \code{\link[=any]{any()}}, \code{\link[=all]{all()}}
}
}

\section{Backend variations}{


The data frame backend supports creating a variable and using it in the
same summary. This means that previously created summary variables can be
further transformed or combined within the summary, as in \code{\link[=mutate]{mutate()}}.
However, it also means that summary variables with the same names as previous
variables overwrite them, making those variables unavailable to later summary
variables.

This behaviour may not be supported in other backends. To avoid unexpected
results, consider using new names for your summary variables, especially when
creating multiple summaries.
}

\section{Methods}{

This function is a \strong{generic}, which means that packages can provide
implementations (methods) for other classes. See the documentation of
individual methods for extra arguments and differences in behaviour.

The following methods are currently available in loaded packages:
\Sexpr[stage=render,results=rd]{dplyr:::methods_rd("summarise")}.
}

\examples{
# A summary applied to ungrouped tbl returns a single row
mtcars \%>\%
  summarise(mean = mean(disp), n = n())

# Usually, you'll want to group first
mtcars \%>\%
  group_by(cyl) \%>\%
  summarise(mean = mean(disp), n = n())

# dplyr 1.0.0 allows to summarise to more than one value:
mtcars \%>\%
   group_by(cyl) \%>\%
   summarise(qs = quantile(disp, c(0.25, 0.75)), prob = c(0.25, 0.75))

# You use a data frame to create multiple columns so you can wrap
# this up into a function:
my_quantile <- function(x, probs) {
  tibble(x = quantile(x, probs), probs = probs)
}
mtcars \%>\%
  group_by(cyl) \%>\%
  summarise(my_quantile(disp, c(0.25, 0.75)))

# Each summary call removes one grouping level (since that group
# is now just a single row)
mtcars \%>\%
  group_by(cyl, vs) \%>\%
  summarise(cyl_n = n()) \%>\%
  group_vars()

# BEWARE: reusing variables may lead to unexpected results
mtcars \%>\%
  group_by(cyl) \%>\%
  summarise(disp = mean(disp), sd = sd(disp))

# Refer to column names stored as strings with the `.data` pronoun:
var <- "mass"
summarise(starwars, avg = mean(.data[[var]], na.rm = TRUE))
# Learn more in ?dplyr_data_masking
}
\seealso{
Other single table verbs: 
\code{\link{arrange}()},
\code{\link{filter}()},
\code{\link{mutate}()},
\code{\link{rename}()},
\code{\link{select}()},
\code{\link{slice}()}
}
\concept{single table verbs}

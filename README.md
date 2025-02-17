
<!-- README.md is generated from README.Rmd. Please edit that file -->

# stenR

<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/StatisMike/stenR/branch/master/graph/badge.svg)](https://codecov.io/gh/StatisMike/stenR?branch=master)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://www.tidyverse.org/lifecycle/#stable)
<!-- badges: end -->

`stenR` is a package tailored mainly for creators of psychological
questionnaires, though other social science researchers and survey
authors can benefit greatly from it.

It normalizes and standardizes results to standard scale of your
choosing. It works on basis of source data: creates frequency table and
computes Z score corresponding to particular raw score. After that you
can get the score for all observations in the sourced data, chosen
individuals or external data not used for calculating the norms.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("StatisMike/stenR")
```

## Recommended workflow for using stenR functionality

`stenR` currently is based entirely on one `R6 class`: computed
frequency table, or `stenR.comp_freqtable`. This document will shortly
document the available methods and functions.

### Creating `stenR.comp_freqtable`

Firstly you need to initialize new computed frequency table. It is
recommended to do it using `gen_freqtable()` function.

``` r
library(stenR)

# We will use data provided in the package

freqtable <- gen_freqtable(
  data = HEXACO_60,
  vars = c("HEX_H", "HEX_E", "HEX_X", "HEX_A", "HEX_C", "HEX_O"),
  id = "user_id"
)
#> Warning: For [HEX_H]: There are missing score values between minimum and maximum
#> scores. They have been filled automatically, though have in mind that you should
#> get more representative sample.
#> Warning: For [HEX_E]: There are missing score values between minimum and maximum
#> scores. They have been filled automatically, though have in mind that you should
#> get more representative sample.
#> Warning: For [HEX_X]: There are missing score values between minimum and maximum
#> scores. They have been filled automatically, though have in mind that you should
#> get more representative sample.
#> Warning: For [HEX_A]: There are missing score values between minimum and maximum
#> scores. They have been filled automatically, though have in mind that you should
#> get more representative sample.
#> Warning: For [HEX_O]: There are missing score values between minimum and maximum
#> scores. They have been filled automatically, though have in mind that you should
#> get more representative sample.
```

After initialization of the object, you can get some warnings. They
indicate that there are some values of raw score that weren’t
represented in the data. By the rule of thumb: the more possible values
the raw scores can get and the smaller your data, the bigger possibility
for it to happen. If you feel that your sample was representative, you
can ignore it. It is recommended though to get more varied, greater
number of observations when getting this warning - or clean your data
more thoroughly.

### Computing scores in standard scale

After creation of your `stenR.comp_freqtable` object, you then need to
calculate scores in scoring scale of your choice (or multiple of them).
You can do it with `compute_scores(scale)` method:

``` r
# one of most commonly used scales is a STEN scale
freqtable$compute_scores("sten")
# though we can also use tanines
freqtable$compute_scores("tanine")
```

Now `freqtable` object holds scores computed in both *STEN* and *tanine*
scales. We can check the state using `get_status()` method. It returns a
list object, and `standardized scores` character vector holds the names
of computed scores.

``` r
freqtable$get_status()$`standardized scores`
#> [1] "sten"   "tanine"
```

### Getting computed scores for observations

When results are available, you can get them using
`get_computed_scores()` method:

``` r
# we will print only few first rows of results
head(
  freqtable$get_computed_scores("sten")
  )
#>                        id HEX_H HEX_E HEX_X HEX_A HEX_C HEX_O
#> 1 neutral_peregrinefalcon     8     5     7     8     6     3
#> 2   trapeziform_zebradove     7     5     7    10     6     2
#> 3    polyhedral_solenodon     2     2     2    10     5     5
#> 4      decrepit_norwayrat     2     3     6     3     8     9
#> 5          unawake_wisent     5     6     4     6     5     2
#> 6   turophilic_spreadwing     5     5     7     7     3     6
```

You can also get only scores for specific observations and variables:

``` r
freqtable$get_computed_scores(
  "tanine",
  vars = c("HEX_H", "HEX_C"),
  ids = c("decrepit_norwayrat", "trapeziform_zebradove")
)
#>                      id HEX_H HEX_C
#> 1    decrepit_norwayrat    34    61
#> 2 trapeziform_zebradove    56    51
```

If you need to get scores for some other observations, not present in
the source data, you can get it with use of `get_computed_scores_ext()`
method:

``` r
external_data <- data.frame(
  # names of the variables don't need to be the same as in computed freqtable
  Extraversion = c(25, 42),
  # and can also be supplied as characters. Just make sure it can be coerced to numerical
  Openness = c("40", "23")
)

freqtable$get_computed_scores_ext(
  data = external_data,
  scale = "tanine",
    # if the names are different, you need to provide named character vector
  vars = c(HEX_X = "Extraversion", HEX_O = "Openness")
)
#>   Extraversion Openness
#> 1           45       52
#> 2           67       28
```

## Available methods and their functionality

Besides the basic methods shared by all `R6 class` objects,
`stenR.comp_freqtable` supports currently following methods:

-   `get_status()` - returns list with details of current status of the
    object,
-   `get_data_info()` - returns list with information of the basic
    source data structure,
-   `get_freqtables()` - returns frequency tables for each variable
-   `compute_scores()` - compute score in one of the built-in standard
    scales or a custom one. Currently, there are built-in definitions of
    following:
    -   *sten* (M = 5.5, SD = 2, min = 1, max = 10),
    -   *stanine* (M = 5, SD = 2, min = 1, max = 9),
    -   *tanine* (M = 50, SD = 10, min = 1, max = 100),
    -   *tetronic* (M = 10, SD = 4, min = 0, max = 20),
    -   *wechsler-iq* (M = 100, SD = 15, min = 40, max = 160)
-   `get_scoretables()` - returns scoring tables in specified computed
    scale,
-   `get_computed_scores()` - returns scores of source data for
    specified computed scale,
-   `get_computed_scores_ext()` - returns scores of external data for
    specified computed scale.

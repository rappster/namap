
<!-- README.md is generated from README.Rmd. Please edit that file -->

# namap

<!-- badges: start -->

[![Travis build
status](https://travis-ci.com/rappster/namap.svg?branch=master)](https://travis-ci.com/rappster/namap)
[![Codecov test
coverage](https://codecov.io/gh/rappster/namap/branch/master/graph/badge.svg)](https://codecov.io/gh/rappster/namap?branch=master)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

The goal of namap is to facilitate systematic column name management.

## Installation

``` r
remotes::install_github("namap")
```

## Usage (work in progress)

### Example data

``` r
library(magrittr)

data <- tibble::tibble(
  `Some ID` = letters[1:3],
  Date = c("2020-03-01", "2020-03-02", "2020-03-03"),
  Name = c("John", "Jane", "Neo"),
  Surname = c("Doe", "Doe", "Deo"),
  `Some Value` = 1:3
)
```

### Rename based on mapping specification

From (messy) external to clean internal names:

``` r
names_mapping <- list(
  list(external = "Some ID", internal = "id"),
  list(external = "Date", internal = "date"),
  list(external = "Name", internal = "name"),
  list(external = "Surname", internal = "surname"),
  list(external = "Some Value", internal = "value")
)

cols <- namap::map_names(
  mapping = names_mapping,
  from = "external",
  to = "internal"
)

date_renamed <- data %>% 
  dplyr::rename(!!!cols)
date_renamed
#> # A tibble: 3 x 5
#>   id    date       name  surname value
#>   <chr> <chr>      <chr> <chr>   <int>
#> 1 a     2020-03-01 John  Doe         1
#> 2 b     2020-03-02 Jane  Doe         2
#> 3 c     2020-03-03 Neo   Deo         3
```

From internal to external names:

``` r
cols <- namap::map_names(
  mapping = names_mapping,
  from = "internal",
  to = "external"
)

date_renamed %>%  
  dplyr::rename(!!!cols)
#> # A tibble: 3 x 5
#>   `Some ID` Date       Name  Surname `Some Value`
#>   <chr>     <chr>      <chr> <chr>          <int>
#> 1 a         2020-03-01 John  Doe                1
#> 2 b         2020-03-02 Jane  Doe                2
#> 3 c         2020-03-03 Neo   Deo                3
```

-----

## Using a YAML file that contains the name mapping definitions

If you use this package in conjunction with
[confx](https://github.com/rappster/confx), the name mapping
specification could be part of a YAML file (e.g. `./config.yml`):

**NOTE: What I illustrate below currently doesn’t work yet as YAML files
outside the project/package root directory will cause an error. This is
a current limitation of package `{confx}` as it relies on `{here}`.
After createing a YAML file with above content inside your root
directory, the following will work**

### Create example YAML content

``` r
yaml_content <- '
default:
  cols:
    id:
      internal: id
      external: "Some ID"
    date:
      internal: date
      external: Date
    name:
      internal: name
      external: Name
    surname:
      internal: surname
      external: Surname
    value:
      internal: value
      external: (Some) value
'

temp_file <- tempfile(fileext = ".yml")
write(yaml_content, temp_file)
```

Set environment variable that `get_name()` and `get_names()` uses
internally.

``` r
Sys.setenv(R_CONFIG_NAMES = temp_file)
```

### Map names using `{confx}`

``` r
names_mapping <- list(
  confx::conf_get("cols/id"),
  confx::conf_get("cols/date"),
  confx::conf_get("cols/name"),
  confx::conf_get("cols/surname"),
  confx::conf_get("cols/value")
)

cols <- namap::map_names(
  mapping = names_mapping,
  from = "external",
  to = "internal"
)
```

Or even simpler:

``` r
names <- c(
  "cols/id",
  "cols/date",
  "cols/name",
  "cols/surname",
  "cols/value"
)

cols <- namap::map_names(
  mapping = names,
  from = "external",
  to = "internal"
)
```

### Get single name from mapping definition

``` r
namap::get_name("cols/global/id")
namap::get_name("cols/global/id", type = "external")
namap::get_name("cols/global/id", type = "external_clean")
```

### Get multiple names from mapping definition

``` r
namap::get_names(
  "cols/global/id",
  "cols/global/date",
  "cols/global/name"
)

namap::get_names(
  "cols/global/id",
  "cols/global/date",
  "cols/global/name", 
  type = "external"
)

namap::get_names(
  "cols/global/id",
  "cols/global/date",
  "cols/global/name",
  type = "external_clean"
)
```

# configure data directories
# source base functions
# load libraries
#######################################
library(here)
library(ggplot2)
library(data.table)
library(plotly)
library(magrittr)
library(knitr)
library(httr)
library(kableExtra)
library(tidyverse)
library(zip)
library(scales)
library(lubridate)
library(pander)
library(ggrepel)
library(DiagrammeR)
library(DiagrammeRsvg)
library(rsvg)

# define directories
data_dir <- paste0(here::here(), "/monitoring/example/data/raw/")
out_dir_w <- paste0(here::here(),"/monitoring/example/data/weekly_sendout/")
code_dir <- paste0(here::here(), "/monitoring/example/code/functions/")
tab_dir <- paste0(here::here(), "/monitoring/example/tables/")

# source base functions  
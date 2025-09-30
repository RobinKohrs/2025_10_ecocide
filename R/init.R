# Load required packages
library(here)
library(tidyverse)
library(sf)
library(glue)
library(httr)
library(cli)
library(davR)
library(terra)


# Set up project paths
data_raw_path = here("data_raw")
data_output_path = here("data_output")
graphic_output_path = here("graphic_output")


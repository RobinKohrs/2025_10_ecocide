library(tidyverse)
library(here)
library(glue)
library(sf)
library(davR)
library(jsonlite)
library(mapview)
m <- mapview

# ++++++++++++++++++++++++++++++
# read in data ----
# ++++++++++++++++++++++++++++++
geo_omv_dafni_8857 <- read_sf(here("data_raw/data_dafni/Austria-all-blocks.gpkg"))

geo_pa_8857 <- read_sf(here("data_raw/output/wdpa/austria/wdpa_austria_polygons.gpkg")) %>%
  st_transform(8857)


# ++++++++++++++++++++++++++++++
# intersections ----
# ++++++++++++++++++++++++++++++
geo_omv_dafni_8857 <- geo_omv_dafni_8857 %>%
  rename_with(~ paste0("ms_", .), .cols = -attr(., "sf_column"))

geo_pa_8857 <- geo_pa_8857 %>%
  rename_with(~ paste0("pa_", .), .cols = -attr(., "sf_column"))

geo_int_blocks_pa <- st_intersection(
  geo_pa_8857,
  geo_omv_dafni_8857
)

geo_int_blocks_pa %>%
  select(
    ms_descriptio,
    ms_name,
    ms_adm_co_gro,
    ms_adm_co_nam,
    ms_admin_area,
    ms_attributio,
    ms_lc_status,
    ms_lc_type,
    ms_mps_create,
    ms_mps_dataso,
    pa_NAME,
    pa_ORIG_NAME,
    pa_DESIG,
    pa_DESIG_ENG,
    pa_DESIG_TYPE,
    pa_IUCN_CAT,
    pa_INT_CRIT,
    pa_GOV_TYPE
  ) -> geo_int_pa_ms_at



# write out intersections
path_out_intersections <- sys_make_path(here("data_output/intersections_mapstand_pa_austria/intersections_mapstand_pa_austria.fgb"))
unlink(path_out_intersections)
write_sf(geo_int_blocks_pa %>% st_transform(4326), path_out_intersections)

# ++++++++++++++++++++++++++++++
# get only OMV ----
# ++++++++++++++++++++++++++++++
geo_int_pa_ms_at_omv <- geo_int_blocks_pa_omv <-
  geo_int_blocks_pa %>%
  filter(str_detect(ms_adm_co_gro, "OMV"))


# ++++++++++++++++++++++++++++++
# types ----
# ++++++++++++++++++++++++++++++

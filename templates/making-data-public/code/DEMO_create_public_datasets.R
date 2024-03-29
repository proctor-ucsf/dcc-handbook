#-------------------------------
# Create de-identified datasets
# with public patient-level IDs
# using the bridge dataset 
# generated by 
# DEMOSTUDY_generate_public_IDs
#-------------------------------

library(here)
library(tidyverse)

#-------------------------------
# read in the analysis dataset
# and the bridge dataset
#-------------------------------

df.analysis <- read_rds(here("data/final/primary_analysis/DEMO_primary_analysis.rds"))

bridge <- read_csv(here("data/final/make_public/DEMO_internal_to_publicID.csv"))
#-------------------------------
# join In the public IDs
# drop internal IDs
#-------------------------------
df.analysis_public <- bridge %>%
  inner_join(df.analysis, by = "studyID") %>% 
  select(-studyID)

#-------------------------------
# save the public dataset
# in rds and csv formats
#-------------------------------
# rds
df.analysis_public %>% write_rds(here("data/public/DEMO_primary_analysis_public.rds"))

# csv
df.analysis_public %>% write_csv(here("data/public/DEMO_primary_analysis_public.csv"))

#-------------------------------
# Example script
# to demonstrate the creation of
# public patient-level IDs
#-------------------------------

library(here)
library(tidyverse)

#-------------------------------
# Read in data 
#-------------------------------

df <- read_csv(here("data/final/primary_analysis/DEMO_primary_analysis.csv"))

#-------------------------------
# create a public ID variable
# in a bridge dataset
# linking internal & public IDs
#-------------------------------
bridge <- df %>%
  select(studyID) %>%
  mutate(id_public = paste0("person-", rank(studyID)))

#-------------------------------
# save bridge dataset
#-------------------------------
bridge %>% write_csv(here("data/final/make_public/DEMO_internal_to_publicID.csv"))


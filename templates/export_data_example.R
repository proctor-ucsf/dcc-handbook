#Purpose: runs API to download and write all data from example study
#Requires:
#Date: 07/31/2019

#for debugging
debug <- F
if(debug){
  date <- format(Sys.Date(), "%d%b%Y")
  setwd("~/Documents/longitudinal/monitoring/EXAMPLE/data/weekly_sendout")
  download_folder <- paste0("../../data/")
  data_loc <- paste0(download_folder,"export_", date)
  headquarters_address <- "https://EXAMPLE.mysurvey.solutions"
  api_meta <- fread(paste0("../../tables/api_meta.csv"))
}

#Run api for each form (and version)
export.data <- function(download_folder, data_loc, headquarters_address, api_meta){
  for(i in 1:nrow(api_meta)) {
    #tabular or paradata?
    export_type <- api_meta[i]$type
    
    #which version of form?
    version <- api_meta[i]$version
    questionnaire_identity <- api_meta[i]$id
    form <- api_meta[i]$form
    mul_versions <- api_meta[i]$multiple_version
    survey_name <- api_meta[i]$survey_name
    
    #set other args for saving
    mordorzip <- paste0("BF_studyname_", export_type, "_", api_meta[i]$form, ".zip")
    
    #run api function
    run_api(download_folder, mordorzip, headquarters_address, export_type, questionnaire_identity)
    
    #rename the file and unzip
    if(export_type == "tabular"){
      file.rename(paste0(data_loc, "/interview__diagnostics.tab"), 
                  paste0(data_loc, "/intdiag_", form, "_", version, ".tab"))
      file.rename(paste0(data_loc, "/interview__actions.tab"), 
                  paste0(data_loc, "/intactions_", form, "_", version, ".tab"))
      file.rename(paste0(data_loc, "/", survey_name,".tab"), 
                  paste0(data_loc, "/", survey_name, "_", version,".tab"))
    }
    if(export_type == "paradata"){
       file.rename(paste0(data_loc, "/paradata.tab"), 
                   paste0(data_loc, "/paradata_", form, "_", version, ".tab"))
    }
  }
}
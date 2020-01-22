#############################################################################
#Read in data################################################################
#############################################################################
#load ALL data
#actual forms
#api_meta <- api_meta[primary == 1]
dt_list <- map(unique(api_meta$form_code), function(i){
  #set args
  form_name <- api_meta[form_code==i,survey_name]
  form <- i
  version <- api_meta[form_code==i, version]
  mul_versions <- api_meta[form_code==i, multiple_version]
  
  #read in data
  read.delim(paste0(data_loc, "/", form_name,"_", version, ".tab"))
})


#bring list elements in environment as data frames
names(dt_list)<- unique(api_meta$form_code)
for(x in names(dt_list)){  
  #convert list element to data.table
  assign(x, dt_list[[x]], envir = .GlobalEnv)
  assign(x, as.data.table(get(x)))
  dt <- get(x)
  
  #convert date variables to character class (some are read in as logical...)
  vars <- dt[,grep("date", names(dt), value = T)]
  vars <- c(vars, dt[,grep("Date", names(dt), value = T)])
  dt[, (vars) := lapply(.SD, as.character), .SDcols = vars]
  assign(x, dt)
}

# #bind together forms with multiple versions
# api_meta_mul <- api_meta[multiple_version==1]
# for(i in api_meta_mul[,unique(form_final)]){
#   nams <- api_meta_mul[form_final==i, form_code]
#   temp <- dt.list[names(dt.list) %in% nams]
#   assign(paste0("dt.", i), rbindlist(mget(nams), fill = T))
# }

#remove large list
rm(dt_list)

#read in treatment letters by ID and misc tables
dt.letters <- fread(paste0(tab_dir, "treatment_letters.csv"))

#############################################################################
#Clean data##################################################################
#############################################################################
#clean and convert to date class
dt.eligibility %<>%
  mutate(startTime=as.Date(startTime))
dt.baseline %<>%
  mutate(startTime=as.Date(startTime))
dt.anthro %<>%
  mutate(startTime=as.Date(startTime))
dt.treatment %<>%
  mutate(startTime=as.Date(startTime))
dt.blood %<>%
  mutate(startTime=as.Date(startTime))
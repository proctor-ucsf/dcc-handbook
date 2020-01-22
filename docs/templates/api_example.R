#This program was created by Ying Lin by following:

#1.Tutorial: Access Survey Solutions API with R
#https://rstudio-pubs-static.s3.amazonaws.com/239851_1bc298ae651c41c7a65e09ce82f9053f.html
#2.Error using API interface
#https://forum.mysurvey.solutions/t/error-using-api-interface/1155

#Name:API
#Date Created: December 11th, 2018
#Modified: February 9th, 2019
#Remark: Sleep should be working

#function settings
run_api <- function(download_folder, zip_name, headquarters_address, export_type, q_id){
  #Tips about finding the qustionnaire identity under:
  #Surveys and Statuses--->Click on BF Pre-Census
  #Questionnaire identity is a composite identifier of the questionnaire 
  #consisting of the GUID of the questionnaire followed by the dollar sign
  #followed by version index number
  
  #Specify action start to request the export file in the corresponding format 
  #to be rebuilt on the server
  action = "start"
  #use the sprintf() function to put the query together
  query <- sprintf("%s/api/v1/export/%s/%s/%s", 
                   headquarters_address, export_type, q_id, action)
  query
  #The next thing we need to do is request that the server builds the file. 
  #We can do that using the POST function which is available in the httr package.
  #POST request: requesting the re-creation of a particular export file
  data <- POST(query, authenticate("example_username", "example_password"))
  #Notably, the status code 200 indicates that the operation was successful. 
  #str(data)
  data$status_code
  
  #This part is to check if the data generation process is done or not
  action="details"
  query <- sprintf("%s/api/v1/export/%s/%s/%s", 
                   headquarters_address, export_type, q_id, action)
  datadetail<-GET(query, authenticate("apily", "Mordor1234"))
  contentdetail<-content(datadetail)
  progress_in_percent<-contentdetail$RunningProcess$ProgressInPercents
  
  #iterate for 25 minutes, stopping every 30 seconds to check if the data has been generated
  counter <- 1
  while(!is.null(progress_in_percent) > 0 & counter < 50){
    Sys.sleep(30)
    counter <- counter + 1
    datadetail<-GET(query, authenticate("apily", "Mordor1234"))
    contentdetail<-content(datadetail)
    progress_in_percent<-contentdetail$RunningProcess$ProgressInPercents
    cat(counter)
    print(paste0("Percent generated ", progress_in_percent))
  }
  
  ###Step 2. Creating the query to download the dataset
  #GET request: inspecting the status of a particular export file
  action = ""
  query <- sprintf("%s/api/v1/export/%s/%s/%s", 
                   headquarters_address, export_type, q_id, action)
  data <- GET(query, authenticate("apily", "Mordor1234"))
  #str(data)
  redirectURL<-data$url
  rawdata<-GET(redirectURL)
  #str(rawdata)
  
  ###Step 3. Write the zip file, unzip, and read in files to a list
  #open connection to write contents
  filecon <- file(paste0(download_folder,zip_name), "wb") 
  #write data contents to the temporary file
  writeBin(rawdata$content, filecon) 
  #close the connection
  close(filecon)
  #unzip zip file
  date <- format(Sys.Date(), "%d%b%Y")
  zipF <- paste0(download_folder, zip_name)
  unzip(zipF, exdir=paste0(download_folder,"export_", date))
}
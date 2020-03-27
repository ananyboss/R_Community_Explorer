#install.packages("httr")
library("httr")
# install.packages("jsonlite")
library("jsonlite")

#Function to store .rds files for each month
yearwise_repositories <- function(year1){
  req <- GET("https://api.github.com/search/repositories?q=language:R&per_page=100&sort=stars&order=desc&page=1")
  stop_for_status(req)
  con <- (content(req, "parsed"))

  if (con[['total_count']] > 1000) {
    warning(con[['total_count']] , " repos. Only first 1000 returned", call. = FALSE)
  } else {
    message(con[['total_count']], " repos")
  }


  parts<-strsplit(req$header[['link']],">;")
  last<-strsplit(parts[[1]][2],"=")
  totalpages<-strtoi(last[[1]][length(last[[1]])])



  name<-c()
  repo_id<-c()
  created_at<-c()
  month_created<-c()

  for (i in 1:totalpages){
    req <- GET(paste("https://api.github.com/search/repositories?q=language:R&per_page=100&sort=stars&order=desc&page=",as.character(i),sep=""))
    stop_for_status(req)
    con <- (content(req, "parsed"))
    for(j in 1:100){
      year_month<-format(as.Date(con[['items']][[j]][['created_at']]),'%Y,%B')
      year=strsplit(year_month,",")[1][[1]][1]
      month=strsplit(year_month,",")[1][[1]][2]
      if(year==year1){
        name<-c(name,con[['items']][[j]][['name']])
        repo_id<-c(repo_id,con[['items']][[j]][['id']])
        created_at<-c(created_at,con[['items']][[j]][['created_at']])
        month_created<-c(month_created,month)
      }

    }
    print(i)
  }
  df<-data.frame(name,repo_id,created_at,month_created)
  month_wise<-split(df,interaction(month_created))
  for(element in names(month_wise)){
    saveRDS(month_wise[[element]],paste("repos_of_",as.character(element),"_",as.character(year1),".rds",sep=""))
  }
  # saveRDS(df,paste("repos_of_",year1,".rds"))
}

#Function to combine all .rds files and output json and csv files
combine_data <- function(year1){
  all_files<-list.files(pattern = ".rds")
  files<-c()
  for(file in all_files){
    if(strsplit(file,"_")[1][[1]][4] == paste(as.character(year1),".rds",sep="")){
      files<-c(files,file)
    }
  }
  name<-c()
  repo_id<-c()
  created_at<-c()
  month_created<-c()
  df<-data.frame(name,repo_id,created_at,month_created)
  for (file in files){
    df<-rbind(df,readRDS(file))
  }
  df<-df[order(df$created_at),]
  write.csv(df,file=paste("repos_of_",as.character(year1),".csv",sep=""),row.names=FALSE)

  json<-toJSON(df)
  write_json(json,paste("repos_of_",as.character(year1),".json",sep=""))
}

## install devtools package if it's not already
if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools")
}

## install dev version of rtweet from github
devtools::install_github("mkearney/rtweet")
library(rtweet)
args = commandArgs(trailingOnly=TRUE)

api_key <- "BDAXuqA2M4Ro6j4vE2p5BSDbv"
api_secret_key <- "wIyeHYJtfqlnGE1H3wjtH1FlP5bXVliHubRkBGEWWRPEtZ6XeF"
access_token <- args[1]
access_token_secret <- args[2]

token <- create_token(
  app = "Data_Collect_1234567890",
  consumer_key = api_key,
  consumer_secret = api_secret_key,
  access_token = access_token,
  access_secret = access_token_secret)



data <- search_tweets(q="#rstats", since=Sys.Date()-1, until=Sys.Date(),retryonratelimit = TRUE,include_rts = FALSE)

df<-data.frame(data$text,data$user_id,data$status_id,data$created_at,data$retweet_count)
write.table(df, "Tweet_data.csv", sep = ",", col.names = !file.exists("Tweet_data.csv"), append = TRUE,row.names=FALSE)

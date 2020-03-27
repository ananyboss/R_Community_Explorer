install.packages("rtweet")
library(rtweet)
args = commandArgs(trailingOnly=TRUE)

api_key <- "DKuqRXxAJ57CCqMCGwUTdm9Ct"
api_secret_key <- "DYVz1VBbo2ZYcr6cw8664qVDY3dIzzxCdShP2E0TlZKopPEmEL"
access_token <- "1242860641192304641-V0EvWx9KVeOiZNwFMjb4nCbR0b9Hm0"
access_token_secret <- args[1]

token <- create_token(
  app = "Data_Collect_1234567890",
  consumer_key = api_key,
  consumer_secret = api_secret_key,
  access_token = access_token,
  access_secret = access_token_secret)



data <- search_tweets(q="#rstats", since=Sys.Date()-1, until=Sys.Date(),retryonratelimit = TRUE,include_rts = FALSE)

df<-data.frame(data$text,data$user_id,data$status_id,data$created_at,data$retweet_count)
write.table(df, "Tweet_data.csv", sep = ",", col.names = !file.exists("Tweet_data.csv"), append = TRUE,row.names=FALSE)


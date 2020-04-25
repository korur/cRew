# constant variables

ccc = c('fever', 'cough', 'breath', 'home', "goout", 'gowork', 'mask', 'lat', 'long', 'timecon', 'usercon')

########

loader <- tagList(
  waiter::spin_flower(),
  br(),br(),
  h3("Connecting you to the cRew...",  style = "color:#1ee6be")
)


#######

if(!exists("databaseURL")){
  cli::cli_alert("set up your firebase databaseURL as in databaseURL <- 'https://xxxxx.firebaseio.com'")
}
 
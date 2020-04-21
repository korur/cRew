# constant variables

ccc = c('fever', 'cough', 'breath', 'home', "goout", 'gowork', 'mask', 'lat', 'long', 'timecon', 'usercon')


# accessing config file from local or remote linux. For personal use case Remove this use as in the following "#"

if (file.exists("~/workingdirectory/CoronaOutbreak/douhavefever/_firebase.yml")) { 
  config_file <- yaml::read_yaml("~/workingdirectory/CoronaOutbreak/douhavefever/_firebase.yml") 
} else { 
  config_file <- yaml::read_yaml("/etc/_firebase.yml")
}

# Create config
# config_file <- yaml::read_yaml("config_file.yml")   >> fill in database$apiKey, database$projectId and database$databaseURL
firebase::create_config(api_key = config_file$database$apiKey, project_id = config_file$database$projectId)
databaseURL <- config_file$database$databaseURL


########

loader <- tagList(
  waiter::spin_flower(),
  br(),br(),
  h3("Connecting to cRew...",  style = "color:#1ee6be")
)

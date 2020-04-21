# constant variables

ccc = c('fever', 'cough', 'breath', 'home', "goout", 'gowork', 'mask', 'lat', 'long', 'timecon', 'usercon')


# Setting up config file
# >> fill in database$apiKey, database$projectId and database$databaseURL in firebase.yml

#' Has Config
#' 
#' Ensure config file is present.
#' 
#' @keywords internal
has_config <- function(){
  has_config <- file.exists("firebase.yml")
  if(!has_config)
    stop(
      "Missing config file, create_config", call. = FALSE
    )
  invisible()
}

#' Check config
#' 
#' Checks that config is valid.
#' 
#' @keywords internal
#' # >> fill in database$apiKey, database$projectId and database$databaseURL in firebase.yml
check_config <- function(config){
  if(config$database$apiKey == "" && config$database$projectId == "" && config$database$databaseURL == "") {
    cli::cli_alert("Complete the config file: firebase.yml")
  } else {
  invisible() }
}


#' Retrieve Config
#' 
#' Retrieves config file.
#' 
#' @keywords internal
get_config <- function(){
  has_config()
  config <- yaml::read_yaml("firebase.yml")
  check_config(config)
  return(config)
}

## Apply the function to get the config_File
config <- get_config()
# Create Firebase config
firebase::create_config(api_key = config$database$apiKey, project_id = config$database$projectId)
databaseURL <- config$database$databaseURL




########

loader <- tagList(
  waiter::spin_flower(),
  br(),br(),
  h3("Connecting to cRew...",  style = "color:#1ee6be")
)

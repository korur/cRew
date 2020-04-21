#' user_data_crawl UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_user_data_crawl_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' user_data_crawl Server Function
#'
#' @noRd 
mod_user_data_crawl_server <- function(input, output, session, f){
  ns <- session$ns
  
  
}
    
## To be copied in the UI
# mod_user_data_crawl_ui("user_data_crawl_ui_1")
    
## To be copied in the server
# callModule(mod_user_data_crawl_server, "user_data_crawl_ui_1")
 

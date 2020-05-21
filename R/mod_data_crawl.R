#' data_crawl UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_data_crawl_ui <- function(id){
  ns <- NS(id)
  tagList(
    shiny::uiOutput(ns("usersp"))
  )
}
#' data_crawl Server Function
#'
#' @noRd 
mod_data_crawl_server <- function(input, output, session, f, tkn){
  ns <- session$ns
  # Accesing all data
  abcd <- eventReactive(f$req_sign_in(),{
    
    # Unnest User lists
  aa <- fireData::download(projectURL = databaseURL, fileName = "fire", token=tkn())
  aza <- dplyr::tibble(slots = aa)
  abc <- aza %>%
             tidyr::unnest_longer(slots)
  abc
    
  names_list <- matrix(unlist(abc[3,1]), nrow = 11)[,1]
  a <- list()
    
  for (i in 1:nrow(abc)){
         a[[i]] <- matrix(unlist(abc[i,1]), nrow = 11)[,2]
        }
  abc <- do.call(rbind, a) 
  colnames(abc) <- names_list 
  abc <- as.data.frame(abc, stringsAsFactors = TRUE)
  abc$lat <- as.numeric(as.character((abc$lat)))
  abc$long <- as.numeric(as.character((abc$long)))
  abc$timecon <- as.numeric(as.character((abc$timecon)))
  abc[,1:7] <- sapply(abc[,1:7], as.character)
  abc[,1:7] <- sapply(abc[,1:7], as.numeric)
  abc
  })
  
  # Accessing user specific data (Users can only access (read/write) to their own data.  
  # This is achieved by setting filepath as "fire/useruniqueid/" in fireData::download() & fireData::upload() calls.
  # User specific folders can be created by including user Id s as the folder names in the directory. Access uid by >> f$signed_in$response$uid
  # In addition, you need to set up Firebase database rules accordingly.
  
  abc_user <- list()
  
  abc_user_df <- eventReactive(f$req_sign_in(), {   
    
    aa_user <- fireData::download(projectURL = databaseURL, fileName = paste0("fire/", f$signed_in$response$uid), token=tkn())
    
    if(is.null(aa_user)) { 
      "If you have submitted your data, it will be available here next time you sign in"
    } else {
      
    for(i in 1:length(aa_user)) {
      abc_user[[i]] <- aa_user[[i]]$value
    
    }
    
    abc_user <- as.data.frame(do.call(rbind,abc_user))
    colnames(abc_user) <- ccc
    abc_user$lat <- as.numeric(as.character(abc_user$lat))
    abc_user$long <- as.numeric(as.character(abc_user$long))
    abc_user$timecon <- as.numeric(as.character(abc_user$timecon))
    abc_user <- abc_user[,-11] %>% dplyr::arrange(-timecon)
    abc_user$timecon <- as.character(abc_user$timecon  %>% as.POSIXct(origin="1970-01-01"))
    
    abc_user <- abc_user %>% 
      tibble::rownames_to_column() %>% 
      tidyr::gather(toggle, input, -rowname) %>% 
      tidyr::pivot_wider(names_from=rowname, values_from=input)
    
    if(ncol(abc_user) < 9) { 
      abc_user <- abc_user
    } else { 
        abc_user <- abc_user[,1:9]}
    
      }
    
   ######## 
  })
  
  output$usersp <- renderTable({
    abc_user_df()
      
  })
  
  # This module return two reactive outputs, 1st is data from all users, 2nd is user specific data.
  # Those outputs are used by other downstream modules. 
  rlist = list(abcd =abcd, abc_user_df=abc_user_df )
}
    
## To be copied in the UI
# mod_data_crawl_ui("data_crawl_ui_1")
    
## To be copied in the server
# callModule(mod_data_crawl_server, "data_crawl_ui_1")
 

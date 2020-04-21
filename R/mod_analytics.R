#' analytics UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_analytics_ui <- function(id){
  ns <- NS(id)
  tagList(
  
    shinyMobile::f7Col(h2("Current Local risk", style="text-align: center;"),
                       shinyMobile::f7Card(
                         echarts4r::echarts4rOutput(ns("risk2"))
                       )#f7Card
    )#f7col
    ,
    
    shinyMobile::f7Col(h2("Change in local risk (last 24h)",style="text-align: center;"),
                       shinyMobile::f7Card(
                         echarts4r::echarts4rOutput(ns("risk3"))
                       )#f7Card
                       
    ),#f7col
    
    shinyMobile::f7Col(h2("Total entries", align="center"),
                      shinyMobile::f7Card(
                           h2(
                             textOutput(ns("dpsa")), style="text-align: center;")
                                          )),  #f7col
      
      shinyMobile::f7Col(h2("Symptomatic cases", align="center"),
                       shinyMobile::f7Card(
                            h2(
                              textOutput(ns("fant")), style="text-align: center;"
                                            )
                                          )#f7Card
                       )#f7col

  ) #taglist
}
    
#' analytics Server Function
#'
#' @noRd 
mod_analytics_server <- function(input, output, session, abcd, lat, long, inp2){
  ns <- session$ns
  
  ## Data analytics from full data ( Uses output from data crawl module "rlist")
  ### Number of total data entries
  output$dpsa <- renderText({
    nrow(abcd()) 
  })
  ### Number of cases with symptoms
  output$fant <- renderText({
    df_a <- abcd() %>% dplyr::filter(fever == 1 | cough == 1 | breath == 1) %>% dplyr::count() 
    df_a$n
    
  })
  
  test <- reactive({ 
    
    abcde <- abcd() %>% dplyr::filter(lat < lat() + 0.9 & lat >  lat() - 0.9 & 
                                     long < long()+ 0.9 & long > long() - 0.9)
   
   
    if(nrow(abcde) < 1) { 
      "Waiting for others to upload data around your location"
      } else {  
        abcde <- abcde %>% 
        dplyr::mutate(risk=(2+fever+cough+breath+home+goout+gowork-mask+ ( (fever+cough+breath)*3*(goout+gowork) ))) %>% 
        dplyr::filter(timecon > max(timecon)-604800)
          if(nrow(abcde) <1) {
            "Waiting for others to upload data around your location"
          } else {
    return(abcde)
          }
      }
    })
  
  output$risk <- renderText({
   
    if( !is.character(test()) ) { 
   mean(test()$risk)
    } else {
      test()
    }
    
  })
  
 
  output$risk2 <- echarts4r::renderEcharts4r({
    
    if( is.character(test()) ) {   
      
      echarts4r::e_charts() %>% 
        echarts4r::e_gauge(0, "points",min=0,max=25, radius="95",
                           axisLine = list(
                             lineStyle = list(
                               color = list(
                                 c(.2, "#1ee6be"),
                                 c(1, "red") ))))   
    } else {
        
      echarts4r::e_charts() %>% 
        echarts4r::e_gauge(round(mean(test()$risk),1), "points",min=0,max=25, radius="95",
                           axisLine = list(
                             lineStyle = list(
                               color = list(
                                 c(.2, "#1ee6be"),
                                 c(1, "red") )))) 
      
      }
    
  })

  output$risk3 <- echarts4r::renderEcharts4r({
   
    if( is.character(test()) ) { 
   
    
    liquid <- data.frame(val = c(0,0.4,0.2), color=c("#1ee6be","yellow","red"))
  
    liquid %>% 
      echarts4r::e_charts() %>% 
      echarts4r::e_liquid(val, color=color) %>% echarts4r::e_theme("roma")
    
    } else {
      
        abcdf <- test() %>% dplyr::filter(timecon > max(timecon)-86400)
        abcdg <- test() %>% dplyr::filter(timecon < max(timecon)-86400)
        
        riskincrease <- ( 100 * (mean(abcdf$risk)-mean(abcdg$risk)) )/mean(abcdg$risk) 
        liquid <- data.frame(val = c(riskincrease/100,0.4,0.2), color=c("#1ee6be","yellow","red"))
        
        
        liquid %>% 
          echarts4r::e_charts() %>% 
          echarts4r::e_liquid(val, color=color) %>% echarts4r::e_theme("roma")
    }
  }) 
}
    
## To be copied in the UI
# mod_analytics_ui("analytics_ui_1")
    
## To be copied in the server
# callModule(mod_analytics_server, "analytics_ui_1")
 

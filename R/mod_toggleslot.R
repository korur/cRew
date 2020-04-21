#' toggleslot UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_toggleslot_ui <- function(id, name="fever", tglabel="I have fever", tgcolor="red"){
  ns <- NS(id)
 tagList(
    shinyMobile::f7Row(shinyMobile::f7Toggle(
      inputId = name,
      label = tags$p(tglabel, style = "font-size: 18px;"),
      color = tgcolor, 
      checked = FALSE
    ) #toggle
    ) # row
 )
}
    
#' toggleslot Server Function
#'
#' @noRd 
mod_toggleslot_server <- function(input, output, session){
  ns <- session$ns

}
    
## To be copied in the UI
# mod_toggleslot_ui("toggleslot_ui_1")
    
## To be copied in the server
# callModule(mod_toggleslot_server, "toggleslot_ui_1")

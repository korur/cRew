#' The application User-Interface --cRew--
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
#' move to config.file later

# See utils_helpers.R

app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here 
    shinyMobile::f7Page( 
            shinyjs::useShinyjs(),
            # Google Tracking ID
            tags$head(
              HTML("<!-- Global site tag (gtag.js) - Google Analytics -->
       <script async src='https://www.googletagmanager.com/gtag/js?id=UA-148414815-3'></script>
       <script>
       window.dataLayer = window.dataLayer || [];
     function gtag(){dataLayer.push(arguments);}
     gtag('js', new Date());
     
     gtag('config', 'UA-148414815-3');
     </script>"
              )),
           
            
            sever::use_sever(),
            waiter::use_waiter(), # dependencies
            waiter::waiter_show_on_load(loader, color = "#000000"),
            title = "Coranavirus Early warning System",
            dark_mode = FALSE,
            init = shinyMobile::f7Init(
              skin = "auto", 
              theme = "dark"
                         ),#f7init
            
            shinyMobile::f7TabLayout(
              navbar = shinyMobile::f7Navbar(
                title = h3("cRew", style = "text-align:left", color="#000000"),
                hairline = TRUE,
                shadow = TRUE,
                left_panel = TRUE,
                right_panel = FALSE
              ), # end of navbar
            
              shinyMobile::f7Panel(
                title = h4("cRew",style = "color:#1ee6be"), 
                side = "left", 
                theme = "light",
                effect = "cover",
                p(h3("Mapping in real-time healthy and symptomatic people. As users enter data about their health status, the app monitors temporal and spatial changes and estimates sudden increases or decreases on local risks. For Experimental use only.", style = "color:#1ee6be")),
                shinyMobile::f7Link(label = p("by DATAATOMIC", style = "color:#1ee6be"), src = "https://dataatomic.com", external = TRUE),
                shinyMobile::f7Link(label = p("Global Coronavirus Status",style = "color:#1ee6be"), src = "http://tools.dataatomic.com/shiny/CoronaOutbreak/", external = TRUE),
                shinyMobile::f7Link(label = p("Code",style = "color:#1ee6be"), src = "https://github.com/korur/cRew", external = TRUE)
              ), # end of panels
            
            shinyMobile::f7Tabs(
              animated = TRUE,
              id = 'tabs', 
            shinyMobile::f7Tab(h3(uiOutput("loginforfullfeatures"), style="text-align: center;color:#1ee6be"),
                               firebase::useFirebase(), # import dependencies,
                               firebase::useFirebaseUI(), 
                tabName = "Home",
                icon = shinyMobile::f7Icon("rocket"),
                active = TRUE,
                swipeable = TRUE, 
                shinyMobile::f7Card(shinyMobile::f7Button("togglePopup", "How to use",color = NULL,
                                                          fill = TRUE,
                                                          outline = FALSE,
                                                          shadow = FALSE,
                                                          rounded = TRUE),shinyMobile::f7Popup(
                  id = "popup1",
                  title = h2("How to use cRew"),
                  shinyMobile::f7Text("text", h3("Login"), "Get access via gmail or twitter"),
                  shinyMobile::f7Text("text", h3("Survey"), "Fill in your data and submit"),
                  shinyMobile::f7Text("text", h3("Maps"), "View your local map and risk analyses"),
                  shinyMobile::f7Text("text", h3("Resubmit"), "Submit again when you use the app"),
                  shinyMobile::f7Text("text", h3("History"), "View your past entries on history tab")
                )),
                
              
                
                shinyMobile::f7Card(tags$script('
  $(document).ready(function () {
    navigator.geolocation.getCurrentPosition(onSuccess, onError);

    function onError (err) {
    Shiny.onInputChange("geolocation", false);
    }
    
   function onSuccess (position) {
      setTimeout(function () {
          var coords = position.coords;
          console.log(coords.latitude + ", " + coords.longitude);
          Shiny.onInputChange("geolocation", true);
          Shiny.onInputChange("lat", coords.latitude);
          Shiny.onInputChange("long", coords.longitude);
      }, 1100)
  }
  });
'), mod_toggleslot_ui("toggleslot_ui_1", "fever", "I have fever", "blue")),
                shinyMobile::f7Card(mod_toggleslot_ui("toggleslot_ui_2", "cough", "I am coughing", "blue")),
                shinyMobile::f7Card(mod_toggleslot_ui("toggleslot_ui_3", "breath", "I have breathing difficulties", "blue")),
                shinyMobile::f7Card(mod_toggleslot_ui("toggleslot_ui_4", "home", "I stay home", "blue")),
                shinyMobile::f7Card(mod_toggleslot_ui("toggleslot_ui_5", "goout", "I go out occasionally", "blue")),
                shinyMobile::f7Card(mod_toggleslot_ui("toggleslot_ui_6", "gowork", "I go to work", "blue")),
                shinyMobile::f7Card(mod_toggleslot_ui("toggleslot_ui_7", "mask", "I wear mask", "blue")),
shinyMobile::f7Card(title="Location Information", shinyMobile::f7Col(width = 2,color="blue",
                                          verbatimTextOutput("lat"),
                                          verbatimTextOutput("long"),
                                          textOutput("usercon"),
)),               
firebase::reqSignin(shinyMobile::f7Card(shinyMobile::f7Col(width= 2, shinyMobile::f7Button(inputId ='save_inputs', label='Send',  color = NULL,
                                          fill = TRUE,
                                          outline = FALSE,
                                          shadow = FALSE,
                                          rounded = TRUE
) #f7Card
) #f7Col
), #f7Button
div(id = "form"),
shinyjs::hidden(
  div(
    id = "thankyou_msg",
    h3("Thanks, your response was submitted successfully!", align="center"),
    actionLink("submit_another", label=h3("Submit another response", align="center" ))
  ) #div 
    ) #hidden
      ) # Reqsignin
       ), # f7Tab
shinyMobile::f7Tab(
  tabName = "My Map",
  icon = shinyMobile::f7Icon("map"),
  active = FALSE,
  swipeable = TRUE,
  shinyMobile::f7Card(mod_mymap_ui("mymap_ui_1")
  ), shinyMobile::f7Fabs(
    extended = TRUE,
    label = "Menu",
    position = "left-bottom",
    color = "purple",
    sideOpen = "right",
    lapply(c("z+","z-"), function(i) shinyMobile::f7Fab(paste0("btn", i), i))
  ),
  lapply(c("zzzi","zzzo"), function(i) verbatimTextOutput(paste0("res", i))), # f7card
), # end of tab
shinyMobile::f7Tab(
  tabName = "Risk analysis",
  icon = shinyMobile::f7Icon("waveform"),
  active = FALSE,
  swipeable = TRUE,
  mod_analytics_ui("analytics_ui_1")
  
),    

shinyMobile::f7Tab(
  tabName = "Info",
  icon = shinyMobile::f7Icon("info"),
  active = FALSE,
  swipeable = TRUE,
  shinyMobile::f7ExpandableCard(
    id = "Usage",
    title = "Usage Information", 
    subtitle = "Click to open",
    fullBackground = FALSE,
    color="red",
    h3("Add your data on a daily basis or submit from other locations you are visiting (e.g grocery, work) so the app can achieve better estimation accuracy.", style = "color:white")
    
  ),
  shinyMobile::f7ExpandableCard(
    id = "news",
    title = "News & Updates",
    subtitle = "Click to open",
    fullBackground = FALSE,
    color = "orange", 
    h3("Updates about the app will appear here soon", style = "color:white")
  )
  ),shinyMobile::f7Tab(
    tabName = "My history",
    icon = shinyMobile::f7Icon("book-medical"),
    active = FALSE,
    swipeable = TRUE, shinyMobile::f7Row(shinyMobile::f7Card(mod_data_crawl_ui("data_crawl_ui_1"))))#tabend




             )# f7Tabs
            ) # f7 Tablayout
    ) # f7Page
  ) # taglist
} # function

#' Add external Resources to the Application
#' 
#' This function is internally used to add external 
#' resources inside the Shiny application. 
#' 
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
 golem_add_external_resources <- function(){
   addResourcePath(
     'www', system.file('app/www', package = 'cRew')
   )
     tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'CREW'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}



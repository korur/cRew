#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session, abcd = abcd()) {
  ## sever
  sever::sever(
    tagList(
      h1("C'est la vie!"),
      p("It looks like you were disconnected"),
      shiny::tags$button(
        "Reload",
        style = "color:#000;background-color:#fff;",
        class = "button button-raised",
        onClick = "location.reload();"
      )
    ),
    bg_color = "#000"
  )

  
  ## how to use
  
  output$popupContent <- renderPrint(input$text)
  
  observeEvent(input$togglePopup, {
    shinyMobile::f7TogglePopup(id = "popup1")
  })
  
  
  ## firebaseUI
  
  f <- firebase::FirebaseUI$
    new()$ # instantiate
    set_providers( # define providers
      twitter = TRUE, 
      google = TRUE
    )$
    set_tos_url("https://dataatomic.com/terms/"
    )$    
    set_privacy_policy_url("https://dataatomic.com/privacy/"
    )$
    launch() # launch
  
  ## Login for full features
  
  output$txtfull <- renderText({
    "Login to enable personalized features"
  })
  output$welcome <- renderText({
    "Welcome to cRew!"
  })
  
  ### Set up reactiveVal for enabling / disabling an UI output
  value <- reactiveVal(0)
  
  observeEvent(f$req_sign_in(),{
    newValue <- value() + 1
    value(newValue)
  })
  
  output$value <- reactive({
    value()
  })
  
  output$loginforfullfeatures <- renderUI({
    if(value()<1) {
                         shinyMobile::f7Card(textOutput("txtfull"))#f7Card
    } else {
  
                         shinyMobile::f7Card(textOutput("welcome"))#f7Card
    }
  })
  
  lat <- reactive({
   if(!is.null(input$lat)){
     input$lat
   } else {
     71.00389
   }
  })
  
  long <- reactive({
    if(!is.null(input$long)){
      input$long
    } else {
      -42.6
    }
  })
  
  zoomin <- reactive({
    input$'btnz+'
  })
  
  zoomout <- reactive({
    input$'btnz-'
  })
  ### Location Output ###
  
  output$lat <- renderText({
    paste("Latitude:", lat())
  })
  
  output$long <- renderText({
    paste("Longitude:", long())
  }) 
  
  
  ### User email address will be shown in Home screen if signed via gmail
  output$usercon <- eventReactive(f$req_sign_in(), { 
    if(f$signed_in$response$providerData[[1]]$providerId == "twitter.com"){ 
      paste0("You are logged in via:","\n", "twitter.com")
    } else {
    paste0("You are logged in as:","\n", f$signed_in$response$email)
    }
  })
  
  ### User email as reactive variable
  usercon <- eventReactive(f$req_sign_in(), {   
    if(f$signed_in$response$providerData[[1]]$providerId == "twitter.com"){ 
      "twitter"
    } else {
        f$signed_in$response$email }
  })
  
  ### Timestamp when user clicks "send" button
  timecon <- eventReactive(input$save_inputs, { 
    Sys.time()
  })
  
  ### Token generated during firebase authentication
  tkn <- eventReactive(f$req_sign_in(), {   
    f$signed_in$response$stsTokenManager$accessToken
  }) 
  
  ## Call data crawl module
  
  rlist <- callModule(mod_data_crawl_server, "data_crawl_ui_1", f, tkn)
  
 
  ## Call map module ( Uses output from data crawl module "rlist")
  
  callModule(mod_mymap_server, "mymap_ui_1", rlist[[1]], lat, long, zoomin, zoomout)
  
  ## Call analytics module
  
  callModule(mod_analytics_server, "analytics_ui_1", rlist[[1]], lat, long, inp2)
  
  # Create g_uid() reactive variable. This allows users to read/write to their own data folders only
  g_uid <- eventReactive(f$req_sign_in(), {   
    f$signed_in$response$uid
  })
  
  
 observeEvent(input$save_inputs, {
    shinyjs::disable('save_inputs')
    shinyjs::reset("form")
    shinyjs::hide("form")
    shinyjs::show("thankyou_msg")
  })
  
 observeEvent(input$submit_another, {
    shinyjs::show("form")
    shinyjs::enable('save_inputs')
    shinyjs::hide("thankyou_msg")
  })

 # Saving user specific inputs. g_uid() and tkn() ensures only authenticated users can read/write and only to their own folders.
  inp2 <- observeEvent(input$save_inputs, {
    # Define inputs to save
    inputs_to_save <- c('fever', 'cough', 'breath', 'home', "goout", 'gowork', 'mask')
    # Declare inputs
    inputs <- NULL
    # Append all inputs before saving to folder
    for(input.i in inputs_to_save){
      inputs <- append(inputs, as.numeric(input[[input.i]]))
    }
    inputs <- append(inputs, c(lat(), long(), timecon(), usercon() ) )
    # Inputs data.frame
    inputs_data_frame <- data.frame(inputId = c(inputs_to_save, c("lat", "long", "timecon","usercon")), value = inputs)
    
    # Save Inputs
    fireData::upload(x = inputs_data_frame, projectURL = databaseURL, directory = paste0("fire/",g_uid()), token=tkn())
    return(inputs_data_frame)
  }) 
  
  observeEvent(input$save_inputs, {
    shinyjs::disable('save_inputs')
    shinyjs::reset("form")
    shinyjs::hide("form")
    shinyjs::show("thankyou_msg")
  })
  

  Sys.sleep(1.8)
  waiter::waiter_hide()
}

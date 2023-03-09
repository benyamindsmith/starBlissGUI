library(shiny)
library(shinyWidgets)

ui <- fluidPage(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
      ),
    br(),
    sidebarLayout(
        mainPanel(),
        sidebarPanel(
          navbarPage("Create Your Custom Star Map",
                     id = "navbar",
                     tabPanel("Size",
                              radioGroupButtons(
                                "radio",
                                choiceNames = c('A4 (42.0 x 59.4cm)',
                                                'A3 (29.7 x 42.0cm)',
                                                'A2 (21.0 x 29.7cm)'),
                                choiceValues = c("A4", "A3","A2"),
                                size="lg",
                                direction="vertical"
                              ),
                              actionBttn("to_design",
                                         "Next Step")),
                     tabPanel("Design",
                              radioGroupButtons(
                                "radio",
                                choiceNames = c('<div class="icon_black"></div>',
                                                '<div class="icon_green"></div>'),
                                choiceValues = c("black", "green")
                              ),
                              verbatimTextOutput("test"),
                              
                              div(
                              style = "position:absolute;right:1em;",
                              actionBttn("to_moment",
                                         "Next Step")),
                              actionBttn("back_size",
                                         "Go Back")),
                     tabPanel("Moment",
                              textInput("location","Location of Your Special Moment"),
                              airDatepickerInput("date",
                                                 "Your Special Date",
                                                 value = lubridate::today(),
                                                 todayButton=TRUE,
                                                 autoClose = TRUE),
                              textInput("line1","Add A Special Message",placeholder = "Line 1"),
                              textInput("line2","",placeholder = "Line 2"),
                              textInput("line3","",placeholder = "Line 3"),
                              div(
                                style = "position:absolute;right:1em;",
                                actionBttn("to_finish",
                                           "Next Step")),
                              actionBttn("back_design",
                                         "Go Back")),
                     tabPanel("Finish")
          )
        )
    )
)


server <- function(input, output) {
  
 
  observeEvent(input$to_design, {
    updateNavbarPage(inputId="navbar",selected = "Design")
  })
  
  observeEvent(input$back_size, {
    updateNavbarPage(inputId="navbar",selected = "Size")
  })
  
  observeEvent(input$to_moment, {
    updateNavbarPage(inputId="navbar",selected = "Moment")
  })
  
  observeEvent(input$back_design, {
    updateNavbarPage(inputId="navbar",selected = "Design")
  })
  
  output[["test"]] <- renderPrint({
    input[["radio"]]    
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

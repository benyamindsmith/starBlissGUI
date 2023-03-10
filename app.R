library(shiny)
library(shinyWidgets)
library(starBliss)
library(ggplot2)

ui <- fluidPage(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
      ),
    br(),
    sidebarLayout(
        mainPanel(
          
          div(
            style = "width: 50%; margin: 0 auto;", 
            uiOutput("starmap_output")
          )
        ),
        sidebarPanel(
          navbarPage("Create Your Custom Star Map",
                     id = "navbar",
                     tabPanel("Size",
                              radioGroupButtons(
                                "size",
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
                                "style",
                                choiceNames = c('<div class="icon_black"></div>',
                                                '<div class="icon_green"></div>'),
                                choiceValues = c("black", "green"),
                                selected = "black"
                              ),
                              div(
                              style = "position:absolute;right:1em;",
                              actionBttn("to_moment",
                                         "Next Step")),
                              actionBttn("back_size",
                                         "Go Back")),
                     tabPanel("Moment",
                              textInput("location",
                                        "Location of Your Special Moment",
                                        value = "Toronto, ON, Canada"),
                              airDatepickerInput("date",
                                                 "Your Special Date",
                                                 value = lubridate::today(),
                                                 todayButton=TRUE,
                                                 autoClose = TRUE),
                              textInput("line1",
                                        "Add A Special Message",
                                        value = "Toronto, ON, Canada",
                                        placeholder = "Line 1"),
                              textInput("line2",
                                        "Line 2",
                                        value = lubridate::today(),
                                        placeholder = "Line 2"),
                              textInput("line3",
                                        "Line 3",
                                        value = "43.6532° N, 79.3832° W",
                                        placeholder = "Line 3"),
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
 
  listener <- reactive({
    list(input$location,input$style)
  })
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
  
  observeEvent(listener(),{
    map<- starBliss::plot_starmap(location=input[["location"]],
                                  style = input[["style"]])
    print(input[["style"]])
    ggsave("./www/my_plot.png", 
           plot = map, 
           width = unit(10, 'in'), 
           height = unit(15, 'in'),
           dpi=150)
    
  })
  
  
  output[["starmap_output"]]<- renderUI({
  
    img(src="my_plot.png",height="800px")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

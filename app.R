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
                     tabPanel("Size"),
                     tabPanel("Design",
                              radioGroupButtons(
                                "radio",
                                choiceNames = c('<div class="icon_black"></div>',
                                                '<div class="icon_green"></div>'),
                                choiceValues = c("black", "green")
                              ),
                              verbatimTextOutput("test")),
                     tabPanel("Moment"),
                     tabPanel("Finish")
          )
        )
    )
)


server <- function(input, output) {
  output[["test"]] <- renderPrint({
    input[["radio"]]    
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

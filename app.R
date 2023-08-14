library(shiny)
library(shinyWidgets)
library(shinyjs)
library(starBliss)
library(ggplot2)

ui <- fluidPage(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
      ),
    br(),
    div(
      style = "width: 60%; margin: 0 43%;",
      HTML('<img src="starbliss_header_2.svg" class ="header_logo" height = 100px>')
    ),
    setBackgroundImage("poster_background.jpg"),
    sidebarLayout(
      mainPanel(div(
        id = "wrapper",
        div(
          class = "content",
          style = "position: fixed;width:27%; margin-left:36%;",
          imageOutput("starmap_output")
        )
       )
      ),
        sidebarPanel(
          navbarPage("Create A Custom Star Map",
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
                     tabPanel("Finish",
                              downloadButton("downloadImage"),
                              actionBttn("donate_redirect",
                                         "Donate",
                                         icon = icon("paypal"),
                                         onclick ="window.open('https://www.paypal.com/donate/?hosted_button_id=DU6DV4ADGLQYU')")
                              )
          )
        )
    )
)


server <- function(input, output,session) {
 
  listener <- reactive({
    list(input$style,
         input$location,
         input$date,
         input$line1,
         input$line2,
         input$line3)
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
  
  # Define reactive values to store plot object
  rv <- reactiveValues(plot = NULL)
  
  # Create observer to update plot object whenever input changes
  observeEvent(listener(), {
    plot <- starBliss::plot_starmap(
      location = ifelse(is.na(input[["location"]]) ||input[["location"]] == "","Toronto, ON, Canda",input[["location"]]),
      date = input[["date"]],
      style = input[["style"]],
      line1_text = input[["line1"]],
      line2_text = input[["line2"]],
      line3_text = input[["line3"]]
    )
    rv$plot <- plot
  })
  
  
  output[["starmap_output"]] <- renderImage({
    if (!is.null(rv$plot)) {
      # Create a temporary file name for the plot
      tmp <- tempfile(fileext = ".png")
      # Save the plot as a png image
      ggsave(tmp, rv$plot, width = 10, height = 15, dpi = 150)
      # Return the png image
      list(src = tmp, width = "100%", height = "auto", alt = "starmap")
    }
  }, deleteFile = TRUE)
  
  output[["downloadImage"]] <- downloadHandler(
    filename = function() {
      paste0("starmap_",input[["style"]],"_",input[["location"]], ".png")
    },
    content = function(file) {
      if (!is.null(rv$plot)) {
        switch(input[["size"]],
               "A4" = ggsave(file, rv$plot, width = 42.0, height = 59.4, units="cm", dpi = 150),
               "A3" = ggsave(file, rv$plot, width = 29.7, height = 42.0, units="cm", dpi = 150),
               "A2" = ggsave(file, rv$plot, width = 21.0, height = 29.7, units="cm", dpi = 150))
        
      }
    }
  )
}

# Run the application 
shinyApp(ui = ui, server = server)

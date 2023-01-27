library(shiny)
library(shinyWidgets)

# Function for Making Radio Images
radioImages <- function(inputId, images, values){
  radios <- lapply(
    seq_along(images),
    function(i) {
      id <- paste0(inputId, i)
      tagList(
        tags$input(
          type = "radio",
          name = inputId,
          id = id,
          class = "input-hidden",
          value = as.character(values[i])
        ),
        tags$label(
          `for` = id,
          tags$img(
            src = images[i]
          )
        )
      )
    }
  )
  do.call(
    function(...) div(..., class = "shiny-input-radiogroup", id = inputId), 
    radios
  )
}

radio_css<- HTML(
  ".input-hidden {",
  "  position: absolute;",
  "  left: -9999px;",
  "}",
  "input[type=radio] + label>img {",
  "  width: 50px;",
  "  height: 50px;",
  "}",
  "input[type=radio]:checked + label>img {",
  "  border: 1px solid #fff;",
  "  box-shadow: 0 0 3px 3px #45b6fe;",
  "}"
)


ui <- fluidPage(
    tags$head(tags$style(radio_css)),
    br(),
    sidebarLayout(
        mainPanel(),
        sidebarPanel(
          navbarPage("Create Your Custom Star Map",
                     tabPanel("Size"),
                     tabPanel("Design",
                              radioImages(
                                "radio",
                                images = c("//./www/black.svg",
                                           "//./www/green.svg"),
                                values = c("black", "green")
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

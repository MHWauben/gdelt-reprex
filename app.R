library(shiny)
library(magrittr)
library(stringr)

ui <- fluidPage(
  titlePanel("GDELT test"),
  sidebarLayout(
    sidebarPanel(
      textInput(inputId = "query",
                  label = "Query to run:")
      
    ),
    mainPanel(
      tableOutput(outputId = "data_out")
    )
  )
)

server <- function(input, output) {
  query <- reactive({
    require(nchar(input$query) > 4)
    print('Pre-process query')
    u_rep <- stringr::str_replace_all(input$query, ' ', '%20') %>% stringr::str_replace_all('"', '%22') %>% stringr::str_replace_all("'", "%22")
    full_call <- paste0('https://api.gdeltproject.org/api/v2/doc/doc?query=', u_rep, '&mode=TimelineSourceCountry&format=csv&timespan=4m')
    return(full_call)
  })
  
  data <- reactive({
    require(nchar(input$query) > 4)
    print('Load data')
    read.csv(query())
  })
  
  output$data_out <- renderTable({
    data()
  })
  
}

shinyApp(ui, server)

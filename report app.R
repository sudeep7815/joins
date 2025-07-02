library(shiny)
library(ggplot2)
library(dplyr)

# UI
ui <- fluidPage(
  titlePanel("Iris Data Explorer"),
  
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("species", "Choose Species:",
                         choices = unique(iris$Species),
                         selected = unique(iris$Species)),
      sliderInput("sepal_length", "Sepal Length Range:",
                  min = min(iris$Sepal.Length),
                  max = max(iris$Sepal.Length),
                  value = c(min(iris$Sepal.Length), max(iris$Sepal.Length))),
      br(),
      downloadButton("download_data", "Download Report (CSV)")
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Sepal Plot", plotOutput("sepal_plot")),
        tabPanel("Petal Plot", plotOutput("petal_plot")),
        tabPanel("Filtered Table", tableOutput("iris_table"))
      )
    )
  )
)

# Server
server <- function(input, output) {
  
  # Reactive filtered data
  filtered_iris <- reactive({
    iris %>%
      filter(Species %in% input$species,
             Sepal.Length >= input$sepal_length[1],
             Sepal.Length <= input$sepal_length[2])
  })
  
  # Sepal plot
  output$sepal_plot <- renderPlot({
    ggplot(filtered_iris(), aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
      geom_point(size = 3) +
      theme_minimal() +
      labs(title = "Sepal Length vs Width", x = "Sepal Length", y = "Sepal Width")
  })
  
  # Petal plot
  output$petal_plot <- renderPlot({
    ggplot(filtered_iris(), aes(x = Petal.Length, y = Petal.Width, color = Species)) +
      geom_point(size = 3) +
      theme_minimal() +
      labs(title = "Petal Length vs Width", x = "Petal Length", y = "Petal Width")
  })
  
  # Table output
  output$iris_table <- renderTable({
    filtered_iris()
  })
  
  # Download report handler
  output$download_data <- downloadHandler(
    filename = function() {
      paste("iris_filtered_report_", Sys.Date(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(filtered_iris(), file, row.names = FALSE)
    }
  )
}

# Run the application
shinyApp(ui = ui, server = server)

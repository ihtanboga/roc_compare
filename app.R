library(shiny)
library(ggplot2)
library(pROC)
library(readxl)

# Define UI
ui <- fluidPage(
  titlePanel("ROC Curve Comparison"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("data_file", "Upload Data File (Excel format)", accept = ".xlsx"),
      uiOutput("dependent_var_select"),
      uiOutput("independent_vars_select")
    ),
    
    mainPanel(
      plotOutput("roc_plot"),
      tableOutput("auc_table"),
      verbatimTextOutput("pvalue_output")
    )
  )
)

# Define server
server <- function(input, output, session) {
  # Read data from uploaded file
  data <- reactive({
    req(input$data_file)
    read_excel(input$data_file$datapath)
  })
  
  # Update variable choices based on uploaded data
  observe({
    data_df <- data()
    var_names <- names(data_df)
    
    output$dependent_var_select <- renderUI({
      selectInput("dependent_var", "Select Dependent Variable", choices = var_names)
    })
    
    output$independent_vars_select <- renderUI({
      selectInput("independent_vars", "Select Independent Variables", choices = var_names, multiple = TRUE)
    })
  })
  
  # Generate ROC curves
  roc_curves <- reactive({
    df <- data()
    dependent_var <- input$dependent_var
    independent_vars <- input$independent_vars
    
    roc_list <- list()
    
    for (var in independent_vars) {
      roc <- roc(df[[dependent_var]], df[[var]])
      roc_list[[var]] <- roc
    }
    
    roc_list
  })
  
  # Plot ROC curves
  output$roc_plot <- renderPlot({
    rocobj <- roc_curves()
    
    ggroc(rocobj, aes = c("linetype", "color"), linetype = 1, size = 0.9, alpha = 1) +
      labs(x = "False Positive Rate (1 - Specificity)", y = "True Positive Rate (Sensitivity)") +
      geom_abline(intercept = 1, slope = 1, color = 'grey', size = 0.5, linetype = "dashed") +
      theme(panel.background = element_rect(fill = "white", colour = "white", size = 0, linetype = "solid"),
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            legend.position = c(0.8, 0.15),
            legend.box = "vertical",
            legend.key = element_rect(colour = NA, fill = NA),
            legend.title = element_text(colour = "black", size = 16, face = "plain", family = "sans"),
            axis.line = element_line(colour = "black", size = 0.1, linetype = "solid"),
            legend.background = element_rect(fill = "white", size = 0.5, linetype = "solid", colour = "white"),
            legend.text = element_text(size = 13, family = "sans"),
            axis.text.x = element_text(colour = "black", size = 16, face = "plain", family = "sans"),
            axis.text.y = element_text(colour = "black", size = 16, face = "plain", family = "sans"),
            axis.title.x = element_text(colour = "black", size = 16, face = "plain", family = "sans"),
            axis.title.y = element_text(colour = "black", size = 16, face = "plain", family = "sans")) +
      scale_y_continuous(expand = c(0.01, 0.001), breaks = seq(from = 0, to = 1, by = 0.2)) +
      scale_x_reverse(expand = c(0.01, 0.001), breaks = seq(from = 0, to = 1, by = 0.2), limits = c(1, -0.01),
                      labels = c("1.0", "0.8", "0.6", "0.4", "0.2", "0.0")) +
      scale_color_manual(name = "", values = c("#3b58a7", "#90278e", "green", "red", "black", "blue"))
  })
  
  # Create AUC table
  output$auc_table <- renderTable({
    rocobj <- roc_curves()
    auc_data <- data.frame(
      Variable = names(rocobj),
      AUC = sapply(rocobj, function(x) as.numeric(auc(x))),
      `95% CI Lower` = sapply(rocobj, function(x) as.numeric(ci(x)[1])),
      `95% CI Upper` = sapply(rocobj, function(x) as.numeric(ci(x)[3]))
    )
    auc_data
  })
}

# Run the app
shinyApp(ui = ui, server = server)


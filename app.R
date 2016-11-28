## LOAD PACKAGES ####
library(shiny)
library(tidyverse)


## READ IN DATA AND ORGANIZE ####
# Data for analysis
data_proto = read.table("data/data_prototypes.txt", header=T, sep="\t") %>%
  mutate(vowel_ipa = if_else(vowel == "E", "ɛ",
                     if_else(vowel == "I", "ɪ",
                     if_else(vowel == "ae", "æ",
                     if_else(vowel == "U", "ʊ",
                     if_else(vowel == "^", "ʌ",
                     if_else(vowel == "a", "ɑ",
                     if_else(vowel == "c", "ɔ",
                     if_else(vowel == "er", "ɝ",as.character(vowel))))))))))


## MAKE UI INPUTS ####
ui <- fluidPage(
  
  # Add webpage title
  title = "Vowel Plots",
  
  # Add top descriptor information
  tags$h1("Different Vowel Plot Datasets by Gender"),
  tags$p("This are the vowel spaces of American English from two papers for both males and females.",
         tags$a(href="", "Hillenbrand et al. (1995)"), "reports values for what was labeled general American English,
         while", tags$a(href="", "Hagiwara (1997)"), "is for Southern Californian English."),
  
  # Set-up layout of main part of page
  sidebarLayout(
    
    # Add a sidebar panel
    sidebarPanel(
      
      # Add space for study input
      selectInput(inputId = "study", label = "Study",
                  choices = c(rev(levels(data_proto$study)))),
      
      # Add space for gender            
      selectInput(inputId = "gender", label = "Gender",
                  choices = c(levels(data_proto$gender)))
    ),
    
    # Add main panel
    mainPanel(
      
      # Add space for vowel plot 
      plotOutput("result_plot")
      
    )
  )
)


## MAKE SERVER OUTPUTS
server <- function(input, output) {
  
  # Select data
  data_plot = reactive({
    data_proto %>%
      # Set study
      filter(study == input$study) %>%
      # Set gender
      filter(gender == input$gender)
  })
  
  # Make vowel plot
  output$result_plot = renderPlot({
    data_plot() %>%
      ggplot(aes(x = f2, y = f1, label = vowel_ipa)) +
      geom_point(size = 4) +
      geom_text(nudge_x = 60, nudge_y = -20, size = 6) +
      geom_segment(aes(x = max(data_plot()$f2) + 150,
                       xend = max(data_plot()$f2) - ((max(data_plot()$f2) - min(data_plot()$f2)) / 2),
                       y = min(data_plot()$f1) - 50, yend = max(data_plot()$f1) + 50)) +
      geom_segment(aes(x = max(data_plot()$f2) - ((max(data_plot()$f2) - min(data_plot()$f2)) / 2),
                       xend = min(data_plot()$f2 - 100),
                       y = max(data_plot()$f1) + 50, yend = max(data_plot()$f1) + 50)) +
      geom_segment(aes(x = min(data_plot()$f2) - 100, xend = min(data_plot()$f2) - 100,
                       y = max(data_plot()$f1) + 50, yend = min(data_plot()$f1) - 50)) +
      geom_segment(aes(x = min(data_plot()$f2) - 100, xend = max(data_plot()$f2) + 150,
                       y = min(data_plot()$f1) - 50, yend = min(data_plot()$f1) - 50)) +
      scale_x_reverse() +
      scale_y_reverse() +
      theme_void() +
      theme(text = element_text(size = 16))
  })
  
}


## RENDER APP ####
shinyApp(ui = ui, server = server)
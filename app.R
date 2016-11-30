## LOAD PACKAGES ####
library(shiny)
source("scripts/vowel_feedback_packages.R")


## LOAD FUNCTIONS ####
source("scripts/vowel_feedback_functions.R")


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
  tags$p("These are the vowel spaces of American English from two papers for both females and males.",
         tags$a(href="http://scitation.aip.org/content/asa/journal/jasa/97/5/10.1121/1.411872", "Hillenbrand et al. (1995)"),
         "reports values for what was labeled General American English, while",
         tags$a(href="http://scitation.aip.org/content/asa/journal/jasa/102/1/10.1121/1.419712", "Hagiwara (1997)"),
         "reports values for Southern Californian English."),
  
  # Set-up layout of main part of page
  sidebarLayout(
    
    # Add a sidebar panel
    sidebarPanel(
      
      # Add space for study input
      selectInput(inputId = "study", label = "Study",
                  choices = c(rev(levels(data_proto$study)))),
      
      # Add space for gender            
      selectInput(inputId = "gender", label = "Gender",
                  choices = c(levels(data_proto$gender))),
      
      # Upload sound file
      fileInput("sound_file", "Choose WAV File")
      
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
  
  # Variables of file to read in
  vowel = "e"
  
  # Conditional for max formant
  max_formant = reactive({
    if_else(input$gender == "female", 5500, 4000)
  })
  
  # Set the parameters for the formant analysis
  formant_arguments = reactive({
                          list(0.001,        # Time step (s)
                           5,            # Max. number of formants
                           max_formant(),  # Maximum formant (Hz) <- change to be based on gender
                           0.025,        # Window length (s)
                           50)           # Pre-emphasis from (Hz)
  })
  
  # Read in sound file
  sound = reactive({
    readWave(input$sound_file)
  })
  
  # Make table for sound file
  data_formants = reactive({
    formants_extracter(data_wav, formant_arguments)
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
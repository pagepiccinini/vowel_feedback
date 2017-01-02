## LOAD PACKAGES ####
source("scripts/vowel_feedback_packages.R")


## LOAD FUNCTIONS ####
source("scripts/vowel_feedback_functions.R")


## SETTINGS FOR SPEECH ANALYSIS ####
# Variables of file to read in
vowel = "e"
gender = "female"

# Conditional for max formant
max_formant = if_else(gender == "female", 5500, 4000)

# Set the parameters for the formant analysis
formant_arguments = list(0.001,        # Time step (s)
                         5,            # Max. number of formants
                         max_formant,  # Maximum formant (Hz) <- change to be based on gender
                         0.025,        # Window length (s)
                         50)           # Pre-emphasis from (Hz)


## RUN SCRIPTS ####
source("scripts/vowel_feedback_formants.R")
source("scripts/vowel_feedback_figures.R")

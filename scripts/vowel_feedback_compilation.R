## LOAD PACKAGES ####
source("scripts/vowel_feedback_packages.R")


## SETTINGS FOR SPEECH ANALYSIS ####
# Files to read in
vowel = "i"
gender = "male"

# Set the parameters for the formant analysis
formant_arguments = list( 0.001, # Time step (s)
                         5,     # Max. number of formants
                         5000,  # Maximum formant (Hz) <- change to be based on gender
                         0.025, # Window length (s)
                         50    )# Pre-emphasis from (Hz)


## RUN SCRIPTS ####
## ACOUSTIC ANALYSIS ####
# Get formant information from a sound file
formants_extracter = function(vowelfile, formant_arguments) {

  # Set location paths for wav files and formant files, Note: spaces not allowed in path
  wav_loc = paste(getwd(), "/", vowelfile, sep = "")
  formant_loc <<- sub(wav_loc, pattern = ".wav", replacement = ".Formant")
  table_loc <<- sub(wav_loc, pattern = ".wav", replacement = ".txt")
  
  # Set arguments for tables
  tab_args = list( TRUE, # Include frame number
                   TRUE, # Include time
                   3,    # Time decimals
                   TRUE, # Include intensity
                   3,    # Intensity decimals
                   TRUE, # Include number of formants
                   3,    # Frequency decimals
                   TRUE )# Include bandwidths
  
  # Perform Praat call to get formants based on input wav
  praat("To Formant (burg)...",
        arguments = formant_arguments,
        input = wav_loc,
        output = formant_loc)
  
  # Perform Praat call to save formant information to a table
  praat("Down to Table...",
        arguments = tab_args,
        input = formant_loc,
        output = table_loc,
        filetype = "tab-separated")
  
  # Read in table and clean up data
  read.table(file = table_loc, header=TRUE, sep="\t", na.strings="--undefined--" ) %>%
    # Only keep time, F1, and F2
    select(time.s., F1.Hz., F2.Hz.) %>%
    # Rename time, f1, and f2 columns
    rename(time = time.s.) %>%
    rename(f1 = F1.Hz.) %>%
    rename(f2 = F2.Hz.) %>%
    # Save vowel and gender information for intial settings
    mutate(vowel = vowel) %>%
    mutate(gender = gender)
  
}


## FIGURE MAKING ####
# Make base plots
base_plot = function(data, specific_study, specific_gender) {
  data %>%
    # Set study
    filter(study == specific_study) %>%
    # Set gender
    filter(gender == specific_gender) %>%
    # Make plot with f2 as x, f1 and y, and IPA vowel coding as labels
    ggplot(aes(x = f2, y = f1, label = vowel_ipa)) +
    # Add vowel points
    geom_point(size = 4) +
    # Move over labels
    geom_text(nudge_x = 60, nudge_y = -20, size = 6) +
    # Make lines for trapizoid
    geom_segment(aes(x = max(f2) + 150, xend = max(f2) - ((max(f2) - min(f2)) / 2),
                     y = min(f1) - 50, yend = max(f1) + 50)) +
    geom_segment(aes(x = max(f2) - ((max(f2) - min(f2)) / 2), xend = min(f2 - 100),
                     y = max(f1) + 50, yend = max(f1) + 50)) +
    geom_segment(aes(x = min(f2) - 100, xend = min(f2) - 100,
                     y = max(f1) + 50, yend = min(f1) - 50)) +
    geom_segment(aes(x = min(f2) - 100, xend = max(f2) + 150,
                     y = min(f1) - 50, yend = min(f1) - 50)) +
    # Reverse x and y axes so more like a vowel chart
    scale_x_reverse() +
    scale_y_reverse() +
    # Remove all other axes
    theme_void() +
    # Increase font size
    theme(text = element_text(size = 16))
  
}
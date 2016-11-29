# Get formant information from a sound file
formants_extracter = function(vowelfile, formant_arguments) {

    # Set location paths for wav files and formant files, Note: spaces not allowed in path
  wav_loc = paste(getwd(), "/", vowelfile, sep = "")
  formant_loc = sub(wav_loc, pattern = ".wav", replacement = ".Formant")
  table_loc = sub(wav_loc, pattern = ".wav", replacement = ".txt")
  
  tab_args = list( TRUE, # Include frame number
                   TRUE, # Include time
                   3,    # Time decimals
                   TRUE, # Include intensity
                   3,    # Intensity decimals
                   TRUE, # Include number of formants
                   3,    # Frequency decimals
                   TRUE )# Include bandwidths
  
  praat("To Formant (burg)...",
        arguments = formant_arguments,
        input = wav_loc,
        output = formant_loc)
  
  praat("Down to Table...",
        arguments = tab_args,
        input = formant_loc,
        output = table_loc,
        filetype = "tab-separated")
  
  read.table(file = table_loc, header=TRUE, sep="\t", na.strings="--undefined--" ) %>%
    gather(formant, value, F1.Hz.:B5.Hz.) %>%
    filter(formant == "F1.Hz." | formant == "F2.Hz." | formant == "F3.Hz.") %>%
    mutate(formant = factor(formant, levels = c("F1.Hz.", "F2.Hz.", "F3.Hz."),
                            labels = c("F1", "F2", "F3"))) %>%
    mutate(time_s = time.s. + vowelfile$time_start[line])
}
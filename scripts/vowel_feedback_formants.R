## READ IN DATA ####
# Set player
setWavPlayer("afplay")

# Set if else to either read in existing file or record a file and save it
if(file.exists(paste("data/recordings/", vowel, "_", gender, ".wav", sep=""))) {
  
  # If exists, read in wav file
  data_wav = paste("data/recordings/", vowel, "_", gender, ".wav", sep="")
  
} else {
  
  # If doesn't exist,
    # (1) make time and variable for new wav file
  rec_dur = 5
  rec_sound = rep(NA_real_, 16000 * rec_dur)
  
    # (2) record sound, with delay for next line of code, NOTE: currently in stereo
  record(rec_sound, 16000, 2)
  Sys.sleep(6)
  
    # (3) save wav file and read in
  savewav(rec_sound, filename = paste("data/recordings/", vowel, "_", gender, ".wav", sep=""))
  #data_wav = paste("data/recordings/", vowel, "_", gender, ".wav", sep="")
}


## GET FORMANTS ####
# Get data and save
data_formants = formants_extracter(data_wav, formant_arguments)
write.table(data_formants, paste("data/", vowel, "_", gender, ".txt", sep=""))

# Remove unneded files
unlink(formant_loc)
unlink(table_loc)


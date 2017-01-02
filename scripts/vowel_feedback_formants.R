## READ IN DATA ####
# Set player
setWavPlayer("afplay")

# Read in wav file
data_wav = paste("data/recordings/", vowel, "_", gender, ".wav", sep="")


## GET FORMANTS ####
# Get data and save
data_formants = formants_extracter(data_wav, formant_arguments)
write.table(data_formants, paste("data/", vowel, "_", gender, ".txt", sep=""))

# Remove unneded files
unlink(formant_loc)
unlink(table_loc)


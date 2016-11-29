## READ IN DATA ####
# Set player
setWavPlayer("afplay")

# Read in wav file
data_wav = paste("data/recordings/", vowel, "_", gender, ".wav", sep="")
sound = readWave(data_wav)


## GET FORMANTS ####
data_formants = formants_extracter(data_wav, formant_arguments)

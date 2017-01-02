test_dur = 2
test_sound = rep(NA_real_, 16000 * rec_dur)

# (2) record sound, with delay for next line of code
record(test_sound, 16000, 2)
play(test_sound)


x <- rep(NA_real_, 88200)
# start recording into x
record(x, 44100, 2)
play(x)

y <- rep(NA_real_, 88200)
# start recording into x
record(y, 44100, 1)
play(y)

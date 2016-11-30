## READ IN DATA ####
data_proto = read.table("data/data_prototypes.txt", header=T, sep="\t") %>%
  mutate(vowel_ipa = if_else(vowel == "E", "ɛ",
                     if_else(vowel == "I", "ɪ",
                     if_else(vowel == "ae", "æ",
                     if_else(vowel == "U", "ʊ",
                     if_else(vowel == "^", "ʌ",
                     if_else(vowel == "a", "ɑ",
                     if_else(vowel == "c", "ɔ",
                     if_else(vowel == "er", "ɝ",as.character(vowel))))))))))

data_formants_clean = data_formants %>%
  filter(time > 0.1) %>%
  filter(time < 0.4) %>%
  mutate(vowel_ipa = vowel)


## MAKE FIGURE ####
data_proto %>%
  # Set study
  filter(study == "Hagiwara (1997)") %>%
  # Set gender
  filter(gender == "male") %>%
  # Make plot
  ggplot(aes(x = f2, y = f1, label = vowel_ipa)) +
  geom_point(size = 4) +
  geom_text(nudge_x = 60, nudge_y = -20, size = 6) +
  geom_segment(aes(x = max(f2) + 150, xend = max(f2) - ((max(f2) - min(f2)) / 2),
                   y = min(f1) - 50, yend = max(f1) + 50)) +
  geom_segment(aes(x = max(f2) - ((max(f2) - min(f2)) / 2), xend = min(f2 - 100),
                   y = max(f1) + 50, yend = max(f1) + 50)) +
  geom_segment(aes(x = min(f2) - 100, xend = min(f2) - 100,
                   y = max(f1) + 50, yend = min(f1) - 50)) +
  geom_segment(aes(x = min(f2) - 100, xend = max(f2) + 150,
                   y = min(f1) - 50, yend = min(f1) - 50)) +
  scale_x_reverse() +
  scale_y_reverse() +
  theme_void() +
  theme(text = element_text(size = 16)) +
  # Add speaker vowel
  geom_point(data = data_formants_clean, aes(x = f2, y = f1), color = "red") +
  geom_path(data = data_formants_clean, aes(x = f2, y = f1), arrow = arrow(), color = "red")
  
  
  
  
  
  
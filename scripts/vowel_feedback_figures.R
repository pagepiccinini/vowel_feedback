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
  #filter(time > 0.1) %>%
  #filter(time < 0.4) %>%
  mutate(vowel_ipa = vowel) %>%
  mutate(bin = floor(time / 0.5)) %>%
  group_by(vowel_ipa, bin) %>%
  summarise(f1_median  = median(f1, na.rm = T),
            f2_median = median(f2, na.rm = T)) %>%
  ungroup()


## MAKE BASE FIGURE ####
# Make base plot for Hagiwara (1997), female speaker
base_hagi_f.plot = data_proto %>%
  # Set study
  filter(study == "Hagiwara (1997)") %>%
  # Set gender
  filter(gender == "female") %>%
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
  theme(text = element_text(size = 16))

# Make base plot for Hagiwara (1997), male speaker
base_hagi_m.plot = data_proto %>%
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
  theme(text = element_text(size = 16))

# Make base plot for Hillenbrand et al. (1995), female speaker
base_hill_f.plot = data_proto %>%
  # Set study
  filter(study == "Hillenbrand et al. (1995)") %>%
  # Set gender
  filter(gender == "female") %>%
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
  theme(text = element_text(size = 16))

# Make base plot for Hillenbrand et al. (1995), male speaker
base_hill_m.plot = data_proto %>%
  # Set study
  filter(study == "Hillenbrand et al. (1995)") %>%
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
  theme(text = element_text(size = 16))


## ADD SPEAKER SPECIFIC POINTS ####
#base_hagi_m.plot +
base_hill_m.plot +
  geom_point(data = data_formants_clean, aes(x = f2_median, y = f1_median),
             color = "red", size = 3) +
  geom_path(data = data_formants_clean, aes(x = f2_median, y = f1_median),
            arrow = arrow(), color = "red", lwd = 1)
  
  
  
  
  
  
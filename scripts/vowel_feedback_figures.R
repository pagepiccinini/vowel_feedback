## READ IN DATA ####
# Prototypical vowels for plot
data_proto = read.table("data/data_prototypes.txt", header=T, sep="\t") %>%
  # Reset IPA coding
  mutate(vowel_ipa = if_else(vowel == "E", "ɛ",
                     if_else(vowel == "I", "ɪ",
                     if_else(vowel == "ae", "æ",
                     if_else(vowel == "U", "ʊ",
                     if_else(vowel == "^", "ʌ",
                     if_else(vowel == "a", "ɑ",
                     if_else(vowel == "c", "ɔ",
                     if_else(vowel == "er", "ɝ",as.character(vowel))))))))))

# Recording specific formant information
data_formants_clean = data_formants %>%
  # Add IPA column
  mutate(vowel_ipa = vowel) %>%
  # Bin data by 0.5s intervals
  mutate(bin = floor(time / 0.5)) %>%
  # Get median f1 and f2 by bins
  group_by(vowel_ipa, bin) %>%
  summarise(f1_median  = median(f1, na.rm = T),
            f2_median = median(f2, na.rm = T)) %>%
  ungroup()


## MAKE BASE FIGURES ####
# Make base plot for Hagiwara (1997), female speaker
base_hagi_f.plot = base_plot(data_proto, "Hagiwara (1997)", "female")

# Make base plot for Hagiwara (1997), male speaker
base_hagi_m.plot = base_plot(data_proto, "Hagiwara (1997)", "male")

# Make base plot for Hillenbrand et al. (1995), female speaker
base_hill_f.plot = base_plot(data_proto, "Hillenbrand et al. (1995)", "female")

# Make base plot for Hillenbrand et al. (1995), male speaker
base_hill_m.plot = base_plot(data_proto, "Hillenbrand et al. (1995)", "male")


## ADD SPEAKER SPECIFIC POINTS TO A BASE ####
# Select base plot
#base_hagi_m.plot +
vowel_plot = base_hill_m.plot +
  # Add bined data points of speaker
  geom_point(data = data_formants_clean, aes(x = f2_median, y = f1_median),
             color = "red", size = 3) +
  # Add a path with an arrow over time of productions
  geom_path(data = data_formants_clean, aes(x = f2_median, y = f1_median),
            arrow = arrow(), color = "red", lwd = 1)

vowel_plot
  
# Save plot
cairo_pdf("figures/vowel_plot.pdf", width = 6, height = 4.5)
vowel_plot
dev.off()
  
  
  
  
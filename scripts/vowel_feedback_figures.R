## READ IN DATA ####
data_proto = read.table("data/data_prototypes.txt", header=T, sep="\t")


## MAKE FIGURE ####
data_proto %>%
  # Set study
  filter(study == "Hagiwara (1997)") %>%
  # Set gender
  filter(gender == "female") %>%
  ggplot(aes(x = f2, y = f1, label = vowel)) +
  geom_point(size = 4) +
  geom_text(nudge_x = 60, nudge_y = -20, size = 6) +
  geom_segment(aes(x = 3050, xend = 2000, y = 300, yend = 1050)) +
  geom_segment(aes(x = 2000, xend = 1000, y = 1050, yend = 1050)) +
  geom_segment(aes(x = 1000, xend = 1000, y = 1050, yend = 300)) +
  geom_segment(aes(x = 1000, xend = 3050, y = 300, yend = 300)) +
  xlim(3100, 1000) +
  ylim(1100, 300) +
  theme_void() +
  theme(text = element_text(size = 16))
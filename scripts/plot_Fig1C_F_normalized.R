!/usr/bin/env Rscript
# Recreation of Figure 1C–F
suppressPackageStartupMessages({
  library(data.table)
  library(ggplot2)
  library(gridExtra)
  library(zoo)
})

# read last column (distance)
read_dist <- function(file) {
  dt <- fread(file, header = FALSE)
  d  <- as.numeric(dt[[ncol(dt)]])
  d  <- d[!is.na(d) & abs(d) <= 500]
  d
}

# read distance data
sj5   <- read_dist("dist_sj5.bed")
sj3   <- read_dist("dist_sj3.bed")
start <- read_dist("dist_start.bed")
stop  <- read_dist("dist_stop.bed")

# make profile: bin by 10 nt, normalize
make_profile <- function(d, bin = 10, window = 500) {
  bins <- seq(-window, window, bin)
  mids <- bins[-1] - bin/2
  freq <- hist(d, breaks = bins, plot = FALSE)$counts
  freq <- freq / sum(freq) * 100  # percent of total peaks
  df <- data.frame(pos = mids, freq = rollmean(freq, 3, fill = NA))
  df
}

sj5_prof   <- make_profile(sj5)
sj3_prof   <- make_profile(sj3)
start_prof <- make_profile(start)
stop_prof  <- make_profile(stop)

plot_line <- function(df, title, ymax) {
  ggplot(df, aes(x = pos, y = freq)) +
    geom_line(linewidth = 1.1, color = "firebrick2") +
    geom_vline(xintercept = 0, linetype = "dashed") +
    scale_x_continuous(limits = c(-500, 500), breaks = seq(-500, 500, 250)) +
    scale_y_continuous(limits = c(0, ymax)) +
    labs(x = "Nucleotide position", y = "Relative frequency (%)", title = title) +
    theme_minimal(base_size = 14) +
    theme(plot.title = element_text(hjust = 0.5, face = "bold"))
}

p1 <- plot_line(sj5_prof,   "5' splice site", 3) +
  annotate("text", x=-350, y=2.8, label="Exon", size=5) +
  annotate("text", x=350,  y=2.8, label="Intron", size=5)

p2 <- plot_line(sj3_prof,   "3' splice site", 3) +
  annotate("text", x=-350, y=2.8, label="Intron", size=5) +
  annotate("text", x=350,  y=2.8, label="Exon",  size=5)

p3 <- plot_line(start_prof, "Start codon", 2.5) +
  annotate("text", x=-350, y=2.3, label="5'UTR", size=5)

p4 <- plot_line(stop_prof,  "Stop codon", 2.5) +
  annotate("text", x=350,  y=2.3, label="3'UTR", size=5)

pdf("Fig1C_F_profiles_normalized.pdf", width = 12, height = 9)
grid.arrange(p1, p2, p3, p4, ncol = 2)
dev.off()

cat("Fig1C_F_profiles_normalized.pdf\n")

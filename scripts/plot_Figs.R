#!/usr/bin/env Rscript
# plot_Fig1C_F.R — plot distance distributions (Fig 1C–F)
library(data.table)
library(ggplot2)
library(gridExtra)
library(zoo)

# helper to read the last column (distance)
read_dist <- function(file) {
  dt <- fread(file, header = FALSE)
  distances <- as.numeric(dt[[ncol(dt)]])
  distances <- distances[!is.na(distances)]
  return(distances)
}

# load distance files
sj5   <- read_dist("dist_sj5.bed")
sj3   <- read_dist("dist_sj3.bed")
start <- read_dist("dist_start.bed")
stop  <- read_dist("dist_stop.bed")

# function to make a frequency table per nt in ±500 window
make_profile <- function(d, window = 500) {
  d <- d[abs(d) <= window]
  bins <- seq(-window, window, 1)
  freq <- table(factor(d, levels = bins))
  df <- data.frame(pos = bins, freq = as.numeric(freq))
  df$freq <- rollmean(df$freq, 10, fill = NA)  # smooth (10 nt)
  return(df)
}

sj5_prof   <- make_profile(sj5)
sj3_prof   <- make_profile(sj3)
start_prof <- make_profile(start)
stop_prof  <- make_profile(stop)

# simple line plot
#plot_line <- function(df, title) {
#  ggplot(df, aes(x = pos, y = freq)) +
#    geom_line(linewidth = 1) +
#    geom_vline(xintercept = 0, linetype = "dashed", color = "red") +
#    xlim(-500, 500) +
#    labs(x = "Distance (nt)", y = "Fraction of peaks", title = title) +
#    theme_minimal(base_size = 14)
#}

#p1 <- plot_line(sj5_prof,   "5' splice site (±500 nt)")
#p2 <- plot_line(sj3_prof,   "3' splice site (±500 nt)")
#p3 <- plot_line(start_prof, "Start codon (±500 nt)")
#p4 <- plot_line(stop_prof,  "Stop codon (±500 nt)")

# export 4-panel PDF
#pdf("Fig1_C_to_F_profiles.pdf", width = 12, height = 9)
#grid.arrange(p1, p2, p3, p4, ncol = 2)
#dev.off()

#cat("Wrote Fig1_C_to_F_profiles.pdf\n")

# Plot function
# ------------------------------------------------------------
plot_line <- function(df, title, ymax) {
  ggplot(df, aes(x = pos, y = freq)) +
    geom_line(linewidth = 1.1, color = "firebrick2") +
    geom_vline(xintercept = 0, linetype = "dashed") +
    xlim(-500, 500) + ylim(0, ymax) +
    labs(
      x = "Nucleotide position",
      y = "Frequency of m6A peak summits",
      title = title
    ) +
    theme_minimal(base_size = 14) +
    theme(
      plot.title = element_text(hjust = 0.5, face = "bold"),
      axis.title.x = element_text(margin = margin(t = 10)),
      axis.title.y = element_text(margin = margin(r = 10))
    )
}

# ------------------------------------------------------------
# Make the four panels
# ------------------------------------------------------------
p1 <- plot_line(sj5_prof,   "5' splice site", 90) +
  annotate("text", x = -350, y = 80, label = "Exon",  size = 5) +
  annotate("text", x =  350, y = 80, label = "Intron", size = 5)

p2 <- plot_line(sj3_prof,   "3' splice site", 75) +
  annotate("text", x = -350, y = 70, label = "Intron", size = 5) +
  annotate("text", x =  350, y = 70, label = "Exon",  size = 5)

p3 <- plot_line(start_prof, "Start codon", 60) +
  annotate("text", x = -350, y = 55, label = "5'UTR", size = 5)

p4 <- plot_line(stop_prof,  "Stop codon", 40) +
  annotate("text", x =  350, y = 35, label = "3'UTR", size = 5)

# ------------------------------------------------------------
# Export combined figure
# ------------------------------------------------------------
pdf("Fig1_C_to_F_profiles.pdf", width = 12, height = 9)
grid.arrange(p1, p2, p3, p4, ncol = 2)
dev.off()

cat("\n Wrote Fig1_C_to_F_profiles.pdf\n")

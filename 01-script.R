# This script uses functions from these packages (so load them)
library(tidyverse)
library(here)

samples <- read_csv(here("data", "dublin.csv"))
sample_mean <- mean(samples$amount)

# The data
samples$amount

# The estimate
sample_mean

# What Gosset really wanted
bootstrap_means <- replicate(1000, mean(rnorm(50, mean = 750, sd = 3)))
delta <- abs(750 - sample_mean)
bootstrap_deltas <- abs(750 - bootstrap_means)
pvalue <- mean(bootstrap_deltas >= delta)

# Some results
ggplot() +
  geom_histogram(aes(x = bootstrap_means), bins = 30) +
  geom_rect(aes(xmin = -Inf, xmax = 750 - delta, 
                ymin = -Inf, ymax = Inf), 
            fill = "#4197D9", alpha = 0.2) +
  geom_rect(aes(xmin = 750 + delta, xmax = Inf, 
                ymin = -Inf, ymax = Inf),
            fill = "#4197D9", alpha = 0.2) +
  geom_vline(aes(xintercept = sample_mean), 
             color = "#4197D9", size = 3)

# We'll use these later
paste0(pvalue * 100, "%")
pvalue

# Let's generate some text programatically
ifelse(pvalue <= 0.05, 
       "seem unlikely to have happened if the machine is functioning correctly", 
       "are in accordance with our belief")
ifelse(pvalue <= 0.05, "", "do **not**")
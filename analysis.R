# analysis.R
#
# Replication script for "A Generalized Approach to Combining Similarity and
# Eigenvector Analysis of Networks" (Lizardo 2026, Connections).
#
# Reproduces all tables and plots in the paper:
#   - Plots/medici.png : Figure 1, Florentine Families network
#   - Tables/table1.tex: Table 1, eigenvector-based scores under four weightings
#   - Plots/bump.png   : Figure 2, parameter sensitivity bump chart
#   - parameter.csv    : raw sensitivity-analysis scores
#
# Data: the Florentine Families marriage and business networks from the
# `networkdata` R package (Schoch 2022), as analyzed by Breiger & Pattison (1986).

library(networkdata)
library(igraph)
library(here)
library(dplyr)
library(tidyr)
library(ggplot2)
library(ggbump)
library(ggrepel)
library(kableExtra)

source(here("Functions", "prestige_sim.R"))

## ---- Network data -----------------------------------------------------------
g <- flo_marriage + flo_business #merging business and marriage network
g <- subgraph(g, which(degree(g) > 1)) #getting rid of isolate and pendant nodes

dir.create(here("Plots"), showWarnings = FALSE)
dir.create(here("Tables"), showWarnings = FALSE)

## ---- Figure 1: network plot --------------------------------------------------
set.seed(345)
png(here("Plots", "medici.png"), width = 800, height = 600)
plot(g,
    vertex.size = 10, vertex.frame.color = "lightgray",
    vertex.label.dist = 2, layout = layout_nicely,
    vertex.label.cex = 1.2, edge.color = "gray",
    edge.width = 2)
dev.off()

## ---- Table 1: eigenvector scores under four weightings -----------------------
bon <- prestige_sim(g, a = 0, b = 0)      #standard Bonacich
ace <- prestige_sim(g, a = 0, b = 1)      #Alvarez-Socorro et al. (2015)
ol1 <- prestige_sim(g, a = 1, b = 0)      #similarity (closure)
ol2 <- prestige_sim(g, a = 0.15, b = 0.85) #hybrid
eig.dat <- data.frame(sort_vec(bon), sort_vec(ace), sort_vec(ol1), sort_vec(ol2))

save_kable(
    kbl(eig.dat,
        format = "latex", booktabs = TRUE, linesep = "",
        row.names = FALSE, align = rep(c("l", "c"), 4),
        digits = 3, col.names = c("Node", "Eig.", "Node", "Eig./Dis", "Node", "Eig./Sim", "Node", "Eig./Hybrid"),
        caption = "Eigenvector-Based Scores for the Medici Network.", label = "main") |>
        kable_styling(latex_options = c("scale_down")),
    file = here("Tables", "table1.tex")
)

## ---- Figure 2: parameter sensitivity bump chart ------------------------------
beta.range <- seq(0, 1, by = 0.05) #sequence of beta values
c.dat <- data.frame(prestige_sim_vec(list(g), a = 1 - beta.range, b = beta.range)) |>
    mutate(family = V(g)$name)
names(c.dat)[1:ncol(c.dat) - 1] <- paste("b", sprintf("%.2f", seq(0, 1, by = 0.05)), sep = "_")
write.csv(c.dat, here("parameter.csv"), row.names = FALSE)

c.long <- c.dat |>
    pivot_longer(
        cols = !family,
        names_to = "Beta",
        values_to = "value"
    ) |>
    mutate(Beta = factor(Beta, ordered = TRUE, levels = colnames(c.dat[-ncol(c.dat)])))

p <- ggplot(
    data = c.long,
    mapping = aes(x = Beta, y = value, color = family, group = family)
)
p <- p + geom_vline(
    aes(xintercept = which(sprintf("%.2f", seq(0, 1, by = 0.05)) == "0.85")),
    linetype = 2, color = "red"
)
p <- p + geom_bump(linewidth = 0.8, smooth = 2)
p <- p + geom_point(size = 3)
p <- p + geom_text_repel(
    data = filter(c.long,
        Beta == colnames(c.dat)[1]),
    aes(x = Beta, label = family),
    size = 6, nudge_x = -3.5
)
p <- p + geom_text_repel(
    data = filter(c.long,
        Beta == colnames(c.dat)[ncol(c.dat) - 1]),
    aes(x = Beta, label = family),
    size = 6, nudge_x = 3.5
)
p <- p + theme_minimal()
p <- p + theme(
    legend.position = "none",
    text = element_text(size = 24)
)
p <- p + scale_x_discrete(
    breaks = unique(c.long$Beta)[seq(1, 21, by = 2)],
    labels = sprintf("%.2f", seq(0, 1, by = 0.05))[seq(1, 21, by = 2)]
)
p <- p + xlab("Beta") + ylab("Eigenvector Score")
print(p)
ggsave(here("Plots", "bump.png"), height = 10, width = 15)

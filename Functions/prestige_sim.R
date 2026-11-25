# prestige_sim: generalized similarity/dissimilarity-weighted eigenvector scoring
#
# Implements the generalized approach in Lizardo (2026), Algorithm 2:
#   - a = 0, b = 0 : standard Bonacich eigenvector centrality
#   - a = 0, b = 1 : Alvarez-Socorro et al. (2015) dissimilarity-weighted scores
#   - a = 1, b = 0 : similarity (closure)-weighted scores
#   - a > 0 and b > 0 : hybrid brokerage/closure scores
prestige_sim <- function(x, a = 0, b = 0) {
    z <- as.matrix(as_adjacency_matrix(x))
    p <- z %*% z
    q <- z %*% (1 - z)
    j <- p / (p + q + t(q))
    d <- 1 - j
    w <- z * (j^a * d^b)
    s <- abs(eigen(w)$vectors[, 1])
    s <- (s - min(s)) / (max(s) - min(s)) #normalizing
    names(s) <- V(x)$name
    return(round(s, 4))
}

prestige_sim_vec <- Vectorize(prestige_sim) #vectorized over network and weights

# sort_vec: data frame of nodes and scores ordered by decreasing score
sort_vec <- function(x) {
    x <- data.frame(Node = names(x), Score = as.numeric(x))
    x <- x[order(x$Score, decreasing = TRUE), ]
    return(x)
}

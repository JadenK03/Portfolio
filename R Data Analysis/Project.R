# Project
# MLB Player Stats

#pt 1
# linear regression to analyze the relationship between a player's batting average (AVG) and other features like home runs (HR), runs batted in (RBI), and strikeouts (SO)

# Load tidyverse
library(tidyverse)

# Read the dataset
mlb_data <- read_csv("mlb-player-stats-Batters.csv")

# Inspect the dataset
glimpse(mlb_data)

# Select relevant columns for regression analysis
# focus on numeric variables that may affect AVG (batting average)
mlb_data <- mlb_data %>%
  select(AVG, HR, RBI, SO)

# Check for missing values and handle them (there are none but still good to check)
mlb_data <- mlb_data %>%
  drop_na()

# Build the linear regression model
batting_model <- lm(AVG ~ HR + RBI + SO, data = mlb_data)

# Summarize the model to evaluate coefficients and significance levels
summary(batting_model)

# Plot residuals to evaluate model fit
par(mfrow = c(2, 2)) # Set up a 2x2 plot layout
plot(batting_model, 
     pch = 19,        # Solid points
     col = rgb(0.2, 0.4, 0.6, 0.5), # transparent points
     cex = 0.7)       # Reduce point size

# Predict AVG for new players (might not be very accurate in a real world case but this is an example of how you could use such data, and could still be useful in predicting a new player based on other batters)
# Example new data
new_players <- data.frame(HR = c(30, 20), RBI = c(100, 70), SO = c(120, 90))
predicted_AVG <- predict(batting_model, newdata = new_players)
print(predicted_AVG)

#ANOVA
# Fit the regression model again
batting_model <- lm(AVG ~ HR + RBI + SO, data = mlb_data)

# Perform ANOVA on the model
anova_result <- anova(batting_model)

# View the ANOVA table
print(anova_result)


# pt 2
# clustering

# Select numerical columns for clustering (e.g., HR, RBI, SO)
clustering_data <- mlb_data[, c("HR", "RBI", "SO")]

# Scale the data to standardize (important for clustering)
clustering_data_scaled <- scale(clustering_data)

# Compute the distance matrix
dist_matrix <- dist(clustering_data_scaled)

# Perform hierarchical clustering using Ward's method
hc <- hclust(dist_matrix, method = "ward.D2")

# Cut into a specified number of clusters (e.g., 3 clusters)
clusters_hc <- cutree(hc, k = 3)

# Add cluster labels to the original data
mlb_data$Cluster_HC <- clusters_hc

# Summary of cluster sizes
table(clusters_hc)

# Calculate the mean for each variable by cluster
aggregate(clustering_data, by = list(Cluster = clusters_hc), FUN = mean)

# Set the number of clusters (e.g., 3)
set.seed(123) # For reproducibility
kmeans_result <- kmeans(clustering_data_scaled, centers = 3, nstart = 25)

# Add cluster labels to the original data
mlb_data$Cluster_KMeans <- kmeans_result$cluster

# Print cluster sizes
table(kmeans_result$cluster)

# Calculate the mean for each variable by cluster
aggregate(clustering_data, by = list(Cluster = kmeans_result$cluster), FUN = mean)

# Visualize the clusters using a scatterplot (e.g., HR vs. RBI)
plot(clustering_data_scaled[, 1:2], col = kmeans_result$cluster,
     main = "K-Means Clustering", xlab = "HR (scaled)", ylab = "RBI (scaled)", pch = 19)

# Add cluster centers to the plot
points(kmeans_result$centers[, 1:2], col = 1:3, pch = 4, cex = 2, lwd = 2)

# Compare hierarchical and k-means clusters
table(Hierarchical = mlb_data$Cluster_HC, KMeans = mlb_data$Cluster_KMeans)

# Examine cluster assignments
head(mlb_data[, c("HR", "RBI", "SO", "Cluster_HC", "Cluster_KMeans")])

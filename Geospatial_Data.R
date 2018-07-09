install.packages('ggmap')

##### Exercise 1

library(ggmap)
corvallis <- c(lon = -123.2620, lat = 44.5646)

# Get map at zoom level 5: map_5
map_5 <- get_map(corvallis, zoom = 5, scale = 1)

# Plot map at zoom level 5
ggmap(map_5)

# Get map at zoom level 13: corvallis_map
corvallis_map <- get_map(corvallis, zoom = 13, scale = 1)

# Plot map at zoom level 13

ggmap(corvallis_map)



###### Exercise 2

# Look at head() of sales
head(sales)


# Swap out call to ggplot() with call to ggmap()
ggmap(corvallis_map) + geom_point(aes(lon, lat), data = sales)



###### Exercise 3





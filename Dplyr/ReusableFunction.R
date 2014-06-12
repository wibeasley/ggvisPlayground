rm(list=ls(all=TRUE)) #Clear the memory of variables from previous run. This is not called by knitr, because it's above the first chunk.
# http://stackoverflow.com/questions/24133356/how-to-replicate-ddply-behavior-with-dplyr
# keeping empty rows requries merging: http://stackoverflow.com/questions/22523131/dplyr-summarise-equivalent-of-drop-false-to-keep-groups-with-zero-length-in?rq=1
#####################################
# devtools::install_github(c("hadley/dplyr"))
library(dplyr)

ds <- mtcars
ff <- function( d ) { 
  data.frame(
    n = nrow(d),
    WeightMean = mean(d$wt), 
    HPMean =mean(d$hp)
)}

ds %>%
  group_by(cyl) %>%
  summarize(
    WeightMean = mean(wt), 
    HPMean =mean(hp)
  )

ds %>%
  group_by(cyl) %>%
  do(ff(.))

ds %>%
  group_by(cyl, vs, carb) %>%
  do(ff(.))
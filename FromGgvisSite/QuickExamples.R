rm(list=ls(all=TRUE)) #Clear the memory of variables from previous run. This is not called by knitr, because it's above the first chunk.
#####################################
# http://ggvis.rstudio.com/quick-examples.html
# devtools::install_github(c("hadley/testthat", "rstudio/shiny", "rstudio/ggvis"))
library(ggvis)

###
### Scatterplots
###
ggvis(mtcars, props(x = ~wt, y = ~mpg)) + mark_point()

head(mtcars)
d <- mtcars
d$cyl <- factor(d$cyl)
ggvis(d, by_group(cyl), props(x = ~wt, y = ~mpg)) + 
  layer_point(props(stroke = ~cyl, shape:="diamond", fill:=NA)) +
  layer_smooth(props(stroke := 1), method="loess", se=T, span=1) +
  layer_smooth(props(stroke = ~cyl), method="loess", se=T, span=1)
  

# ggvis(mtcars, props(x = ~wt, y = ~mpg, y2 = 0)) + mark_point()

ggvis(mtcars, props(x = ~wt, y = ~mpg)) +
  mark_point(props(size := 25, shape := 3, stroke := "red", fill := NA))

###
### Bar graphs
###
ggvis(pressure, props(x = ~temperature, y = ~pressure, y2 = 0)) +
  mark_rect(props(width := 10))

ggvis(pressure, props(x = ~temperature, y = ~pressure)) +
  mark_rect(props(width := 10))



ggvis(mtcars, props(x = ~wt, y = ~mpg)) +
  mark_rect(props(width := 10))

ggvis(pressure,
      props(x = ~temperature - 0, x2 = ~temperature + 10, y = ~pressure, y2 = 0)) +
  mark_rect() +
  guide_axis("x", title = "temperature")


###
### Line graphs
###
ggvis(pressure, props(x = ~temperature, y = ~pressure)) + 
  layer_line() +
  mark_point()

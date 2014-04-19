rm(list=ls(all=TRUE)) #Clear the memory of variables from previous run. This is not called by knitr, because it's above the first chunk.
#####################################
# http://ggvis.rstudio.com/ggvis-basics.html
# devtools::install_github(c("hadley/testthat", "rstudio/shiny", "rstudio/ggvis"))
library(ggvis)

###
### qvis
###
qvis(mtcars, ~wt, ~mpg, stroke = ~vs, shape = ~factor(cyl))


###
### interaction
###
slider_s <- input_slider(10, 100)
slider_o <- input_slider(0, 1, value = 0.5)

qvis(mtcars, ~wt, ~mpg, size := slider_s, opacity := slider_o)


keys_s <- left_right(10, 1000, step = 50)
qvis(mtcars, ~wt, ~mpg, size := keys_s, opacity := 0.5)

#The interaction isn't automatically triggered.  I think it's suitable for knitr
qvis(mtcars, ~wt, ~mpg, size := 100, opacity := 0.5) 

qvis(mtcars, ~wt, ~mpg, stroke = ~ cyl) + tooltip(f=function(df) paste(df$cyl))

###
### Layers
###

df <- data.frame(x = 1:10, y = runif(10))
qvis(df, ~x, ~y, layers = "point")

qvis(df, y=~x, ~y, layers = "area")
qvis(df, ~x, ~y1 + 0.1, y2 = ~y - 0.1, layers = "area")

df <- data.frame(x = 3:1, y = c(1, 3, 2), label = c("aaaaaaaaaaaaaaaaaaaaa", "bbbbbb", "c"))
qvis(df, ~x, ~y, text := ~label, layers = "text", dx := -20)
# ggvis(df, props(x=~x, y=~y, text = ~label)) + #Why is the colon required for text?
ggvis(df, props(x=~x, y=~y, text := ~label)) +
  layer_text()

t <- seq(0, 2 * pi, length = 40)
df <- data.frame(x = sin(t), y = cos(t), id=seq_along(t))
qvis(df, ~x, ~y, layers = "path")
ggvis(df, props(~x, ~y)) +
  layer_path() +
  layer_text(props(text := ~id))

qvis(mtcars, ~wt, ~mpg, layers = "smooth")
ggvis(mtcars, props(~wt, ~mpg)) +
  mark_point() +
  layer_smooth(formula = formula(y ~ x))

ggvis(mtcars, props(~wt, ~mpg)) +
  mark_point(props(shape:="diamond", fill=~factor(cyl))) +
  layer_smooth(formula = formula(y ~ x))

ggvis(mtcars, props(~wt, ~mpg)) +
  mark_point() +
  layer_smooth(span = 1, se = FALSE) +
  layer_smooth(span = 0.3, se = FALSE)

# ggvis(mtcars, props(x=~wt, y=~mpg)) +
ggvis(mtcars, props(x=prop(as.name("wt")), y=~mpg)) + #https://github.com/wch/movies/blob/master/server.R#L91
  mark_point() 


ggvis(mtcars, props(x=~id, y=~mpg)) +
  mark_point() 

###
### Capture of local variables
###
df <- data.frame(x = -10:10)
f <- function(n) {
  ggvis(df, props(x = ~x, y = ~x ^ n), layer_path())
}
f(1)
f(3.2)
(-10:10)^3.2
-2^3.2

####################################################
### scales
####################################################
# http://ggvis.rstudio.com/properties-scales.html

df <- data.frame(x = runif(5), y = runif(5),
                 labels = c("a", "b", "b", "a", "b"))
ggvis(df, props(x = ~x, y = ~y, text := ~labels, font = ~labels, fontSize := 40)) +
  layer_text() +
  scale_ordinal("font", range = c("Helvetica Neue", "Times New Roman"))

ggvis(mtcars, props(y = ~mpg)) +
  layer_point(props(x = prop(~disp, scale = "xdisp"), fill := "tomato")) +
  layer_point(props(x = prop(~wt, scale = "xwt"), fill := "blue")) +
  dscale("x", "numeric", name = "xdisp") +
  dscale("x", "numeric", name = "xwt") +
  guide_axis("x", "xdisp", orient = "bottom") +
  guide_axis("x", "xwt", orient = "top", offset = 0, properties =
               list(labels = props(fill := "yellow")))


ggvis(df, props(x = ~x, y = ~y, text := ~labels, font = ~labels, stroke = ~labels, fill = ~labels, fontSize := 40)) +
  layer_text() +
  scale_ordinal("font", range = c("Helvetica Neue", "Times New Roman")) +
#   scale(name="stroke", range="category10", reverse=F) +
  scale(name="fill", range="category20", reverse=TRUE)

# Discrete colours for fill and a manual scale for opacity
ggvis(mtcars, props(x = ~wt, y = ~mpg, fill = ~factor(cyl), fillOpacity = ~hp)) +
  layer_point() +
  dscale("opacity", "numeric", range = c(0.2, 1))

# https://github.com/rstudio/ggvis/blob/master/demo/scales.r
# Unscaled values in the data
mtc <- mtcars
mtc$color <- c("red", "teal", "#cccccc", "tan")
ggvis(mtc, props(x = ~wt, y = ~mpg, fill := ~color)) + layer_point()

# Unscaled constant
ggvis(mtcars, props(x = ~wt, y = ~mpg, fill := "red")) + layer_point()


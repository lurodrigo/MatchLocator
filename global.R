
library(shiny)
library(shinydashboard)
library(purrr)
library(jsonlite)
library(leaflet)

source("R/newton.R", encoding = "UTF-8")

EARTH_RADIUS = 6371.008

data = fromJSON("out.json")
matches = data$matches

pos1 = data$pos1
pos2 = data$pos2
pos3 = data$pos3

n = nrow(matches)

# gera as funções objetivo e a jacobiana
funcs = map(1:n, ~ getDistFunction(c(matches$dist1[.], matches$dist2[.]), pos1, pos2))
jacobian = getJacobianFunction(pos1, pos2)

# calcula numericamente as duas possíveis soluções
solution1 = map(funcs, newton, j = jacobian, x0 = c(pos1[1], pos2[2]))
solution2 = map(funcs, newton, j = jacobian, x0 = c(pos2[1], pos1[2]))

decide = function(p1, p2, d, p3) {
  distances = dist(p3, p1, p2)

  if (abs(distances[1] - d) < abs(distances[2] - d))
    p1
  else
    p2
}

definiteSolution = pmap(list(solution1, solution2, matches$dist3), decide, p3 = pos3)

matches$lat = map_dbl(1:n, ~ definiteSolution[[.]][1])
matches$lng = map_dbl(1:n, ~ definiteSolution[[.]][2])

# verifica que de fato são soluções aproximadas
print(map2(solution1, funcs, ~ .y(.x)))
print(map2(solution2, funcs, ~ .y(.x)))

funcs_ = map(1:n, ~ getDistFunction(c(matches$dist3[.], matches$dist2[.]), pos3, pos2))
diffs = map2(definiteSolution, funcs_, ~ .y(.x)) %>% map_dbl(~ .[1]) %>% abs

print(diffs)

print(mean(diffs))
print(sd(diffs))

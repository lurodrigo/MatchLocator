
objective = function(lambda0, da, db) {
  function(x) {
    EARTH_RADIUS * c(centralAngle(x, c(0, -lambda0)) - da,
      centralAngle(x, c(0,  lambda0)) - db)
  }
}

jacobObjective = function(lambda0) {
  lambda0
  function(x) {
    lngs = c(-lambda0, lambda0)
    denominators = sqrt(1 - cos(x[1])**2 * cos(x[2] - lngs)**2)
    EARTH_RADIUS * cbind(
      sin(x[1]) * cos(x[2] - lngs)/denominators,
      -cos(x[1]) * cos(x[2] - lngs)/denominators
    )
  }
}

inverse = function(m) {
  1 / det(m) * rbind(c(m[2, 2], -m[1, 2]), 
                     c(-m[2, 1], m[1, 1]))
}

newton2 = function(f, x0, j, epsilon = 1E-7, max = 20000) {
  oldGuess = x0
  
  for (i in 1:max) {
    print(i)
    guess = oldGuess - inverse(j(oldGuess)) %*% f(oldGuess)
    
    if (norm(guess - oldGuess, type = "2") < epsilon)
      break 
    oldGuess = guess
  }
  
  guess
}

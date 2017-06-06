
radians = function(x) x*pi/180

dist = function(P, A, B) {
  lat = radians(P[1])
  lng = radians(P[2])
  lat_i = radians(c(A[1], B[1]))
  lng_i = radians(c(A[2], B[2]))
  
  cosines = sin(lat_i)*sin(lat) + cos(lat_i)*cos(lat)*cos(lng - lng_i)
  EARTH_RADIUS * acos(cosines)
}

jacobianOfDist = function(P, A, B) {
  lat = radians(P[1])
  lng = radians(P[2])
  lat_i = radians(c(A[1], B[1]))
  lng_i = radians(c(A[2], B[2]))
  
  cosines = sin(lat_i)*sin(lat) + cos(lat_i)*cos(lat)*cos(lng - lng_i)

  dlat = EARTH_RADIUS * (-sin(lat_i)*cos(lat) + cos(lat_i)*sin(lat)*cos(lng - lng_i)) / sqrt(1 - cosines*cosines)
  dlng = EARTH_RADIUS * cos(lat_i)*cos(lat)*sin(lng - lng_i) / sqrt(1 - cosines*cosines)
  
  cbind(dlat, dlng)
}

getDistFunction = function(dist0, A, B) {
  dist0
  
  function(P) {
    dist(P, A, B) - dist0
  }
}

getJacobianFunction = function(A, B) {
  function(P) {
    jacobianOfDist(P, A, B)
  }
}

newton = function(f, x0, j, epsilon = 1E-12, max = 20000) {
  oldGuess = x0
  
  for (i in 1:max) {
    guess = oldGuess + solve(j(oldGuess), -f(oldGuess))
    
    if (norm(guess - oldGuess, type = "2") < epsilon)
      break 
    oldGuess = guess
  }

  guess
}

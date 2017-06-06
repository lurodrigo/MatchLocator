# change_coords.R
toRadians = function(x) x * pi/180
toDegrees = function(x) x * 180/pi

toCartesian = function(x) {
  c(
    cos(x[1])*cos(x[2]),
    cos(x[1])*sin(x[2]),
    sin(x[1])
  )
}

toLatLng = function(x) {
  lng = atan2(x[2], x[1])
  lat = atan2(x[3], sqrt(x[1]*x[1] + x[2]*x[2]))
  c(lat, lng)
}

crossProduct = function(A, B) {
  c(A[2]*B[3]-A[3]*B[2], A[3]*B[1]-A[1]*B[3], A[1]*B[2]-A[2]*B[1])
}

centralAngle = function(A, B) {
  acos(sin(A[1])*sin(B[1]) + cos(A[1])*cos(B[1])*cos(A[2]-B[2]))
}

getRotations = function(A, B, lambda0) {
  CA = toCartesian(A)
  CB = toCartesian(B)
  N = crossProduct(CA, CB)
  
  transf = cbind(
      toCartesian(c(0, -lambda0)), 
      toCartesian(c(0, lambda0)),            
      c(0, 0, norm(N, type = "2"))) %*% solve(cbind(CA, CB, N))
  inv = solve(transf)
  
  list(
    usual = function(x) toLatLng(transf %*% toCartesian(x)),
    inverse = function(x) toLatLng(inv %*% toCartesian(x))
  )
}
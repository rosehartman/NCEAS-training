# Rscript for debugging

a = 10
b = 50

simplesum = function(x, y){
  y = y + 10
  z = y + 20
  return(sum(x, z))
}

listofsums = function(n){
  m = n*23
  o = simplesum(n, 23)
  return(o)
}



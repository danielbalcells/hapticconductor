/*
  Return the magnitude of a vector
*/

double getMag(PVector v){
  double norm = Math.sqrt(Math.pow(v.x, 2) + Math.pow(v.y, 2));
  return norm;
}
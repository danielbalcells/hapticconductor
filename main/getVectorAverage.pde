/*
  Loop through the elements of a vector and returns their average.
*/

PVector getVectorAverage(ArrayList<PVector> buffer){
  float xSum=0;
  float ySum=0;
  
  for(int i = 0; i < buffer.size();i++){
    xSum+= buffer.get(i).x;
    ySum+= buffer.get(i).y;
  }
  return new PVector(xSum/buffer.size(),ySum/buffer.size());
}
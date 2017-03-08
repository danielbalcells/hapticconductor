/*
  Initialize buffers setting all their elements to zero.
*/

void initBuffers(){
  xyBuffer = new ArrayList<PVector>();
  velBuffer = new ArrayList<PVector>();
  accBuffer = new ArrayList<PVector>();
  
  for(int i = 0; i<BUFFER_SIZE;i++){
    xyBuffer.add(new PVector(0,0));
    velBuffer.add(new PVector(0,0));
    accBuffer.add(new PVector(0,0));
  } 
}
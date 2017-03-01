ArrayList<PVector> xyBuffer;
ArrayList<PVector> velBuffer;
ArrayList<PVector> accBuffer;
int bufferSize = 20;

void setup(){
xyBuffer = new ArrayList<PVector>();
velBuffer = new ArrayList<PVector>();
accBuffer = new ArrayList<PVector>();
for(int i = 0; i<bufferSize;i++){
  xyBuffer.add(new PVector(0,0));
  velBuffer.add(new PVector(0,0));
  accBuffer.add(new PVector(0,0));
}
size(600,600);


}

void draw(){
  //frameRate(15);
  xyBuffer.remove(0);
  xyBuffer.add(new PVector(mouseX,mouseY));
  velBuffer.remove(0);
  velBuffer.add(instantVar(xyBuffer));
  accBuffer.remove(0);
  accBuffer.add(instantVar(velBuffer));
  //println(xyBuffer);

  fill(color(0,0,0));
  if(mouseX<width/4){
  fill(color(0,250,250));
}
if(mouseX>(3*width)/4 ){
  fill(color(150,150,250));
}
if(mouseY > (3*height)/4){
  
  color mappedColour = lerpColor(color(65,0,65),color(255,0,255),((float(mouseY)-(3*float(height))/4)/(float(height)/4)));
  fill(mappedColour);
}




float xSum=0;
float ySum=0;

float xVelSum=0;
float yVelSum=0;

for(int i = 0; i < velBuffer.size();i++){
  xSum+= velBuffer.get(i).x;
  ySum+= velBuffer.get(i).y;
  
  xVelSum+= accBuffer.get(i).x;
  yVelSum+= accBuffer.get(i).y;
}

float averageXVel = xSum/velBuffer.size();
float averageYVel = ySum/velBuffer.size();

float averageXAcc = xVelSum/accBuffer.size();
float averageYAcc = yVelSum/accBuffer.size();

//text(Float.toString(instantVar(xyBuffer)),50,50);


if(Math.pow(averageXAcc,2) + Math.pow(averageYAcc,2) > 5 && 
(Math.pow(velBuffer.get(velBuffer.size()-1).x,2) + Math.pow(velBuffer.get(velBuffer.size()-1).y,2)) - 
(Math.pow(velBuffer.get(velBuffer.size()-2).x,2) + Math.pow(velBuffer.get(velBuffer.size()-2).y,2))

> 0){
background(150);
} else {
background(255);
}


text(Float.toString(averageXVel),50,50);
text(Float.toString(averageYVel),100,50);
text(Float.toString(averageXAcc),50,100);
text(Float.toString(averageYAcc),100,100);


line(0,height/4,height,height/4);
line(0,(3*height)/4,height,(3*height)/4);

line(width/4,0,width/4,height);
line((3*width)/4,0,(3*width)/4,height);

for(int i = 0;i<3;i++){
  for(int p=0; p<3;p++){
    ellipse(width/4+(i*65)+65,height/4+(p*65)+65,50,50);
  }
  
}



ellipse(mouseX,mouseY,50,50);


//text(frameRate,100,100);
}

PVector instantVar(ArrayList<PVector> buffer){
  PVector currentFrame = buffer.get(buffer.size()-1);
  PVector previousFrame = buffer.get(buffer.size()-2);
  
  float changeinX = currentFrame.x - previousFrame.x;
  float changeinY = currentFrame.y - previousFrame.y;
  
  return new PVector(changeinX,changeinY);
}
void setup(){
size(600,600);
}

void draw(){
background(255);



line(0,height/4,height,height/4);
line(0,(3*height)/4,height,(3*height)/4);

line(width/4,0,width/4,height);
line((3*width)/4,0,(3*width)/4,height);

for(int i = 0;i<3;i++){
  for(int p=0; p<3;p++){
    ellipse(width/4+(i*65)+65,height/4+(p*65)+65,50,50);
  }
  
}

if(mouseX<width/4){
  fill(color(0,250,250));
}
if(mouseX<(3*width)/4 && ){
  fill(color(150,150,250));
}
else {
  fill(color(0,0,0));
}

ellipse(mouseX,mouseY,50,50);

}
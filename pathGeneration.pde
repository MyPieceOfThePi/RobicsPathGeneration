float maxVel = 200;
float maxAccel = 150;
float maxRotVel = 10;
float dt = 0.001;
float curveIncrement = 1;
boolean UI = false;
FloatList profileToDraw = new FloatList();
Curve seg = new Curve();
boolean cntrl = false;
boolean z =false;
boolean e = true;
int editingPoint = -1;

ArrayList<PVector> pointsL = new ArrayList<PVector>();
ArrayList<PVector> pointsLPast = new ArrayList<PVector>();
void disk(float x, float y){
  push();
  fill(0,0,0,30);
  ellipse(x-3,height-y+3,25,25);
  fill(245,220,15);
  ellipse(x,height-y,25,25);
  fill(235,210,15);
  ellipse(x,height-y,17,17);
  pop();
}
void keyPressed(){
  if(keyCode==17){
    cntrl = true;
    if(z==true){
        pointsL=pointsLPast;
    }
  }
  if(keyCode==90){
    z = true;
    if(cntrl==true){
      print(pointsLPast);
        pointsL=pointsLPast;
    }
  }
}
void updateThread(){
  push();
  profileToDraw = seg.generateVelocity();
  pop();
}
void mouseReleased(){
  //thread("updateThread");
}
void keyReleased(){
  if(keyCode==10){
    cntrl = false;
  }
  if(keyCode==89){
    z = false;
  }
}
void mousePressed(){
  boolean found = false;
  if(e&&editingPoint<0){
    for(int i = 0; i < pointsL.size()&&!found; i++){
      if(inRect(pointsL.get(i).x-7.5,pointsL.get(i).y-7.5,pointsL.get(i).x+7.5,pointsL.get(i).y+7.5)){
        if(mouseButton==37){
          pointsLPast=pointsL;
          editingPoint=i;
        }else if(mouseButton==39){
          pointsLPast=pointsL;
          pointsL.remove(i);
        }
      }
    }
    for(int i = 0; i < pointsL.size()&&!found; i++){
    if(mouseButton==37&&editingPoint<0){
      for(float j = 0; j < 1&&!found; j += 0.02){
        if(i<pointsL.size()-1){
          if(dist(seg.pointOn(i,j).x,seg.pointOn(i,j).y,mouseX,mouseY)<15){
            pointsLPast=pointsL;
            pointsL.add(i+1,new PVector(mouseX,mouseY));
            editingPoint = i+1;
            found=true;
          }
        }
      }
      }
    }
  }
  if(mouseButton==37){
  if(!((inRect(280,585,320,595)&&!UI)||(inRect(280,485,320,495)&&UI)||(inRect(0,495,600,600)&&UI))&&editingPoint<0&&!found){
    pointsLPast=pointsL;
    pointsL.add(new PVector(mouseX,mouseY));
  }
  if(UI&&!((inRect(280,585,320,595)&&!UI)||(inRect(280,485,320,495)&&UI)||(inRect(0,495,600,600)&&UI))){
    //thread("updateThread");
  }
  if(inRect(280,585,320,595)&&!UI){
    UI=!UI;
    drawUI();
    //thread("updateThread");
  }
  if(inRect(280,485,320,495)&&UI){
    UI=!UI;
  }
  }
}
void drawUI(){
  push();
  if(!UI){
    noStroke();
    fill(20,20,40,200);
    rect(0,595,600,600,4);
    rect(280,585,320,595,4,4,0,0);
    stroke(150,150,150,200);
    strokeWeight(2);
    line(290,592,300,588);
    line(310,592,300,588);
  }else{
    noStroke();
    fill(20,20,40,200);
    rect(0,595-100,600,600,4);
    rect(280,585-100,320,495,4,4,0,0);
    stroke(150,150,150,200);
    strokeWeight(2);
    line(290,588-100,300,592-100);
    line(310,588-100,300,592-100);
    float size = profileToDraw.size();
    for(int i = 0;i<size;i+=round(profileToDraw.size()/250)){
      int size2 = round(min(i+size/250,size-1));
      line(i*(250/size)+50,575-profileToDraw.get(i)/4,size2*(250/size)+50,575-profileToDraw.get(size2)/4);
    }
  }
  pop();
}
boolean inRect(float x0,float y0, float x1,float y1){
  if(mouseX<=x1&&mouseX>=x0&&mouseY<=y1&&mouseY>=y0){
    return true;
  }
  return false;
}
class Curve{
  float x0,x1,x2,x3,x4,x5,y0,y1,y2,y3,y4,y5=0;
  Curve(){
  }
  float scaleFactor = 1.2; 
void drawCurve(){
  push();
  for(int n = 0; n < pointsL.size()-1; n++){
    x0=pointsL.get(n).x;
    y0=pointsL.get(n).y;
    x1=tangent(n,1).x;
    y1=tangent(n,1).y;
    x2=secondDerivitive(n,1).x;
    y2=secondDerivitive(n,1).y;
    x3=secondDerivitive(n+1,-1).x;
    y3=secondDerivitive(n+1,-1).y;
    x4=tangent(n+1,-1).x;
    y4=tangent(n+1,-1).y;
    x5=pointsL.get(n+1).x;
    y5=pointsL.get(n+1).y;
  for(float i = 0; i <= 1; i+=dt){
     strokeWeight(4);
     stroke(0,200,0,50);
     point(x0*pow((1-i),5)+5*x1*pow((1-i),4)*pow(i,1)+10*x2*pow((1-i),3)*pow(i,2)+10*x3*pow((1-i),2)*pow(i,3)+5*x4*pow((1-i),1)*pow(i,4)+x5*pow((1-i),0)*pow(i,5),y0*pow((1-i),5)+5*y1*pow((1-i),4)*pow(i,1)+10*y2*pow((1-i),3)*pow(i,2)+10*y3*pow((1-i),2)*pow(i,3)+5*y4*pow((1-i),1)*pow(i,4)+y5*pow((1-i),0)*pow(i,5));
  }
  }
  pop();
}
PVector pointOn(int n, float i){
  x0=pointsL.get(n).x;
  y0=pointsL.get(n).y;
  x1=tangent(n,1).x;
  y1=tangent(n,1).y;
  x2=secondDerivitive(n,1).x;
  y2=secondDerivitive(n,1).y;
  x3=secondDerivitive(n+1,-1).x;
  y3=secondDerivitive(n+1,-1).y;
  x4=tangent(n+1,-1).x;
  y4=tangent(n+1,-1).y;
  x5=pointsL.get(n+1).x; 
  y5=pointsL.get(n+1).y;
  return new PVector(x0*pow((1-i),5)+5*x1*pow((1-i),4)*pow(i,1)+10*x2*pow((1-i),3)*pow(i,2)+10*x3*pow((1-i),2)*pow(i,3)+5*x4*pow((1-i),1)*pow(i,4)+x5*pow((1-i),0)*pow(i,5),y0*pow((1-i),5)+5*y1*pow((1-i),4)*pow(i,1)+10*y2*pow((1-i),3)*pow(i,2)+10*y3*pow((1-i),2)*pow(i,3)+5*y4*pow((1-i),1)*pow(i,4)+y5*pow((1-i),0)*pow(i,5));
}
FloatList update(){
  FloatList v = new FloatList();
  for(int n = 0; n < pointsL.size()-1; n++){
    x0=pointsL.get(n).x;
    y0=pointsL.get(n).y;
    x1=tangent(n,1).x;
    y1=tangent(n,1).y;
    x2=secondDerivitive(n,1).x;
    y2=secondDerivitive(n,1).y;
    x3=secondDerivitive(n+1,-1).x;
    y3=secondDerivitive(n+1,-1).y;
    x4=tangent(n+1,-1).x;
    y4=tangent(n+1,-1).y;
    x5=pointsL.get(n+1).x;
    y5=pointsL.get(n+1).y;
  for(float i = 0; i <= 1; i+=dt){
     float dx = 5*pow(1-i,4)*(x1-x0)+20*pow(1-i,3)*pow(i,1)*(x2-x1)+40*pow(1-i,2)*pow(i,2)*(x3-x2)+20*pow(1-i,1)*pow(i,3)*(x4-x3)+5*pow(i,4)*(x5-x4);
     float dy = 5*pow(1-i,4)*(y1-y0)+20*pow(1-i,3)*pow(i,1)*(y2-y1)+40*pow(1-i,2)*pow(i,2)*(y3-y2)+20*pow(1-i,1)*pow(i,3)*(y4-y3)+5*pow(i,4)*(y5-y4);
     float d2x = 20*pow(1-i,3)*(x2-2*x1+x0)+60*pow(1-i,2)*pow(i,1)*(x3-2*x2+x1)+60*pow(1-i,1)*pow(i,2)*(x4-2*x3+x2)+20*pow(i,3)*(x5-2*x4+x3);
     float d2y = 20*pow(1-i,3)*(y2-2*y1+y0)+60*pow(1-i,2)*pow(i,1)*(y3-2*y2+x1)+60*pow(1-i,1)*pow(i,2)*(y4-2*y3+y2)+20*pow(i,3)*(y5-2*y4+y3);
     PVector derivitive = new PVector(dx,dy);
     PVector secondDerivitve = new PVector(d2x,d2y);
     PVector tempDerivitve = derivitive;
     float k = (tempDerivitve.cross(secondDerivitve).mag()/pow(derivitive.mag(),3));
     v.append(min(maxVel,maxRotVel/k));
  }
  }
  return v;
}
PVector secondDerivitive(int i, int val){
  if(i+1<pointsL.size()){
    if(i-1>=0){
      float dAB = dist(pointsL.get(i).x,pointsL.get(i).y,pointsL.get(i-1).x,pointsL.get(i-1).y);
      float dBC = dist(pointsL.get(i).x,pointsL.get(i).y,pointsL.get(i+1).x,pointsL.get(i+1).y);
      PVector tangentA = tangent(i-1,1).sub(pointsL.get(i-1));
      PVector tangentB = tangent(i,1).sub(pointsL.get(i));
      PVector tangentC = tangent(i+1,1).sub(pointsL.get(i+1));
      float alpha = dBC/(dAB+dBC);
      float beta = dAB/(dAB+dBC);
      PVector secondDerivitive = new PVector(alpha*(6*pointsL.get(i-1).x+2*tangentA.x+4*tangentB.x-6*pointsL.get(i).x)+beta*(-6*pointsL.get(i).x-2*tangentB.x-4*tangentC.x+6*pointsL.get(i+1).x),alpha*(6*pointsL.get(i-1).y+2*tangentA.y+4*tangentB.y-6*pointsL.get(i).y)+beta*(-6*pointsL.get(i).y-2*tangentB.y-4*tangentC.y+6*pointsL.get(i+1).y));
      if(val==1){
        PVector tempSecDeriv = new PVector(secondDerivitive.x/20,secondDerivitive.y/20);
        PVector P2 = new PVector((tempSecDeriv.x)-pointsL.get(i).x+(2*tangent(i,1).x),(tempSecDeriv.y)-pointsL.get(i).y+(2*tangent(i,1).y));
        return P2;
      }else{
        PVector tempSecDeriv = new PVector(secondDerivitive.x/20,secondDerivitive.y/20);
        return tempSecDeriv.sub(pointsL.get(i)).add((tangent(i,-1).mult(2)));
      }
    }
    PVector tangentB = tangent(i,1).sub(pointsL.get(i));
    PVector tangentC = tangent(i+1,1).sub(pointsL.get(i+1));
    PVector secondDerivitive = new PVector((-6*pointsL.get(i).x-2*tangentB.x-4*tangentC.x+6*pointsL.get(i+1).x),(-6*pointsL.get(i).y-2*tangentB.y-4*tangentC.y+6*pointsL.get(i+1).y)).div(20);
    return secondDerivitive.sub(pointsL.get(i)).add(tangent(i,1).mult(2));
  }
  PVector tangentA = tangent(i-1,1).sub(pointsL.get(i-1));
  PVector tangentB = tangent(i,1).sub(pointsL.get(i));
  PVector secondDerivitive = new PVector((6*pointsL.get(i-1).x+2*tangentA.x+4*tangentB.x-6*pointsL.get(i).x),(6*pointsL.get(i-1).y+2*tangentA.y+4*tangentB.y-6*pointsL.get(i).y));
  //print(secondDerivitive.mag());
  PVector tempSecDeriv = new PVector(secondDerivitive.x/20,secondDerivitive.y/20);
  return tempSecDeriv.sub(pointsL.get(i)).add((tangent(i,-1).mult(2)));
}
PVector tangent(int i,int val){
  if(i+1<pointsL.size()){
    if(i-1>=0){
      float b = dist(pointsL.get(i).x,pointsL.get(i).y,pointsL.get(i-1).x,pointsL.get(i-1).y);
      float a = dist(pointsL.get(i).x,pointsL.get(i).y,pointsL.get(i+1).x,pointsL.get(i+1).y);
      float angleA = atan2(pointsL.get(i).y-pointsL.get(i+1).y,pointsL.get(i).x-pointsL.get(i+1).x);
      float angleTangent = atan2((pointsL.get(i).y-b*sin(angleA))-pointsL.get(i-1).y,(pointsL.get(i).x-b*cos(angleA))-pointsL.get(i-1).x);
      float tangentLength = 0.2*val * scaleFactor * min(b,a);
      //line(pointsL.get(i).x,pointsL.get(i).y,pointsL.get(i).x+tangentLength*cos(angleTangent),pointsL.get(i).y+tangentLength*sin(angleTangent));
      return new PVector((pointsL.get(i).x+tangentLength*cos(angleTangent)),(pointsL.get(i).y+tangentLength*sin(angleTangent)));
    }
    float tangentAngle = atan2(pointsL.get(i+1).y-pointsL.get(i).y,pointsL.get(i+1).x-pointsL.get(i).x);
    float a = dist(pointsL.get(i).x,pointsL.get(i).y,pointsL.get(i+1).x,pointsL.get(i+1).y);
    float tangentLength = val*0.2*scaleFactor*a;
    //line(pointsL.get(i).x,pointsL.get(i).y,pointsL.get(i).x+tangentLength*cos(tangentAngle),pointsL.get(i).y+tangentLength*sin(tangentAngle));
    return new PVector((5*pointsL.get(i).x+tangentLength*cos(tangentAngle))/5,(5*pointsL.get(i).y+tangentLength*sin(tangentAngle))/5);
  }
    float tangentAngle = atan2(pointsL.get(i-1).y-pointsL.get(i).y,pointsL.get(i-1).x-pointsL.get(i).x);
    float b = dist(pointsL.get(i).x,pointsL.get(i).y,pointsL.get(i-1).x,pointsL.get(i-1).y);
    float tangentLength = val*0.2*scaleFactor*b;
    //line(pointsL.get(i).x,pointsL.get(i).y,pointsL.get(i).x+tangentLength*cos(tangentAngle),pointsL.get(i).y+tangentLength*sin(tangentAngle));
      return new PVector((5*pointsL.get(i).x+tangentLength*cos(tangentAngle))/5,(5*pointsL.get(i).y+tangentLength*sin(tangentAngle))/5);
}
  FloatList generateVelocity(){
    float currentDistance = 0;
    FloatList vTrue = new FloatList();
    FloatList v = update();
    for(int n = 0; n < pointsL.size()-1; n++){
      for(float i = 0; i <= 1; i+=dt){
        currentDistance+=dist(pointOn(n,1).x,pointOn(n,1).y,pointOn(n,i+dt).x,pointOn(n,1+dt).y);
        if(currentDistance>=curveIncrement){
          int s=vTrue.size();
          if(s==0){
            vTrue.append(0);
          }else{
          int j = round((i+n)*1/dt);
          vTrue.append(min(v.get(j),sqrt(pow(vTrue.get(vTrue.size()-1),2)+2*curveIncrement*maxAccel)));
          }
          currentDistance=0;
        }
      }
    }
    vTrue.set(0,0);
    vTrue.set(vTrue.size()-1,0);
    for(int i = vTrue.size()-1; i > 0; i--){
      vTrue.set(i-1,min(vTrue.get(i-1),sqrt(pow(vTrue.get(i),2)+2*curveIncrement*maxAccel)));
    }
    return vTrue;
  }
}

void setup(){
  size(600,600);
  rectMode(CORNERS);
  Curve seg = new Curve();
  seg.generateVelocity();
}
void draw(){
  noStroke();
  for(int i = 0; i<6;i++){
    for(int j = 0; j<6;j++){
      if(i%2+j%2==1){
        fill(130);
      }else{
        fill(150);
      }
      rect(i*100,j*100,(i+1)*100,(j+1)*100);
    }
  }
  push();
  stroke(255);
  strokeWeight(3.5);
  line(0,594,594,0);
  line(6,600,600,6);
  pop();
  disk(50,50);
  disk(100,100);
  disk(150,150);
  disk(200,200);
  disk(250,250);
  disk(550,550);
  disk(500,500);
  disk(450,450);
  disk(400,400);
  disk(350,350);
  disk(250,350);
  disk(200,300);
  disk(150,250);
  disk(350,450);
  disk(400,300);
  disk(350,250);
  disk(250,150);
  disk(450,350);
  disk(400-18,115);
  disk(400-18,150);
  disk(400-18,185);
  disk(415,200+18);
  disk(450,200+18);
  disk(485,200+18);
  disk(200+18,415);
  disk(200+18,450);
  disk(200+18,485);
  disk(115,400-18);
  disk(150,400-18);
  disk(185,400-18);
  push();
  strokeWeight(8);
  stroke(255);
  noFill();
  line(150,0,0,150);
  line(450,600,600,450);
  rect(0,0,600,700);
  stroke(193,63,33);
  line(400,500,400,400);
  line(500,400,400,400);
  noFill();
  strokeWeight(5);
  ellipse(75,75,70,70);
  ellipse(75,75,50,50);
  fill(193,63,33);
  ellipse(75,75,25,25);
  line(75+35,75,75-35,75);
  line(75,75-35,75,75+35);
  noFill();
  strokeWeight(8);
  stroke(60,124,211);
  strokeWeight(5);
  ellipse(525,525,70,70);
  ellipse(525,525,50,50);
  fill(60,124,211);
  ellipse(525,525,25,25);
  line(525+35,525,525-35,525);
  line(525,525-35,525,525+35);
  noFill();
  line(200,100,200,200);
  line(100,200,200,200);
  pop();
  seg.drawCurve();
  drawUI();
  if(e){
    for(int i = 0; i < pointsL.size(); i++){
      push();
      stroke(30,80,30,100);
      strokeWeight(15);
      point(pointsL.get(i).x,pointsL.get(i).y);
      stroke(30,80,30,255);
      strokeWeight(7);
      point(pointsL.get(i).x,pointsL.get(i).y);
      pop();
    }
  }
  if(editingPoint>=0){
    pointsL.set(editingPoint,new PVector(mouseX, mouseY));
  }
  if(!mousePressed){
    editingPoint = -1;
  }
  push();
  fill(0,0,0,50);
  ellipse(mouseX,mouseY,15,15);
  pop();
}

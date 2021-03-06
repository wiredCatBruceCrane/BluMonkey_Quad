
 
import processing.serial.*;
import java.io.IOException;

import cc.arduino.*;
import java.util.Scanner;

Serial myPort;
long lastTime;

float x_rot = 0;
float y_rot = 0;
float z_rot = 0;

int width = 800;
int height = 800;
void setup(){
  size(width,height,P3D);
  for (int i = 0; i < Arduino.list().length ; i++){
    System.out.println(Arduino.list()[i]); 
  }
  myPort = new Serial(this, Arduino.list()[Arduino.list().length -1],57000);
  lastTime = millis();
  background(0);
}

void draw(){
  if (millis() - lastTime > 10){
    background(0);
    lastTime = millis(); 
//    getData();
    simpleData();
    pushMatrix();
    translate(width/2,height/2,0);
    rotateZ(radians(y_rot));
    rotateX(radians(x_rot));
    fill(150,0,0);
    box(.35*width,.10*width,.30*width);
    popMatrix();
  }
  
}

void simpleData(){
  myPort.bufferUntil('\n');
  String s = myPort.readStringUntil('\n');
  if (s == null) return;
  Scanner sc = new Scanner(s);
  sc.useDelimiter("[, \n]");
  try{
  float x = Float.parseFloat(sc.next());
  float y = Float.parseFloat(sc.next());
  System.out.println(x + ", " + y);
  x_rot = x;
  y_rot = y;
  } catch (NumberFormatException nfe) {
    nfe.printStackTrace();
  }

}

void getData(){
    myPort.bufferUntil('\n');
    String s = myPort.readStringUntil('\n');
    if (s == null) return;
    Scanner sc;
    if (s.contains("Accel: ")){
      s = s.replace("Accel: ","");
      sc = new Scanner(s);
      sc.useDelimiter("[, \n]");
      float x = Float.parseFloat(sc.next());
      float y = Float.parseFloat(sc.next());
      float z = Float.parseFloat(sc.next());
      x_rot = x;
      y_rot = y;
      z_rot = z;
      System.out.println("Accel: "+x+","+y+","+z);
    } 
    else if (s.contains("Gyro: ")){
      s = s.replace("Gyro: ","");    
      sc = new Scanner(s);
      sc.useDelimiter("[, \n]");
      float x = Float.parseFloat(sc.next());
      float y = Float.parseFloat(sc.next());
      float z = Float.parseFloat(sc.next());
      System.out.println("Gyro: "+x+","+y+","+z);
    } else if (s.contains("Magneto: ")){
      s = s.replace("Magneto: ","");    
      sc = new Scanner(s);
      sc.useDelimiter("[, \n]");
      double x = Double.parseDouble(sc.next());
      double y = Double.parseDouble(sc.next());
      double z = Double.parseDouble(sc.next());
      
      System.out.println("Mag: " + x+","+y+","+z);
    }
}

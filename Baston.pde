import processing.serial.*;

Serial myPort;        // The serial port
int xPos = 0;         // horizontal position of the graph

float yaw = 0.0;
float pitch = 0.0;
float roll = 0.0;

float ax;
float ay;
float az;

float prevYaw;
float prevPitch;
float prevRoll;

float prevax;
float prevay;
float prevaz;

void setup() {
  //size(800, 600);
  fullScreen();
  //translate(0, height/2);
  myPort = new Serial(this, Serial.list()[0], 9600);
  frameRate(60);
  background(0);
  drawStuff();
}

void draw()
{

  serialEvent();

  //CHANGE THIS VARIABLE TO THE VARIABLE YOU WANNA PLOT:

  strokeWeight(15);
  stroke(255, 0, 0);
  line(frameCount-1, prevYaw+height*.25, frameCount, yaw+height*.25);
  prevYaw = yaw;
  stroke(0, 255, 0);
  line(frameCount-1, prevPitch+height*.25, frameCount, pitch+height*.25);
  prevPitch = pitch;
  stroke(0, 0, 255);
  line(frameCount-1, prevRoll+height*.25, frameCount, roll+height*.25);
  prevRoll = roll;

  //strokeWeight(5);
  stroke(255, 0, 0);
  line(frameCount-1, prevax+height/1.3, frameCount, ax+height/1.3);
  prevax = ax;
  stroke(0, 255, 0);
  line(frameCount-1, prevay+height/1.3, frameCount, ay+height/1.3);
  prevay = ay;
  stroke(0, 0, 255);
  line(frameCount-1, prevaz+height/1.3, frameCount, az+height/1.3);
  prevaz = az;

  if ( frameCount > width ) {
    frameCount = 0;
    background(0);
    drawStuff();
  }


  print(roll);
  print("\t");
  print(pitch);
  print("\t");
  print(yaw);
  print("\t");
  print(ax);
  print("\t");
  print(ay);
  print("\t");
  println(az);
}

void drawStuff() {
  background(0);
  strokeWeight(1);
  for (int i = 0; i <= width; i += 50) {
    fill(0, 255, 0);
    text(i/2, i-10, height-15);
    stroke(255);
    line(i, height, i, 0);
  }
  for (int j = 0; j < height; j+= 33) {
    fill(0, 255, 0);
    text(6-j/(height/6), 0, j);
    stroke(255);
    line(0, j, width, j);
  }
}

void serialEvent()
{
  int newLine = 13; // new line character in ASCII
  String message;
  do {
    message = myPort.readStringUntil(newLine); // read from port until new line
    if (message != null) {
      String[] list = split(trim(message), " ");
      if (list.length >= 7 && list[0].equals("Orientation:")) {
        yaw = float(list[1])*0.7; // convert to float yaw
        pitch = float(list[2])*0.7; // convert to float pitch
        roll = float(list[3])*0.7; // convert to float roll
        ax = float(list[4])*70;
        ay = float(list[5])*70;
        az = float(list[6])*70;
      }
    }
  } while (message != null);
}
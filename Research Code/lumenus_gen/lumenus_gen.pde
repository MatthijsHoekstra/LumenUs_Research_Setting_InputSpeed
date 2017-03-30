//test

import AULib.*;
//import spout.*;
import controlP5.*;



//----------------------------------------------------------------------------------------------------------------------------

int endAnimationSetting = 0; //Could be 0 or 1. 0 - End-animation starts after feedback time, 1 - End-animation starts after user releases tube

int feedbackSetting = 0; //This one is for controlling which feedback speed is set - will be connected to array
//Check drive for corresponding speed


//----------------------------------------------------------------------------------------------------------------------------

int numTripods = 24;
int numTubes = numTripods * 3;
int numLEDsPerTube = 56;

int rectWidth = 9;
int rectHeight = 8;
int tubeLength = rectWidth * numLEDsPerTube;

int x;
int y;

int selectedTube, tubeNumber;

Tube[] tubes = new Tube[numTubes];

//2D array which stores the broken tube: brokenTubes{{tripod}, {tube}, {side}}
int[][] brokenTubes = {{}, {}, {}};

//Spout spout;

PrintWriter logTestPerson;
PrintWriter numberOfTotalPersons;

String text;
ControlP5 cp5;
int myColor = color(255);

void setup() {
  size(1600, 880, OPENGL);
  frameRate(60);
  background(0);
  noStroke();
  noSmooth();

  for (int i=0; i< numTubes; i++) {
    tubes[i] = new Tube(i);
  }

  //drawRaster(); // drawRaster helps us with the LED mapping in ELM

  // Setup MQTT

  //client = new MQTTClient(this);
  //client.connect("mqtt://10.0.0.1", "processing");
  ////client.subscribe("tripods/" + 0 + "/tube/" + 0 + "/side/" + 0);

  //for (int i = 0; i < numTripods; i++) {
  //  for (int j = 0; j < 3; j++) {
  //    for (int k = 0; k < 2; k++) {
  //      //println(
  //      client.subscribe("tripods/" + i + "/tube/" + j + "/side/" + k);
  //    }
  //  }
  //}

  //spout = new Spout(this);
  // spout = new Spout(this);

  //String lines[] = loadStrings("data/logNumPeople/numberPersons.txt");

  //int numberOfTestPersons = parseInt(lines[0]);

  //int numberTestPerson = numberOfTestPersons + 1;

  //String filename = numberTestPerson + "_" + hour() + minute() + "_timing_research.txt";

  //logTestPerson = createWriter("data/" + filename); 

  //numberOfTotalPersons = createWriter("data/numberPersons.txt");

  //numberOfTotalPersons.print(numberOfTestPersons + 1);
  //numberOfTotalPersons.flush(); // Writes the remaining data to the file
  //numberOfTotalPersons.close(); // Finishes the file
  
  cp5 = new ControlP5(this);

  // knoppen
  cp5.addButton("1,5 sec")
    .setValue(1.5)
    .setPosition(100, height-100)
    .setSize(100, 19)
    ;

  cp5.addButton("5 sec")
    .setValue(5)
    .setPosition(205, height-100)
    .setSize(100, 19)
    ;

  cp5.addButton("8 sec")
    .setValue(8)
    .setPosition(310, height-100)
    .setSize(100, 19)
    ;

  cp5.addButton("15 sec")
    .setValue(15)
    .setPosition(415, height-100)
    .setSize(100, 19)
    ;
    
    // text input
  cp5.addTextfield("group")
  .setPosition(100, height-200)
  .setSize(100, 50)
  .setAutoClear(false);
  
  cp5.addBang("Submit")
  .setPosition(220, height-200)
  .setSize(100, 50);

  //numberOfTotalPersons.print(numberOfTestPersons + 1);
  //numberOfTotalPersons.flush(); // Writes the remaining data to the file
  //numberOfTotalPersons.close(); // Finishes the file
}

void draw() {

  background(0);

  for (int i=0; i<numTubes; i++) {
    tubes[i].update();
  }

  ShowFrameRate();

  selectingSystem();

  drawRaster();

  //spout.sendTexture();
  researchOptions();

  drawRaster();

  //brokenTubes();

  //spout.sendTexture();

  println(y);
}

void researchOptions() {

  switch(feedbackSetting) {
  case 0:

    break;

  case 1:

    break;

  case 2:

    break;

  case 3:

    break;
  }
}

void keyPressed() {

  int tubeNumber = currentSelectedTube + currentSelectedTripod * 3;


  //Selecting system for adding objects
  if (key == CODED) {
    if (keyCode == LEFT) {
      currentSelectedTube --;
    }
    if (keyCode == RIGHT) {
      currentSelectedTube ++;
    }
    if (keyCode == UP) {
      currentSelectedTripod --;
    }
    if (keyCode == DOWN) {
      currentSelectedTripod ++;
    }
  }

  if (key == '9') {
    for (int i=0; i<numTubes; i++) {
      tubes[i].isTouched(0);
      tubes[i].isTouched(1);
    }
  }

  if (key == '0') {
    for (int i=0; i<numTubes; i++) {
      tubes[i].isUnTouched(0);
      tubes[i].isUnTouched(1);
    }
  }

  if (key == '1') {
    tubes[tubeNumber].isTouched(0);
  }

  if (key == '2') {
    tubes[tubeNumber].isTouched(1);
  }

  if (key == ESC) {
    logTestPerson.flush(); // Writes the remaining data to the file
    logTestPerson.close();
  }

  if (key == ESC) {
    logTestPerson.flush(); // Writes the remaining data to the file
    logTestPerson.close();

    println("end file");
  }

  if (key == 'q') {
    tubes[tubeNumber].addGlitter();
  }
}

//Simulating the sensor input 0 - released

void keyReleased() {
  int tubeNumber = currentSelectedTube + currentSelectedTripod * 3;

  if (key == '1') {
    tubes[tubeNumber].isUnTouched(0);
  }

  if (key == '2') {
    tubes[tubeNumber].isUnTouched(1);
  }
}

void Submit() {
  print ("group:");
  text=cp5.get(Textfield.class, "group").getText();
  print(text);
}

import AULib.*;
import spout.*;
import controlP5.*;

//----------------------------------------------------------------------------------------------------------------------------

int endAnimationSetting = 0; //Could be 0 or 1. 0 - End-animation starts after feedback time, 1 - End-animation starts after user releases tube
String endAnimationSettingString;

int feedbackSetting = 0; //This one is for controlling which feedback speed is set - will be connected to array
//Check drive for corresponding speed
//int feedbackSpeed[] = {2000, 4000, 8000, 6000};

int feedbackSpeed[][] = 
  {
    
  {2000, 2000, 2000, 2000, 2000, 2000, 4000, 4000, 4000, 4000, 4000, 4000, 8000, 8000, 8000, 8000, 8000, 8000, 6000, 6000, 6000, 6000, 6000, 6000}, 
  {4000, 4000, 8000, 8000, 6000, 6000, 2000, 2000, 8000, 8000, 6000, 6000, 2000, 2000, 4000, 4000, 6000, 6000, 2000, 2000, 4000, 4000, 8000, 8000}, 
  {8000, 6000, 4000, 6000, 4000, 8000, 8000, 6000, 2000, 6000, 2000, 8000, 4000, 6000, 2000, 6000, 2000, 4000, 4000, 8000, 2000, 8000, 2000, 4000}, 
  {6000, 8000, 6000, 4000, 8000, 4000, 6000, 8000, 6000, 2000, 8000, 2000, 6000, 4000, 6000, 2000, 4000, 2000, 8000, 4000, 8000, 2000, 4000, 2000}

  };

int experimentNumber = -1; //4 possible options
//Start number -1, because button start adds +1

boolean displayGreenTransition = true;

boolean startTimer = false;
int startTimeTimer;
int currentTimeTimer;

int totalTimeTimer = 60000;

String testGroupNumberString;
int testGroupNumber;

int opacityGreenTransition = 0;

boolean startExperiment = false;


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

//2D array which stores the broken tube: brokenTubes{{tube}, {side}}
int[][] brokenTubes = {{7,18}, {1,1}};

Spout spout;

PrintWriter logTestPerson;
PrintWriter numberOfTotalPersons;

ControlP5 cp5;

void setup() {
  size(1600, 880, OPENGL);
  frameRate(60);
  background(0);
  noStroke();
  noSmooth();

  for (int i=0; i< numTubes; i++) {
    tubes[i] = new Tube(i);
  }

  addButtonsOnScreen();

  //drawRaster(); // drawRaster helps us with the LED mapping in ELM

  // Setup MQTT

  client = new MQTTClient(this);
  client.connect("mqtt://10.0.0.1", "processing");
  //client.subscribe("tripods/" + 0 + "/tube/" + 0 + "/side/" + 0);

  for (int i = 0; i < numTripods; i++) {
    for (int j = 0; j < 3; j++) {
      for (int k = 0; k < 2; k++) {
        //println(
        client.subscribe("tripods/" + i + "/tube/" + j + "/side/" + k);
      }
    }
  }


  spout = new Spout(this);

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

  //numberOfTotalPersons.print(numberOfTestPersons + 1);
  //numberOfTotalPersons.flush(); // Writes the remaining data to the file
  //numberOfTotalPersons.close(); // Finishes the file
  
  brokenTubes();

}

void draw() {

  background(0,0,0);

  researchOptions();

  for (int i=0; i<numTubes; i++) {
    tubes[i].update();
  }

  pushStyle();
  fill(0, 0, 0, 150);
  rect(0, height - 300, width, 300);
  popStyle();

  ShowFrameRate();

  selectingSystem();

  //drawRaster();

  spout.sendTexture();

}

void researchOptions() {

  if (startTimer) {
    startTimeTimer = millis();

    startTimer = false;
  }

  if (millis() > startTimeTimer + totalTimeTimer) {
    displayGreenTransition = true;
  }

  //For displaying the current time in experiment, linked to utility functions
  if (!displayGreenTransition) {
    currentTimeTimer = (millis() - startTimeTimer) / 1000;

    if (opacityGreenTransition >= 0) {
      opacityGreenTransition -= 5;

      pushStyle();
      fill(255, 0, 0, opacityGreenTransition);
      rect(0, 0, width, height);
      popStyle();
    } else {
      opacityGreenTransition = 0;
    }
  } else {
    currentTimeTimer = 0;
  }


  if (displayGreenTransition) {
    if (opacityGreenTransition <= 100) {
      opacityGreenTransition += 5;
    }

    pushStyle();
    fill(255, 0, 0, opacityGreenTransition);
    rect(0, 0, width, height);
    popStyle();
  } else {
    switch (experimentNumber) {
    case 0:
      //println("research 0");
      feedbackSetting = 0;
      break; 

    case 1:
      feedbackSetting = 1;
      //println("research 1");
      break;

    case 2:
      feedbackSetting = 2;
      //println("research 2");
      break;

    case 3:
      feedbackSetting = 3;
      //println("research 3");
      break;
    }
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

  if (key == 'w') {
    tubes[tubeNumber].isTouched(0);
  }

  if (key == 'e') {
    tubes[tubeNumber].isTouched(1);
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

  if (key == 'w') {
    tubes[tubeNumber].isUnTouched(0);
  }

  if (key == 'e') {
    tubes[tubeNumber].isUnTouched(1);
  }
}
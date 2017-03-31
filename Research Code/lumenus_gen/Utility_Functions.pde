// utility functions like drawRaster and showFrameRate

void drawRaster() {
  pushStyle();
  noFill();
  stroke(0, 102, 153);

  pushMatrix();
  translate(20, 21);  

  for (int j = 0; j < numTripods; j ++) {
    for (int i = 0; i < numLEDsPerTube; i ++) {
      rect(x, y, rectWidth, rectHeight);
      x += rectWidth;
    }

    x += 20;

    for (int i = 0; i < numLEDsPerTube; i ++) {
      rect(x, y, rectWidth, rectHeight);
      x += rectWidth;
    }

    x += 20;

    for (int i = 0; i < numLEDsPerTube; i ++) {
      rect(x, y, rectWidth, rectHeight);
      x += rectWidth;
    }
    x = 0;
    y += 21;
  }

  x = 0;
  y = 0;
  popMatrix();
  popStyle();
}

void ShowFrameRate() {
  pushStyle();
  fill(255);
  text(int(frameRate) + " " + currentSelectedTube + " " + currentSelectedTripod + " // Test Mode: " +  endAnimationSettingString + " // Current time experiment: " + currentTimeTimer + " // Current experiment: " + (experimentNumber + 1), 100, height - 250);
  popStyle();
}

int currentSelectedTube = 0;
int currentSelectedTripod = 0;

void selectingSystem() {
  //Keep selecting system within raster
  if (currentSelectedTube < 0) {
    currentSelectedTube = 0;
  }
  if (currentSelectedTube > 2) {
    currentSelectedTube = 2;
  }
  if (currentSelectedTripod < 0) {
    currentSelectedTripod = 0;
  }
  if (currentSelectedTripod >= numTripods) {
    currentSelectedTripod = numTripods - 1;
  }

  //Create rectangle for indicating which tube / tripod is selected
  pushMatrix();
  translate(currentSelectedTube * (numLEDsPerTube * rectWidth) + (currentSelectedTube * 20 + 20), currentSelectedTripod * 21 + 21); 

  pushStyle();
  noFill();

  stroke(255, 0, 0);
  rect(x-5, y-5, tubeLength+8, rectHeight+9);

  popStyle();
  popMatrix();
}

void brokenTubes() {
  for (int i = 0; i < brokenTubes.length; i++) {

    int tripod = brokenTubes[0][i]/3;
    int tube = brokenTubes[0][i];
    int touchSide = brokenTubes[1][i];

    if (touchSide == 0) {
      tubes[tube].amIBroken0 = true;
    } else if (touchSide == 1) {
      tubes[tube].amIBroken1 = true;
    }
  }
}

void addButtonsOnScreen() {

  cp5 = new ControlP5(this);

  // knoppen
  cp5.addButton("buttonEndGoalWhenAnimationFinished")
    .setValue(0)
    .setPosition(100, height-150)
    .setSize(200, 19)
    ;

  cp5.addButton("buttonEndGoalWhenReleased")
    .setValue(0)
    .setPosition(350, height-150)
    .setSize(200, 19)
    ;

  //cp5.addButton("8 sec")
  //  .setValue(8)
  //  .setPosition(310, height-100)
  //  .setSize(100, 19)
  //  ;

  //cp5.addButton("15 sec")
  //  .setValue(15)
  //  .setPosition(415, height-100)
  //  .setSize(100, 19)
  //  ;

  // text input
  cp5.addTextfield("group")
    .setPosition(100, height-225)
    .setSize(100, 50)
    .setAutoClear(false);

  cp5.addBang("StartButtonPressed")
    .setPosition(100, height-100)
    .setSize(450, 50);
}

void StartButtonPressed() {
  testGroupNumberString = cp5.get(Textfield.class, "group").getText();

  testGroupNumber = int(testGroupNumberString);

  if (startExperiment == false) {
    String filename = testGroupNumber + "_" + endAnimationSetting + "__" + hour() + minute() + "_timing_research.txt";

    logTestPerson = createWriter("data/" + filename);

    println("created log file");
    startExperiment = true;
  }

  displayGreenTransition = false; 

  experimentNumber ++;

  logTestPerson.println("//-------------------------------------- experiment: " + experimentNumber + " , " + feedbackSpeed[feedbackSetting][testGroupNumber]);

  startTimer = true;
}

public void buttonEndGoalWhenReleased(int i) {
  endAnimationSetting = 1;

  endAnimationSettingString = "End-animation starts after user releases tube";

  println(endAnimationSettingString);
}

public void buttonEndGoalWhenAnimationFinished(int i) {
  endAnimationSetting = 0;  

  endAnimationSettingString = "End-animation starts after feedback time";

  println(endAnimationSettingString);
}
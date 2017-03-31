//Standard setup for a class

class LoadBar {

  int tubeModulus;
  int tripodNumber;
  int touchLocation;

  // MIJN VARIABLEN
  float widthBar;
  float speed = 8.4;
  int outcomeSpeed;
  int startTime;

  int livingTime;

  LoadBar(int tubeModulus, int tripodNumber, int touchLocation) {
    this.tubeModulus = tubeModulus;
    this.tripodNumber = tripodNumber;
    this.touchLocation = touchLocation;

    startTime = millis();
    
    livingTime = feedbackSpeed[feedbackSetting][testGroupNumber];
  }

  void display() {
    pushMatrix();
    translate(this.tubeModulus * (numLEDsPerTube * rectWidth) + (this.tubeModulus * 20 + 20), this.tripodNumber * 21 + 21);

    if (touchLocation == 0) {

      float currentTime = map(millis(), startTime, startTime + livingTime, 0, 1);
      float interValue = AULib.ease(AULib.EASE_LINEAR, currentTime);
      float lengthLoadBar = map(interValue, 0, 1, 0, tubeLength);

      pushStyle();
      fill(255, 255, 255);
      rect(0, 0, lengthLoadBar, rectHeight);
      popStyle();
    }

    if (touchLocation == 1) {

      float currentTime = map(millis(), startTime, startTime + livingTime, 0, 1);
      float interValue = AULib.ease(AULib.EASE_LINEAR, currentTime);
      float lengthLoadBar = map(interValue, 0, 1, 0, tubeLength);

      pushStyle();
      fill(255, 255, 255);
      rect(tubeLength, 0, -lengthLoadBar, rectHeight);
      popStyle();
    }
    
    popMatrix();
  }

  boolean timeFinished() {
    if (millis() > startTime + livingTime) {
      return true;
    } else {
      return false;
    }
  }
}
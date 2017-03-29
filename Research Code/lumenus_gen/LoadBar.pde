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
    livingTime = 10000;
  }

  void display() {

    pushMatrix();
    translate(this.tubeModulus * (numLEDsPerTube * rectWidth) + (this.tubeModulus * 20 + 20), this.tripodNumber * 21 + 21);
    pushStyle();
    fill(255);

    //NOG OMZETTEN NAAR AULIB ipv FRAMERATE

    //float currentTime = map(millis(), startTime, startTime + fadeInTime, 0, 1);
    //float interValue = AULib.ease(AULib.EASE_IN_OUT_CUBIC, currentTime);
    //float opacity = map(interValue, 0, 1, 0, 255);
    //outcomeSpeed = AULib.ease(AULib.EASE_LINEAR, t);

    if (this.touchLocation == 0) {
      rect(0, 0, widthBar, rectHeight); // z is variable, dus geen meerdere mensen kunnen de installatie aanraken...
      widthBar = widthBar + speed;
      if (widthBar >= tubeLength) {
        widthBar = 0;
      }
    }

    if (this.touchLocation == 1) {
      rect(tubeLength, 0, widthBar, rectHeight);
      widthBar = widthBar - speed;
      if (-widthBar >= tubeLength) {
        widthBar = 0;
      }
    }

    popStyle();
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
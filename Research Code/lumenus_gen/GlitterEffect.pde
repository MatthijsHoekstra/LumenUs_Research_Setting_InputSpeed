class GlitterEffect {

  int tubeModulus, tripodNumber;

  ArrayList<Glitter> glitters = new ArrayList<Glitter>();

  int numberOfGlitters = 100;

  private int startTime, livingTime;

  GlitterEffect(int tubeModulus, int tripodNumber) {
    this.tubeModulus = tubeModulus;
    this.tripodNumber = tripodNumber;

    startTime = millis();
    livingTime = 3000;
  }

  void update() {
    for (int i = glitters.size() - 1; i >= 0; i--) {
      Glitter glitter = glitters.get(i);
      glitter.update();

      if (glitter.finished()) {
        glitters.remove(i);
      }
    }
  }

  void generate() {
    while (glitters.size() < numberOfGlitters) {
      glitters.add(new Glitter(this.tubeModulus, this.tripodNumber, random(tubeLength)));
    }
  }

  boolean timeFinished() {
    if (millis() > startTime + livingTime) {
      return true;
    } else {
      return false;
    }
  }

  boolean animationFinished() {
    if (glitters.size() == 0) {
      return true;
    } else {
      return false;
    }
  }
}


class Glitter {

  int tubeModulus, tripodNumber;

  float x;

  int startTime, livingTime;
  int fadeInTime;

  color randomColor;
  
  int currentTime = 20;

  Glitter(int tubeModulus, int tripodNumber, float x) {
    this.tubeModulus = tubeModulus;
    this.tripodNumber = tripodNumber;

    this.x = x;

    startTime = millis();
    
    livingTime = int(random(100, 900));

    randomColor = color(random(20, 255), random(20, 255), random(20, 255));

    fadeInTime = int(random(350,500));
  }

  void update() {
    pushMatrix();
    translate(this.tubeModulus * (numLEDsPerTube * rectWidth) + (this.tubeModulus * 20 + 20), this.tripodNumber * 21 + 21);
    pushStyle();

    if (millis() < startTime + fadeInTime) {
      
      float currentTime = map(millis(), startTime, startTime + fadeInTime, 0, 1);
      float interValue = AULib.ease(AULib.EASE_IN_OUT_CUBIC, currentTime);
      float opacity = map(interValue, 0, 1, 0, 255);

      fill(randomColor, constrain(opacity, 0, 255));
      rect(x, 0, rectWidth, rectHeight);
      
    } else {

      float currentTime = map(millis(), startTime + fadeInTime, startTime + livingTime + fadeInTime, 0, 1);
      float interValue = AULib.ease(AULib.EASE_IN_OUT_CUBIC, currentTime);
      float opacity = map(interValue, 0, 1, 255, 0);

      fill(randomColor, constrain(opacity, 0, 255));
      rect(x, 0, rectWidth, rectHeight);
    }
    
    currentTime = 10;
    popStyle();
    popMatrix();
  }

  boolean finished() {
    if (millis() > startTime + livingTime + fadeInTime) {
      return true;
    } else {
      return false;
    }
  }
}
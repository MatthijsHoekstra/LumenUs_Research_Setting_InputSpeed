/* The Lighteffect class is the mediator of the entire code
 lighteffect.update is the only function that is CONSTANTLY running
 .update checks the tubes that are active, decides what light-effect they should show and exectues the corrosponding functions
 */

//import toxi.util.events.*;

class Tube {
  private int tubeNumber;
  private int tubeModulus;
  private int tripodNumber;

  private boolean amIBroken0 = false;
  private boolean amIBroken1 = false;

  ArrayList<LoadBar> LoadBars = new ArrayList<LoadBar>();
  ArrayList<Timer> timers = new ArrayList<Timer>();

  ArrayList<GlitterEffect> glitterEffects = new ArrayList<GlitterEffect>();

  private boolean effectSide0 = false;
  private boolean effectSide1 = false;

  Tube(int tubeNumber) {
    this.tubeNumber = tubeNumber; //0 - numTubes
    this.tubeModulus = tubeNumber % 3; // 0, 1, 2
    this.tripodNumber = tubeNumber / 3; //0 - numTubes / 3
  }

  //Event when tube is touched

  void isTouched(int touchLocation) {
    if (touchLocation == 0 && effectSide0 == false) {
      timers.add(new Timer(tubeModulus, tripodNumber, touchLocation));

      LoadBars.add(new LoadBar(tubeModulus, tripodNumber, 0));

      effectSide0 = true;
    }

    if (touchLocation == 1 && effectSide1 == false) {
      timers.add(new Timer(tubeModulus, tripodNumber, touchLocation));

      LoadBars.add(new LoadBar(tubeModulus, tripodNumber, 1));

      effectSide1 = true;
    }
  }

  //Event when tube is released

  void isUnTouched(int touchLocation) {

    for (int i = 0; i < timers.size(); i++) {
      Timer timer = timers.get(i);

      if (timer.sideTouch == touchLocation) {
        timer.logTime();

        timers.remove(i);

        if (touchLocation == 0) {
          effectSide0 = false;
        }
        if (touchLocation == 1) {
          effectSide1 = false;
        }
      }
    }


    for (int i = 0; i < LoadBars.size(); i++) {
      LoadBar loadbar = LoadBars.get(i);

      if (loadbar.touchLocation == touchLocation) {

        if (loadbar.timeFinished() && endAnimationSetting == 1) {
          addGlitter();
        }

        LoadBars.remove(i);

        if (touchLocation == 0) {
          effectSide0 = false;
        }
        if (touchLocation == 1) {
          effectSide1 = false;
        }
      }
    }
  }

  // Executed every frame, for updating continiously things
  void update() {
    shutOffTheBroken();

    for (int i = 0; i < LoadBars.size(); i++) {
      LoadBar loadbar = LoadBars.get(i);

      loadbar.display();

      if (loadbar.timeFinished()) {
        if (endAnimationSetting == 0) {
          addGlitter();
          LoadBars.remove(i);
        }
      }
    }

    for (int i = glitterEffects.size() - 1; i >= 0; i--) {
      GlitterEffect glitterEffect = glitterEffects.get(i);

      glitterEffect.update();

      if (!glitterEffect.timeFinished()) {
        glitterEffect.generate();
      }

      if (glitterEffect.animationFinished()) {
        glitterEffects.remove(i);
      }
    }
  }

  void addGlitter() {
    glitterEffects.add(new GlitterEffect(this.tubeModulus, this.tripodNumber));
  }

  void shutOffTheBroken() {
    if (amIBroken0 == true || amIBroken1 == true) {
      pushMatrix();
      translate(tubeModulus * (numLEDsPerTube * rectWidth) + (tubeModulus * 20 + 20), tripodNumber * 21 + 21); 
      pushStyle();
      noStroke();
      fill(255, 0, 0, 50);
      if (amIBroken0 == true) {
        rect((tubeLength/2)*0, 0, tubeLength/2, rectHeight);
      }
      if (amIBroken1 == true) {
        rect((tubeLength/2)*1, 0, tubeLength/2, rectHeight);
      }
      popStyle();
      popMatrix();
    }
  }
}
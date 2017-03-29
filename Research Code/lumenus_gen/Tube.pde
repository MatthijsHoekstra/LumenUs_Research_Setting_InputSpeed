/* The Lighteffect class is the mediator of the entire code
 lighteffect.update is the only function that is CONSTANTLY running
 .update checks the tubes that are active, decides what light-effect they should show and exectues the corrosponding functions
 */

//import toxi.util.events.*;

class Tube {
  private int tubeNumber;
  private int tubeModulus;
  private int tripodNumber;

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
      LoadBars.add(new LoadBar(tubeModulus, tripodNumber, 0));
    }

    if (touchLocation == 1 && effectSide1 == false) {
      LoadBars.add(new LoadBar(tubeModulus, tripodNumber, 1));
    }

    if (touchLocation == 0 && effectSide0 == false) {
      timers.add(new Timer(tubeModulus, tripodNumber, touchLocation));

      effectSide0 = true;
    }

    if (touchLocation == 1 && effectSide1 == false) {
      timers.add(new Timer(tubeModulus, tripodNumber, touchLocation));

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
      LoadBar block = LoadBars.get(i);

      if (block.touchLocation == touchLocation) {
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
    for (int i = 0; i < LoadBars.size(); i++) {
      LoadBar block = LoadBars.get(i);

      block.display();
    }

    for (int i = glitterEffects.size() - 1; i >= 0; i--) {
      GlitterEffect glitterEffect = glitterEffects.get(i);
      
      glitterEffect.update();
      
      if (!glitterEffect.timeFinished()){
        glitterEffect.generate();
      }
      
      if (glitterEffect.animationFinished()){
        glitterEffects.remove(i);
      }
    }
  }
  
  
  void addGlitter(){
    glitterEffects.add(new GlitterEffect(this.tubeModulus, this.tripodNumber));
  }
}
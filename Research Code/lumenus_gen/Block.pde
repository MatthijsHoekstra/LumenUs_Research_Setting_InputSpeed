//Standard setup for a class

class Block {

  int tubeModulus;
  int tripodNumber;
  int touchLocation;

    Block(int tubeModulus, int tripodNumber, int touchLocation) {

    this.tubeModulus = tubeModulus;
    this.tripodNumber = tripodNumber;

    this.touchLocation = touchLocation;
  }


  void display() {

    pushMatrix();
    translate(this.tubeModulus * (numLEDsPerTube * rectWidth) + (this.tubeModulus * 20 + 20), this.tripodNumber * 21 + 21);
    
    pushStyle();
    
    fill(255);

    if (this.touchLocation == 0) {
      rect(0, 0, tubeLength/2, rectHeight);
    }

    if (this.touchLocation == 1) {
      rect(tubeLength/2, 0, tubeLength/2, rectHeight);
    }
    
    popStyle();
    popMatrix();
  }
}
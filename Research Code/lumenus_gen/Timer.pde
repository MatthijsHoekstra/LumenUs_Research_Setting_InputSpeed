class Timer {

  int tubeModulus;
  int tripodNumber;
  int sideTouch;

  private int timeStart;

  Timer(int tubeModulus, int tripodNumber, int sideTouch) {
    this.tubeModulus = tubeModulus;
    this.tripodNumber = tripodNumber;

    this.sideTouch = sideTouch;

    timeStart = millis();
  }

  void logTime() {

    int timeEnd = millis();

    int totalTouchTime = timeEnd - timeStart;

    if (!displayGreenTransition) {

      logTestPerson.println(timeStart + "," + totalTouchTime + ",location," + this.tripodNumber + "," + this.tubeModulus + "," + this.sideTouch);  

      println("touch logged, time touched: " + timeStart + "," + totalTouchTime + ",location," + this.tripodNumber + "," + this.tubeModulus + "," + this.sideTouch);
    }
  }
}
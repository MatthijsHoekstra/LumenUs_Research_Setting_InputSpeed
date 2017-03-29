class Timer{
 
  int tubeModulus;
  int tripodNumber;
  int sideTouch;
  
  int timeStart;
  
  Timer(int tubeModulus, int tripodNumber, int sideTouch){
   this.tubeModulus = tubeModulus;
   this.tripodNumber = tripodNumber;
   
   this.sideTouch = sideTouch;
   
   timeStart = millis();
  }
  
  void logTime(){
    
    int timeEnd = millis();
    
    int totalTouchTime = timeEnd - timeStart;
    
    logTestPerson.println(totalTouchTime);  
    
    println("touch logged, time touched: " + totalTouchTime);
  }
}
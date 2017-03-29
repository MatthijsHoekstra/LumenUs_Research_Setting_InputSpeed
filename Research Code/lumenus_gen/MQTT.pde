import mqtt.*;

MQTTClient client;

String[] receivedMQTT = new String[6];

int tripodNumberReceived; 
int tubeModulusReceived;
int tubeNumberReceived;
int sideTouchedReceived;
int payLoadReceived;

void messageReceived(String topic, byte[] payload) {

  String[] receivedMQTT = split(topic, '/');

  tripodNumberReceived = Integer.parseInt(receivedMQTT[1]);

  tubeModulusReceived = Integer.parseInt(receivedMQTT[3]);

  sideTouchedReceived = Integer.parseInt(receivedMQTT[5]);
  
  println(tripodNumberReceived + "," + tubeModulusReceived + "," + sideTouchedReceived);

  payLoadReceived = int(payload[0]) - 48;

  tubeNumberReceived = tripodNumberReceived*3 + tubeModulusReceived;

  if (tripodNumberReceived % 2 == 0) {
    if (payLoadReceived == 1) {
      tubes[tubeNumberReceived].isTouched(sideTouchedReceived);
    }

    if (payLoadReceived == 0) {
      tubes[tubeNumberReceived].isUnTouched(sideTouchedReceived);
    }
  } else {

    if (sideTouchedReceived == 0) {
      sideTouchedReceived = 1;
    } else {
      sideTouchedReceived = 0;
    }

    if (payLoadReceived == 1) {
      tubes[tubeNumberReceived].isTouched(sideTouchedReceived);
    }

    if (payLoadReceived == 0) {
      tubes[tubeNumberReceived].isUnTouched(sideTouchedReceived);
    }
  }
}
void addData(int[][] array, int newValue, int timestamp) {
    for (int i = 0; i < array.length - 1; i++) {
        array[i][0] = array[i + 1][0];
        array[i][1] = array[i + 1][1];
    }
    array[array.length - 1][0] = newValue;
    array[array.length - 1][1] = timestamp;
}

void mousePressed() {
    if (mouseX > 970 && mouseX < 1220 && mouseY > 400 && mouseY < 450) {
        inSpeedMode = true;
    } else if (inSpeedMode && mouseX > 200 && mouseX < 450 && mouseY > 900 && mouseY < 950) {
        inSpeedMode = false;
    }
}
void resetData() {

    for (int i = 0; i < 500; i++) {
        uvData[i][0] = int(random(0, 0));
        fsrData[i][0] = int(random(0, 0));
        tempData[i][0] = int(random(0, 0));
        humidityData[i][0] = int(random(0, 0));
        int timestamp = millis();
        uvData[i][1] = timestamp;
        fsrData[i][1] = timestamp;
        tempData[i][1] = timestamp;
        humidityData[i][1] = timestamp;
    }
}


String getCurrentTime() {
    LocalTime now = LocalTime.now();
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm:ss");
    return now.format(formatter);
}

float ecgTime = 0;

void simulateSerialInput() {
    if (millis() - lastSimulatedTime > simulateInterval) {
        lastSimulatedTime = millis();

        int uvValue = int(random(1, 10));
        int fsrValue = int(random(0, 975));
        int tempValue = int(random(0, 121));
        int humidityValue = int(random(0, 101));
        int xValue = int(random(-10, 10));
        int yValue = int(random(100, 1000));
        int zValue = int(random(-10, 10));
        float seconds = (millis() - ecgTime) / 1000.0; 
        float ecgSignal = 200 * sin(TWO_PI * 1.0 * seconds) + 600; 
        int ecgValue = int(ecgSignal + random(-10, 10));



        String simulatedData = uvValue + "," + fsrValue + "," + tempValue + "," + humidityValue + "," + xValue + "," + yValue + "," + zValue + "," + ecgValue;

        processSensorData(simulatedData);
    }
}

void determineCardioZone() {
    if (BPM < 0.5 * 220) {
        cardioZone = "Resting";
    } else if (BPM < 0.6 * 220) {
        cardioZone = "Fat Burn";
    } else if (BPM < 0.8 * 220) {
        cardioZone = "Cardio";
    } else {
        cardioZone = "Peak";
    }

    println("Current Cardio Zone: " + cardioZone);
}

ArrayList < HeartRateData > heartRateHistory = new ArrayList < HeartRateData > ();

class HeartRateData {
    int timestamp;
    float BPM;
    String zone;

    HeartRateData(int timestamp, float BPM, String zone) {
        this.timestamp = timestamp;
        this.BPM = BPM;
        this.zone = zone;
    }
}

void updateHeartRateHistory() {
    int currentTime = millis();
    determineCardioZone(); // Update the current cardio zone
    heartRateHistory.add(new HeartRateData(currentTime, BPM, cardioZone));
    for (HeartRateData data: heartRateHistory) {
        if (data.BPM > maxBPM) {
            maxBPM = data.BPM;
        }
    }

}

void averages() {
    int currentTime = millis();

    if (!restingHRCalculated && (currentTime - start30Sec) >= 30000) {
        if (beatCount > 0) {
            restingBPM = beatCount * 2; // Calculate resting BPM after 30 seconds
            println("Resting BPM: " + restingBPM);
            restingHRCalculated = true;
        } else {
            println("No beats detected for resting BPM calculation.");
        }
    }

}

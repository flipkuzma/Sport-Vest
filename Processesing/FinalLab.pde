import processing.serial.*;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.Collections;


PImage bgImage;

Serial myPort;

//ECG and BPM variables
int lastBeatTime = 0;
int start30Sec = 0;
int beatCount = 0;
float BPM = 0;
boolean belowThreshold = true;
String cardioZone = "";
boolean restingHRCalculated = false;
float restingBPM = 0;
float maxBPM = 0;

// Graph settings
int graphWidth = 800;
int graphHeight = 150;
int graphX = 100;
int graphYStart = 100;
int graphSpacing = 60;

// Colors for each sensor
color bgColor = color(30, 30, 30);
color textColor = color(255);
color uvColor = color(255, 99, 71);
color fsrColor = color(50, 205, 50);
color tempColor = color(70, 130, 180);
color humidityColor = color(255, 165, 0);

// Data arrays for sensors
int[][] uvData = new int[500][2];
int[][] fsrData = new int[500][2];
int[][] tempData = new int[500][2];
int[][] humidityData = new int[500][2];
int[][] ecgData = new int[500][2];
String tempZone;
boolean inSpeedMode = false;
boolean safeUV = true;

//Hit and time Variables
boolean hitDetected = false;
boolean hitShown = false;
int hitForce = 0;
String currentTime1 = "00:00:00";
ArrayList < String > timeList = new ArrayList < String > ();
int activityTime = 0;
int currentTime2 = 0;
int activeTime = 0;

//Simulation variables
int simulateInterval = 100;
int lastSimulatedTime = 0;


void setup() {
    size(1800, 1000);
    smooth();

    myPort = new Serial(this, Serial.list()[0], 115200);
    myPort.bufferUntil('\n');

    textFont(createFont("Arial", 16), 16);
    bgImage = loadImage("chestv2.png");
    //resetData();
}

void draw() {
    background(bgColor);
    if (!inSpeedMode) {
        //simulateSerialInput();
        drawInfoPanel();
        drawGraphs();
        drawImage();
        drawHeatmap();
        drawHitList();
    } else {
        //simulateSerialInput();
        drawSpeedMode();
        averages();
    }
}



void serialEvent(Serial myPort) {
    String input = myPort.readStringUntil('\n');
    if (input != null) {
        processSensorData(trim(input));
    }
}

void processSensorData(String tempVal) {
    String[] values = split(tempVal, ",");
    if (values.length >= 5) {
        if (start30Sec == 0) {
            start30Sec = millis();
            println("Timer started at: " + start30Sec);
            beatCount = 0;
        }
        try {
            int uvValue = Math.round(int(values[0]));
            int fsrValue = int(values[1]);
            int tempValue = int(values[2]);
            int humidityValue = int(values[3]);
            int ecgValue = int(values[4]);
            int timestamp = millis();

            //Add Data collected for later use
            addData(uvData, uvValue, timestamp);
            addData(fsrData, fsrValue, timestamp);
            addData(tempData, tempValue, timestamp);
            addData(humidityData, humidityValue, timestamp);
            addData(ecgData, ecgValue, timestamp);
            if (ecgValue > 520 && belowThreshold) {
                // Beat detected
                println("Beat detected");
                int currentBeatTime = millis();
                beatCount++;
                if (lastBeatTime > 0) {
                    int interval = currentBeatTime - lastBeatTime;
                    BPM = float(nf(60000.0 / interval, 0, 1));
                    updateHeartRateHistory();
                }

                lastBeatTime = currentBeatTime;
                belowThreshold = false;
            }
            if (ecgValue < 680) {
                belowThreshold = true;
            }


            if (uvValue >= 8) {
                safeUV = false;
            } else {
                safeUV = true;
            }
            //Temp Zones
            if (tempValue < 32) {
                tempZone = "Cold";
            } else if (tempValue < 80) {
                tempZone = "Moderate";
            } else if (tempValue < 120) {
                tempZone = "Hot";
            }
            if (fsrValue > 250) {
                hitDetected = true;
                if (!hitShown) {
                    hitShown = true;
                    currentTime1 = getCurrentTime();
                    timeList.add(currentTime1);
                    hitForce = fsrValue;
                    if (fsrValue > hitForce) {
                        hitForce = fsrValue;
                    }
                }
            } else {
                hitDetected = false;
                hitShown = false;
            }



        } catch (NumberFormatException e) {
            println("Invalid data: " + tempVal);
        }
    }
}

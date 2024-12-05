void drawSpeedMode() {

  stroke(255, 165, 0);
  strokeWeight(2); 
  fill(255, 165, 0);
  rect(200, 900, 250, 50, 10);
  //rect(350, 600, 250, 50,10);
  fill(bgColor);
  textAlign(CENTER, CENTER);
  text("Back", 325, 925);
  
  fill(50);
  rect(200, 100, 400, 300, 15);
  fill(textColor);
  textAlign(LEFT, CENTER);
  textSize(24);
  text("Heart Information", 300, 125);
  textSize(18);
  text("Current BPM: " + BPM, 250, 200);
  text("Max BPM Reached: " + maxBPM, 250, 250);
  text("Current Cardio Zone: " + cardioZone, 250, 300);
  text("Resting BPM (After 30s): " + restingBPM, 250, 350); 
   
  
 textSize(12);
  drawGraph(ecgData, "ECG Signal", uvColor, 700, 100, 200, 1000);

}


void drawInfoPanel() {
    stroke(255, 165, 0);
    strokeWeight(2);

    fill(50);
    rect(950, 100, 300, 375, 15);

    noStroke();
    fill(textColor);
    textSize(22);
    textAlign(LEFT, CENTER);

    text("Main Info", 1050, 130);
    textSize(18);
    text("UV Index: " + (safeUV ? "Safe" : "Unsafe"), 970, 170);
    text("Hit Detected (Force): " + hitForce, 970, 210);
    text("Time of Recent Hit: " + currentTime1, 970, 250);
    text("Temp Zone: " + tempZone, 970, 290);

    // Speed Button
    fill(255, 165, 0);
    rect(970, 400, 250, 50, 10);
    fill(bgColor);
    textAlign(CENTER, CENTER);
    text("Heart Info", 1095, 425);
}

void drawImage() {

    fill(50);
    rect(950, 500, 300, 375, 15);
    image(bgImage, 950, 525, 300, 300);

}

void drawHitList() {

    stroke(255, 165, 0);
    strokeWeight(2);

    fill(50);
    rect(1350, 100, 300, 775, 15);

    noStroke();
    fill(textColor);
    textSize(22);
    textAlign(LEFT, CENTER);
    text("Hit Detection Times", 1400, 120);
    textSize(20);
    textAlign(CENTER, CENTER);
    fill(textColor);

    for (int i = 0; i < timeList.size() - 1; i++) {
        //Max amount of times listed
        if (i > 35) {
            break;
        }
        String time = timeList.get(i);
        text((i + 1) + ". " + time, 1500, 160 + (i * 20));

    }
}

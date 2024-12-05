void drawGraphs() {
    textSize(12);
    textAlign(LEFT, CENTER);
    drawGraph(uvData, "UV Index (0-10+)", uvColor, graphX, graphYStart, 0, 10);
    drawGraph(fsrData, "Force Detection", fsrColor, graphX, graphYStart + (graphHeight + graphSpacing), 0, 1000);
    drawGraph(tempData, "Temperature (°F)", tempColor, graphX, graphYStart + 2 * (graphHeight + graphSpacing), 0, 120);
    drawGraph(humidityData, "Humidity (%)", humidityColor, graphX, graphYStart + 3 * (graphHeight + graphSpacing), 0, 100);
}




void drawGraph(int[][] data, String label, color graphColor, int x, int y, int yMin, int yMax) {
    stroke(255);
    fill(50);
    rect(x, y, graphWidth, graphHeight, 10);
    fill(textColor);
    textAlign(CENTER, CENTER);
    text(label, x + graphWidth / 2, y - 25);

    for (int i = 0; i <= 5; i++) {
        int labelValue = yMin + (i * (yMax - yMin) / 5);
        float yPos = map(i, 0, 5, y + graphHeight, y);
        text(labelValue, x - 10, yPos);
    }

    noFill();
    stroke(graphColor);
    strokeWeight(2);
    beginShape();
    for (int i = 0; i < data.length; i++) {
        int value = data[i][0];
        if (value > 0) {
            float xPos = map(i, 0, data.length - 1, x, x + graphWidth);
            float yPos = map(value, yMin, yMax, y + graphHeight, y);
            vertex(xPos, yPos);
        }
    }
    endShape();
    //Hover Function
    textAlign(CENTER, CENTER);

    if (mouseX > x && mouseX < x + graphWidth && mouseY > y && mouseY < y + graphHeight) {
        int hoverIndex = int(map(mouseX, x, x + graphWidth, 0, data.length - 1));
        int value = data[hoverIndex][0];
        if (value > 0) {
            fill(0, 150);
            rect(mouseX - 25, mouseY - 20, 80, 20, 5);
            fill(textColor);
            text("Value: " + value, mouseX + 15, mouseY - 10);
        }
    }
}

void drawHeatmap() {
    float fsrValue = fsrData[fsrData.length - 1][0]; // Get the latest FSR value

    float maxSize = 100;
    float minSize = 25;
    float size = map(fsrValue, 0, 800, minSize, maxSize);
    size = constrain(size, minSize, maxSize);

    int heatColor = color(0, 0, 255);
    //Transition Colors
    if (fsrValue >= 0) {
        if (fsrValue <= 400) {
            heatColor = lerpColor(color(0, 0, 255), color(255, 255, 0), fsrValue / 400.0);
        } else {
            heatColor = lerpColor(color(255, 255, 0), color(255, 165, 0), (fsrValue - 400) / 200.0);
            if (fsrValue > 600) {
                heatColor = lerpColor(color(255, 165, 0), color(255, 0, 0), (fsrValue - 600) / 200.0);
            }
        }
    }

    fill(heatColor);
    noStroke();
    ellipse(1100, 700, size, size);
}

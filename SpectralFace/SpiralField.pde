int NUM_ARMS = 7;
int POINTS_PER_ARM = 500;
float spiralA = 8.0;
float spiralB = 0.18;
float MAX_THETA = 6.5 * TWO_PI;

void drawSpirals(float noiseTime, boolean inverted) {
  for (int i = 0; i < NUM_ARMS; i++) {
    float armOffset = i * TWO_PI / NUM_ARMS;

    for (int j = 0; j < POINTS_PER_ARM; j++) {
      float t = j / (float) POINTS_PER_ARM;
      float theta = t * MAX_THETA + armOffset;
      float r = spiralA * exp(spiralB * theta);

      float baseX = width / 2.0 + r * cos(theta);
      float baseY = height / 2.0 + r * sin(theta);

      float faceVal = sampleFace(baseX, baseY);
      float displaceFactor = 1.0 - 0.85 * faceVal;

      // 3-octave Perlin noise
      float dx1 = (noise(baseX * 0.008, baseY * 0.008, noiseTime * 0.3) - 0.5) * 80;
      float dy1 = (noise(baseX * 0.008 + 100, baseY * 0.008 + 100, noiseTime * 0.3) - 0.5) * 80;

      float dx2 = (noise(baseX * 0.03, baseY * 0.03, noiseTime * 0.8) - 0.5) * 30;
      float dy2 = (noise(baseX * 0.03 + 200, baseY * 0.03 + 200, noiseTime * 0.8) - 0.5) * 30;

      float dx3 = (noise(baseX * 0.1, baseY * 0.1, noiseTime * 2.0) - 0.5) * 8;
      float dy3 = (noise(baseX * 0.1 + 300, baseY * 0.1 + 300, noiseTime * 2.0) - 0.5) * 8;

      float dx = (dx1 + dx2 + dx3) * displaceFactor;
      float dy = (dy1 + dy2 + dy3) * displaceFactor;

      float finalX = baseX + dx;
      float finalY = baseY + dy;

      float keepProb = 0.3 + 0.7 * faceVal;
      if (random(1.0) > keepProb) continue;

      float alpha = lerp(30, 180, faceVal);
      float radius = lerp(1.5, 3.0, faceVal);

      if (inverted) {
        fill(0, alpha);
      } else {
        fill(255, 180, 40, alpha);
      }
      noStroke();
      ellipse(finalX, finalY, radius, radius);
    }
  }
}

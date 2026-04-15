// Interference Pattern
// Pure trig wave interference with Lissajous-driven sources and micro-glitches.

PGraphics halfRes;
float time = 0.0;
float timeSpeed = 0.02;
float glitchLambda = 1.0 / 240.0;
int glitchType = -1;
int glitchFramesRemaining = 0;

void setup() {
  size(1000, 1000, P2D);
  halfRes = createGraphics(500, 500, P2D);
  buildSinLUT();
  buildPaletteLUT();
  initSources(500.0, 500.0);
}

void draw() {
  time += timeSpeed;
  if (glitchType != 2) {
    updateSources(time, 500.0, 500.0);
  }
  renderWaveField(halfRes, time);
  image(halfRes, 0, 0, 1000, 1000);
  updateGlitch();
}

void updateGlitch() {
  if (glitchFramesRemaining > 0) {
    glitchFramesRemaining--;
    if (glitchFramesRemaining == 0) {
      resetGlitch();
    }
  } else {
    if (random(1.0) < glitchLambda) {
      triggerGlitch((int) random(4));
    }
  }
}

void triggerGlitch(int type) {
  glitchType = type;
  glitchFramesRemaining = (int) random(2, 5);

  switch (type) {
    case 0: // phase blast
      for (int i = 0; i < NUM_SOURCES; i++) {
        srcPhase[i] += random(PI, 4 * PI);
      }
      break;
    case 1: // frequency doubling
      for (int i = 0; i < NUM_SOURCES; i++) {
        srcFreq[i] *= 2.0;
      }
      break;
    case 2: // source scatter -- teleport (updateSources skipped during these frames)
      for (int i = 0; i < NUM_SOURCES; i++) {
        srcX[i] = random(200, 800);
        srcY[i] = random(200, 800);
      }
      break;
    case 3: // palette invert
      paletteInverted = true;
      break;
  }
}

void resetGlitch() {
  glitchType = -1;
  for (int i = 0; i < NUM_SOURCES; i++) {
    srcFreq[i] = srcFreqBase[i];
  }
  paletteInverted = false;
  // scatter positions auto-restore via next updateSources() call
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    saveFrame("InterferencePattern-####.png");
  }
  if (key == 'g' || key == 'G') {
    triggerGlitch((int) random(4));
  }
}

// WarpGrid.pde — Main sketch: warped grid with feedback and glitch system

int GRID_COLS = 80;
int GRID_ROWS = 80;
float WARP_AMOUNT = 150.0;
float WARP_AMOUNT_BASE = 150.0;
float noiseTimeGlobal = 0.0;
float noiseSpeed = 0.003;
PGraphics feedbackBuf;

// Glitch system
float glitchLambda = 1.0 / 200.0;
int glitchType = -1;
int glitchFramesRemaining = 0;
boolean paletteInverted = false;
boolean feedbackFrozen = false;

// Pre-allocated grid cache
PVector[][] warpedGrid;
float[][] intensityGrid;

void setup() {
  size(1000, 1000, P2D);
  noiseSeed((long)random(99999));
  noiseDetail(1);

  feedbackBuf = createGraphics(1000, 1000, P2D);
  feedbackBuf.beginDraw();
  feedbackBuf.background(0);
  feedbackBuf.endDraw();

  warpedGrid = new PVector[GRID_COLS][GRID_ROWS];
  intensityGrid = new float[GRID_COLS][GRID_ROWS];
  for (int r = 0; r < GRID_ROWS; r++) {
    for (int c = 0; c < GRID_COLS; c++) {
      warpedGrid[c][r] = new PVector();
    }
  }
}

void draw() {
  noiseTimeGlobal += noiseSpeed;

  // 1. Capture feedback (before clearing)
  if (!feedbackFrozen) {
    captureFeedback();
  }

  // 2. Clear and draw feedback
  background(0);
  tint(255, 240);
  image(feedbackBuf, 0, 0);
  noTint();

  // 3. Compute warped grid (cached)
  float cellW = (float)width / (GRID_COLS - 1);
  float cellH = (float)height / (GRID_ROWS - 1);
  for (int row = 0; row < GRID_ROWS; row++) {
    for (int col = 0; col < GRID_COLS; col++) {
      float bx = col * cellW;
      float by = row * cellH;
      PVector d = domainWarp(bx, by, noiseTimeGlobal);
      warpedGrid[col][row].set(bx + d.x, by + d.y);
      intensityGrid[col][row] = constrain(d.mag() / WARP_AMOUNT, 0, 1);
    }
  }

  // 4. Draw grid edges
  noFill();
  for (int row = 0; row < GRID_ROWS; row++) {
    for (int col = 0; col < GRID_COLS; col++) {
      float intensity = intensityGrid[col][row];
      strokeWeight(lerp(0.5, 2.5, intensity));
      stroke(fleshColor(intensity));
      if (col < GRID_COLS - 1) {
        line(warpedGrid[col][row].x, warpedGrid[col][row].y,
             warpedGrid[col + 1][row].x, warpedGrid[col + 1][row].y);
      }
      if (row < GRID_ROWS - 1) {
        line(warpedGrid[col][row].x, warpedGrid[col][row].y,
             warpedGrid[col][row + 1].x, warpedGrid[col][row + 1].y);
      }
    }
  }

  // 5. Glitch
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
      triggerGlitch((int)random(4));
    }
  }
}

void triggerGlitch(int type) {
  glitchType = type;
  glitchFramesRemaining = (int)random(2, 5);
  switch (type) {
    case 0:
      noiseTimeGlobal += random(5.0, 20.0);
      break;
    case 1:
      WARP_AMOUNT = WARP_AMOUNT_BASE * 2.5;
      break;
    case 2:
      paletteInverted = true;
      break;
    case 3:
      feedbackFrozen = true;
      break;
  }
}

void resetGlitch() {
  glitchType = -1;
  WARP_AMOUNT = WARP_AMOUNT_BASE;
  paletteInverted = false;
  feedbackFrozen = false;
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    saveFrame("WarpGrid-####.png");
  }
  if (key == 'g' || key == 'G') {
    triggerGlitch((int)random(4));
  }
}

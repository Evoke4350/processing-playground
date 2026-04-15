float glitchLambda = 1.0 / 180.0;
int glitchFlashRemaining = 0;
float glitchCenterDX = 0;
float glitchCenterDY = 0;
float noiseTimeGlobal = 0.0;
float noiseSpeed = 0.004;

void setup() {
  size(1000, 1000, P2D);
  initFaceField();
  noiseSeed((long) random(99999));
  noiseDetail(4, 0.5);
}

void draw() {
  boolean inverted = (glitchFlashRemaining > 0);

  if (inverted) {
    background(255, 180, 40);
  } else {
    background(0);
  }

  noiseTimeGlobal += noiseSpeed;

  pushMatrix();
  translate(glitchCenterDX, glitchCenterDY);
  drawSpirals(noiseTimeGlobal, inverted);
  popMatrix();

  updateGlitch();
}

void updateGlitch() {
  if (glitchFlashRemaining > 0) {
    glitchFlashRemaining--;
    if (glitchFlashRemaining == 0) {
      glitchCenterDX = 0;
      glitchCenterDY = 0;
    }
  } else {
    if (random(1.0) < glitchLambda) {
      noiseTimeGlobal += random(5.0, 20.0);
      glitchFlashRemaining = (int) random(1, 4);
      glitchCenterDX = random(-15, 15);
      glitchCenterDY = random(-15, 15);
    }
  }
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    saveFrame("SpectralFace-####.png");
  }
  if (key == 'g' || key == 'G') {
    noiseTimeGlobal += random(5.0, 20.0);
    glitchFlashRemaining = (int) random(1, 4);
    glitchCenterDX = random(-15, 15);
    glitchCenterDY = random(-15, 15);
  }
}

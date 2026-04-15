int NUM_PARTICLES = 1000;
float SPHERE_RADIUS = 300;
float MAX_CONN_RADIUS = 60;
float noiseTimeGlobal = 0.0;
float noiseSpeed = 0.004;

// Glitch
float glitchLambda = 1.0 / 300.0;
int glitchType = -1;  // -1=none, 0=cameraShake, 1=meshShatter, 2=paletteInvert, 3=noiseJump
int glitchFramesRemaining = 0;
float glitchShakeTheta = 0;
float glitchShakePhi = 0;
boolean glitchInverted = false;
float glitchShrinkRadius = 5;

Particle[] particles;
MeshConnector mesh;
Camera cam;

void setup() {
  size(1000, 1000, P3D);
  hint(DISABLE_DEPTH_TEST);
  noiseSeed((long)random(99999));
  noiseDetail(4, 0.5);

  particles = new Particle[NUM_PARTICLES];
  for (int i = 0; i < NUM_PARTICLES; i++) {
    particles[i] = new Particle(
      random(-SPHERE_RADIUS, SPHERE_RADIUS),
      random(-SPHERE_RADIUS, SPHERE_RADIUS),
      random(-SPHERE_RADIUS, SPHERE_RADIUS)
    );
    particles[i].clampToSphere();
  }

  mesh = new MeshConnector(MAX_CONN_RADIUS);
  cam = new Camera(600, 0.003);
}

void draw() {
  boolean inverted = glitchInverted;
  background(inverted ? color(255, 180, 40) : color(0));

  noiseTimeGlobal += noiseSpeed;

  cam.update();
  cam.apply(glitchShakeTheta, glitchShakePhi);

  for (int i = 0; i < particles.length; i++) {
    particles[i].update(noiseTimeGlobal);
  }

  mesh.buildGrid(particles);

  float overrideR = (glitchType == 1 && glitchFramesRemaining > 0) ? glitchShrinkRadius : -1;
  mesh.drawEdges(particles, noiseTimeGlobal, inverted, overrideR);

  drawParticleDots(inverted);
  updateGlitch();
}

void drawParticleDots(boolean inverted) {
  strokeWeight(2);
  for (int i = 0; i < particles.length; i++) {
    Particle p = particles[i];
    if (inverted) {
      stroke(0, 60);
    } else {
      stroke(255, 180, 40, 60);
    }
    point(p.pos.x, p.pos.y, p.pos.z);
  }
}

void updateGlitch() {
  if (glitchFramesRemaining > 0) {
    glitchFramesRemaining--;
    if (glitchFramesRemaining == 0) {
      resetGlitch();
    }
  } else {
    if (random(1.0) < glitchLambda) {
      triggerGlitch();
    }
  }
}

void triggerGlitch() {
  int type = (int)random(4);
  glitchType = type;
  glitchFramesRemaining = (int)random(2, 5);

  switch (type) {
    case 0:
      glitchShakeTheta = random(-0.15, 0.15);
      glitchShakePhi = random(-0.1, 0.1);
      break;
    case 1:
      // Mesh shatter — handled by overrideRadius in draw
      break;
    case 2:
      glitchInverted = true;
      break;
    case 3:
      noiseTimeGlobal += random(5.0, 20.0);
      break;
  }
}

void resetGlitch() {
  glitchType = -1;
  glitchShakeTheta = 0;
  glitchShakePhi = 0;
  glitchInverted = false;
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    saveFrame("GranularMesh-####.png");
  }
  if (key == 'g' || key == 'G') {
    triggerGlitch();
  }
}

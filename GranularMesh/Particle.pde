class Particle {
  PVector pos, vel;
  float noiseSeedX, noiseSeedY, noiseSeedZ;
  float connectionRadius;

  Particle(float x, float y, float z) {
    pos = new PVector(x, y, z);
    vel = new PVector(0, 0, 0);
    noiseSeedX = random(0, 1000);
    noiseSeedY = random(1000, 2000);
    noiseSeedZ = random(2000, 3000);
    connectionRadius = 30;
  }

  void update(float noiseTime) {
    float scale = 0.005;

    float dx = (noise(pos.x * scale + noiseSeedX, pos.y * scale, noiseTime) - 0.5) * 2.0;
    float dy = (noise(pos.x * scale, pos.y * scale + noiseSeedY, noiseTime) - 0.5) * 2.0;
    float dz = (noise(pos.x * scale, pos.y * scale, noiseTime + noiseSeedZ) - 0.5) * 2.0;

    vel.set(dx, dy, dz);
    pos.add(vel);

    // Soft sphere boundary
    float mag = pos.mag();
    if (mag > SPHERE_RADIUS) {
      float overshoot = (mag - SPHERE_RADIUS) / SPHERE_RADIUS;
      float pushStrength = min(overshoot * overshoot * overshoot, 1.0) * -5;
      PVector push = pos.copy().normalize().mult(pushStrength);
      pos.add(push);
    }

    // Localized breathing
    connectionRadius = map(noise(pos.x * 0.01, pos.y * 0.01, noiseTime * 1.25), 0, 1, 15, 60);
  }

  void clampToSphere() {
    if (pos.mag() > SPHERE_RADIUS) {
      pos.normalize();
      pos.mult(random(SPHERE_RADIUS * 0.5, SPHERE_RADIUS));
    }
  }
}

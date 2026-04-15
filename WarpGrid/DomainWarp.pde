// DomainWarp.pde — FBM noise, domain warping, and flesh color palette

final float NOISE_SCALE = 0.003;

float fbm(float x, float y, float t) {
  float sum = 0.0;
  float amp = 1.0;
  float freq = 1.0;
  float maxAmp = 0.0;

  for (int i = 0; i < 4; i++) {
    float val = noise(x * freq, y * freq, t * freq) * 2.0 - 1.0;
    sum += amp * val;
    maxAmp += amp;
    amp *= 0.5;
    freq *= 2.0;
  }

  return sum / maxAmp;
}

PVector domainWarp(float x, float y, float t) {
  float nx = x * NOISE_SCALE;
  float ny = y * NOISE_SCALE;

  // Layer 1
  float qx = fbm(nx, ny, t);
  float qy = fbm(nx + 5.2, ny + 1.3, t);

  // Layer 2
  float rx = fbm(nx + 4.0 * qx + 1.7, ny + 4.0 * qy + 9.2, t);
  float ry = fbm(nx + 4.0 * qx + 8.3, ny + 4.0 * qy + 2.8, t);

  // Layer 3
  float dx = fbm(nx + 4.0 * rx, ny + 4.0 * ry, t);
  float dy = fbm(nx + 4.0 * rx + 3.7, ny + 4.0 * ry + 7.1, t);

  return new PVector(dx * WARP_AMOUNT, dy * WARP_AMOUNT);
}

color fleshColor(float t) {
  float tt = paletteInverted ? (1.0 - t) : t;
  tt = constrain(tt, 0.0, 1.0);

  color c0 = color(15, 8, 8);
  color c1 = color(120, 30, 20);
  color c2 = color(210, 140, 120);
  color c3 = color(240, 200, 195);
  color c4 = color(255, 252, 250);

  if (tt < 0.25) {
    return lerpColor(c0, c1, tt / 0.25);
  } else if (tt < 0.50) {
    return lerpColor(c1, c2, (tt - 0.25) / 0.25);
  } else if (tt < 0.75) {
    return lerpColor(c2, c3, (tt - 0.50) / 0.25);
  } else {
    return lerpColor(c3, c4, (tt - 0.75) / 0.25);
  }
}

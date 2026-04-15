// --- Sin LUT & Palette LUT ---

final int SIN_LUT_SIZE = 4096;
float SIN_LUT_SCALE;
float[] sinLUT = new float[SIN_LUT_SIZE];

final int PAL_SIZE = 256;
color[] paletteLUT = new color[PAL_SIZE];
boolean paletteInverted = false;

void buildSinLUT() {
  SIN_LUT_SCALE = SIN_LUT_SIZE / TWO_PI;
  for (int i = 0; i < SIN_LUT_SIZE; i++) {
    sinLUT[i] = sin(i * TWO_PI / SIN_LUT_SIZE);
  }
}

float sinFast(float angle) {
  int idx = (int)(angle * SIN_LUT_SCALE);
  idx = ((idx % SIN_LUT_SIZE) + SIN_LUT_SIZE) % SIN_LUT_SIZE;
  return sinLUT[idx];
}

void buildPaletteLUT() {
  color c0 = color(5, 2, 20);        // deep indigo
  color c1 = color(20, 40, 120);     // deep blue
  color c2 = color(40, 160, 200);    // cyan
  color c3 = color(160, 140, 220);   // lavender
  color c4 = color(245, 245, 255);   // near-white

  for (int i = 0; i < PAL_SIZE; i++) {
    float t = i / 255.0;
    if (t < 0.25) {
      paletteLUT[i] = lerpColor(c0, c1, t / 0.25);
    } else if (t < 0.50) {
      paletteLUT[i] = lerpColor(c1, c2, (t - 0.25) / 0.25);
    } else if (t < 0.75) {
      paletteLUT[i] = lerpColor(c2, c3, (t - 0.50) / 0.25);
    } else {
      paletteLUT[i] = lerpColor(c3, c4, (t - 0.75) / 0.25);
    }
  }
}

color spectralColor(float t) {
  float tt = paletteInverted ? (1.0 - t) : t;
  tt = constrain(tt, 0.0, 1.0);
  return paletteLUT[(int)(tt * 255)];
}

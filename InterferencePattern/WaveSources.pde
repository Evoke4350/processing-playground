// --- Wave Sources (parallel arrays, no class) ---

final int NUM_SOURCES = 5;
float[] srcX = new float[NUM_SOURCES];
float[] srcY = new float[NUM_SOURCES];
float[] srcFreq = new float[NUM_SOURCES];
float[] srcPhase = new float[NUM_SOURCES];
float[] srcAmpX = new float[NUM_SOURCES];
float[] srcAmpY = new float[NUM_SOURCES];
float[] srcRatioX = new float[NUM_SOURCES];
float[] srcRatioY = new float[NUM_SOURCES];
float[] srcPhaseX = new float[NUM_SOURCES];
float[] srcPhaseY = new float[NUM_SOURCES];
float[] srcFreqBase = new float[NUM_SOURCES];

void initSources(float cx, float cy) {
  // Source 0
  srcAmpX[0]=150; srcAmpY[0]=120; srcRatioX[0]=2.0;   srcRatioY[0]=3.017; srcPhaseX[0]=0;    srcPhaseY[0]=0;    srcFreq[0]=0.04;
  // Source 1
  srcAmpX[1]=100; srcAmpY[1]=180; srcRatioX[1]=1.0;   srcRatioY[1]=1.618; srcPhaseX[1]=1.31; srcPhaseY[1]=1.31; srcFreq[1]=0.048;
  // Source 2
  srcAmpX[2]=180; srcAmpY[2]=90;  srcRatioX[2]=3.0;   srcRatioY[2]=2.236; srcPhaseX[2]=2.62; srcPhaseY[2]=2.62; srcFreq[2]=0.056;
  // Source 3
  srcAmpX[3]=130; srcAmpY[3]=160; srcRatioX[3]=1.414; srcRatioY[3]=2.0;   srcPhaseX[3]=3.93; srcPhaseY[3]=3.93; srcFreq[3]=0.064;
  // Source 4
  srcAmpX[4]=160; srcAmpY[4]=140; srcRatioX[4]=2.618; srcRatioY[4]=1.732; srcPhaseX[4]=5.24; srcPhaseY[4]=5.24; srcFreq[4]=0.072;

  for (int i = 0; i < NUM_SOURCES; i++) {
    srcFreqBase[i] = srcFreq[i];
    srcPhase[i] = i * 0.7;
  }
}

void updateSources(float time, float cx, float cy) {
  for (int i = 0; i < NUM_SOURCES; i++) {
    srcX[i] = cx + srcAmpX[i] * sinFast(srcRatioX[i] * time + srcPhaseX[i]);
    srcY[i] = cy + srcAmpY[i] * sinFast(srcRatioY[i] * time + srcPhaseY[i]);
  }
}

void renderWaveField(PGraphics pg, float time) {
  pg.beginDraw();
  pg.loadPixels();
  int w = pg.width;
  int h = pg.height;
  float scale = 1000.0 / w;

  for (int y = 0; y < h; y++) {
    for (int x = 0; x < w; x++) {
      float wx = x * scale;
      float wy = y * scale;
      float sum = 0;
      for (int i = 0; i < NUM_SOURCES; i++) {
        float dx = wx - srcX[i];
        float dy = wy - srcY[i];
        float d = sqrt(dx * dx + dy * dy);
        sum += sinFast(d * srcFreq[i] + srcPhase[i] + time);
      }
      float t = (sum / NUM_SOURCES + 1.0) * 0.5;
      pg.pixels[y * w + x] = spectralColor(t);
    }
  }
  pg.updatePixels();
  pg.endDraw();
}

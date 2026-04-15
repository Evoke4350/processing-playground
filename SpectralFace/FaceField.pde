float[][] faceField;
int faceGridW, faceGridH;

void initFaceField() {
  faceGridW = width;
  faceGridH = height;
  faceField = new float[faceGridW][faceGridH];

  float faceCenterX = width / 2.0;
  float faceCenterY = height * 0.382;

  // Head
  addEllipse(faceCenterX, faceCenterY, 180, 240, 0.5);
  // Left eye
  addEllipse(faceCenterX - 65, faceCenterY - 30, 35, 22, 1.0);
  // Right eye
  addEllipse(faceCenterX + 65, faceCenterY - 30, 35, 22, 1.0);
  // Nose
  addEllipse(faceCenterX, faceCenterY + 30, 25, 50, 0.7);
  // Mouth
  addEllipse(faceCenterX, faceCenterY + 90, 55, 20, 0.8);
  // Left brow
  addEllipse(faceCenterX - 65, faceCenterY - 65, 50, 12, 0.6);
  // Right brow
  addEllipse(faceCenterX + 65, faceCenterY - 65, 50, 12, 0.6);
  // Left cheek
  addEllipse(faceCenterX - 90, faceCenterY + 30, 45, 40, 0.4);
  // Right cheek
  addEllipse(faceCenterX + 90, faceCenterY + 30, 45, 40, 0.4);

  // Normalize
  float maxVal = 0.0;
  for (int x = 0; x < faceGridW; x++) {
    for (int y = 0; y < faceGridH; y++) {
      if (faceField[x][y] > maxVal) {
        maxVal = faceField[x][y];
      }
    }
  }
  if (maxVal > 0.0) {
    for (int x = 0; x < faceGridW; x++) {
      for (int y = 0; y < faceGridH; y++) {
        faceField[x][y] /= maxVal;
      }
    }
  }
}

void addEllipse(float cx, float cy, float rx, float ry, float strength) {
  int xMin = max(0, (int)(cx - rx * 3));
  int xMax = min(faceGridW - 1, (int)(cx + rx * 3));
  int yMin = max(0, (int)(cy - ry * 3));
  int yMax = min(faceGridH - 1, (int)(cy + ry * 3));

  for (int x = xMin; x <= xMax; x++) {
    for (int y = yMin; y <= yMax; y++) {
      float dx = (x - cx) / rx;
      float dy = (y - cy) / ry;
      float d = dx * dx + dy * dy;
      if (d < 9.0) {
        faceField[x][y] += strength * exp(-d * 0.5);
      }
    }
  }
}

float sampleFace(float x, float y) {
  int ix = (int) x;
  int iy = (int) y;
  if (ix < 0 || ix >= faceGridW || iy < 0 || iy >= faceGridH) {
    return 0.0;
  }
  return faceField[ix][iy];
}

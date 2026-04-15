class Camera {
  float camRadius;
  float camTheta = 0;
  float camPhi = 0;
  float orbitSpeed;

  Camera(float radius, float orbitSpeed) {
    this.camRadius = radius;
    this.orbitSpeed = orbitSpeed;
  }

  void update() {
    camTheta += orbitSpeed;
    camPhi = sin(frameCount * 0.001) * 0.3;
  }

  void apply(float shakeTheta, float shakePhi) {
    float theta = camTheta + shakeTheta;
    float phi = camPhi + shakePhi;

    float eyeX = camRadius * cos(phi) * sin(theta);
    float eyeY = camRadius * sin(phi);
    float eyeZ = camRadius * cos(phi) * cos(theta);

    camera(eyeX, eyeY, eyeZ, 0, 0, 0, 0, 1, 0);
  }
}

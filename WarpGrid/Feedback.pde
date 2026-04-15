// Feedback.pde — Feedback buffer capture with slow zoom and drift

void captureFeedback() {
  feedbackBuf.beginDraw();
  feedbackBuf.pushMatrix();

  float cx = width / 2.0;
  float cy = height / 2.0;

  feedbackBuf.translate(cx, cy);
  feedbackBuf.scale(1.002);

  float driftX = (noise(noiseTimeGlobal * 0.5, 0) - 0.5) * 1.0;
  float driftY = (noise(0, noiseTimeGlobal * 0.5) - 0.5) * 1.0;

  feedbackBuf.translate(-cx + driftX, -cy + driftY);
  feedbackBuf.tint(255, 235);
  feedbackBuf.image(get(), 0, 0);
  feedbackBuf.noTint();

  feedbackBuf.popMatrix();
  feedbackBuf.endDraw();
}

class MeshConnector {
  float cellSize;
  HashMap<Long, ArrayList<Integer>> grid;
  float gridOffset = 500;
  int[] particleGX, particleGY, particleGZ;

  MeshConnector(float cellSize) {
    this.cellSize = cellSize;
    grid = new HashMap<Long, ArrayList<Integer>>();
  }

  long hashKey(int gx, int gy, int gz) {
    return ((long)(gx + 1000)) * 10000L * 10000L + ((long)(gy + 1000)) * 10000L + (long)(gz + 1000);
  }

  void buildGrid(Particle[] particles) {
    grid.clear();

    if (particleGX == null || particleGX.length != particles.length) {
      particleGX = new int[particles.length];
      particleGY = new int[particles.length];
      particleGZ = new int[particles.length];
    }

    for (int i = 0; i < particles.length; i++) {
      Particle p = particles[i];
      int gx = floor((p.pos.x + gridOffset) / cellSize);
      int gy = floor((p.pos.y + gridOffset) / cellSize);
      int gz = floor((p.pos.z + gridOffset) / cellSize);

      particleGX[i] = gx;
      particleGY[i] = gy;
      particleGZ[i] = gz;

      long key = hashKey(gx, gy, gz);
      ArrayList<Integer> cell = grid.get(key);
      if (cell == null) {
        cell = new ArrayList<Integer>();
        grid.put(key, cell);
      }
      cell.add(i);
    }
  }

  void drawEdges(Particle[] particles, float noiseTime, boolean inverted, float overrideRadius) {
    noFill();

    for (int i = 0; i < particles.length; i++) {
      int gx = particleGX[i];
      int gy = particleGY[i];
      int gz = particleGZ[i];
      Particle a = particles[i];
      float radiusA = (overrideRadius > 0) ? overrideRadius : a.connectionRadius;

      for (int ddx = -1; ddx <= 1; ddx++) {
        for (int ddy = -1; ddy <= 1; ddy++) {
          for (int ddz = -1; ddz <= 1; ddz++) {
            long nKey = hashKey(gx + ddx, gy + ddy, gz + ddz);
            ArrayList<Integer> neighbors = grid.get(nKey);
            if (neighbors == null) continue;

            for (int ni = 0; ni < neighbors.size(); ni++) {
              int j = neighbors.get(ni);
              if (j <= i) continue;

              Particle b = particles[j];
              float radiusB = (overrideRadius > 0) ? overrideRadius : b.connectionRadius;
              float maxR = max(radiusA, radiusB);
              float d = PVector.dist(a.pos, b.pos);

              if (d < maxR) {
                float alpha = map(d, 0, maxR, 120, 20);
                float edgeSeed = noise(i * 0.1, j * 0.1, noiseTime * 0.5);
                float sw = map(edgeSeed, 0, 1, 0.5, 2.0);
                strokeWeight(sw);

                if (inverted) {
                  stroke(0, alpha);
                } else {
                  stroke(255, 180, 40, alpha);
                }

                line(a.pos.x, a.pos.y, a.pos.z, b.pos.x, b.pos.y, b.pos.z);
              }
            }
          }
        }
      }
    }
  }
}

int mapWidth = 10;
int mapHeight = 10;
int cellSize = 64;
int[][] map = {
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 1, 1, 0, 1, 1, 0, 0, 1},
  {1, 0, 1, 1, 0, 1, 1, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 1, 1, 1, 1, 0, 0, 1},
  {1, 0, 0, 1, 0, 0, 1, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 0, 0, 0, 0, 0, 0, 0, 0, 1},
  {1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
};

// Starting position and angle
float playerX = 1 * cellSize + cellSize / 2;
float playerY = 1 * cellSize + cellSize / 2;
float playerAngle = 0; // Facing east

float fov = PI / 3;
int numRays = 300;

boolean moveForward = false;
boolean moveBackward = false;
boolean turnLeft = false;
boolean turnRight = false;

void setup() {
  size(600, 400);
}

void draw() {
  background(0);
  float angleStep = fov / numRays;
  for (int i = 0; i < numRays; i++) {
    float rayAngle = playerAngle - fov / 2 + i * angleStep;
    castRay(rayAngle, i);
  }
  handleInput();
}

void castRay(float rayAngle, int rayIndex) {
  float rayX = playerX;
  float rayY = playerY;
  float rayDirX = cos(rayAngle);
  float rayDirY = sin(rayAngle);

  while (true) {
    rayX += rayDirX;
    rayY += rayDirY;
    int mapX = int(rayX / cellSize);
    int mapY = int(rayY / cellSize);

    if (mapX < 0 || mapX >= mapWidth || mapY < 0 || mapY >= mapHeight) break;
    if (map[mapX][mapY] == 1) {
      float distance = dist(playerX, playerY, rayX, rayY);
      drawWall(rayIndex, distance, rayAngle);
      break;
    }
  }
}

void drawWall(int rayIndex, float distance, float rayAngle) {
  float correctedDistance = distance * cos(rayAngle - playerAngle);
  float wallHeight = (cellSize * height) / correctedDistance;
  float x = rayIndex * (width / numRays);
  float y1 = height / 2 - wallHeight / 2;
  float y2 = height / 2 + wallHeight / 2;

  // Draw ceiling
  fill(50);
  rect(x, 0, width / numRays, y1);

  // Draw floor
  fill(100);
  rect(x, y2, width / numRays, height - y2);

  // Improved wall shading
  float wallColor = map(correctedDistance, 0, width, 255, 50); // Darker color for distant walls
  fill(wallColor);
  noStroke();
  rect(x, y1, width / numRays, wallHeight);
}

void handleInput() {
  if (moveForward) {
    playerX += cos(playerAngle) * 2;
    playerY += sin(playerAngle) * 2;
  }
  if (moveBackward) {
    playerX -= cos(playerAngle) * 2;
    playerY -= sin(playerAngle) * 2;
  }
  if (turnLeft) {
    playerAngle -= 0.05;
  }
  if (turnRight) {
    playerAngle += 0.05;
  }
}

void keyPressed() {
  if (key == 'w') {
    moveForward = true;
  }
  if (key == 's') {
    moveBackward = true;
  }
  if (key == 'a') {
    turnLeft = true;
  }
  if (key == 'd') {
    turnRight = true;
  }
}

void keyReleased() {
  if (key == 'w') {
    moveForward = false;
  }
  if (key == 's') {
    moveBackward = false;
  }
  if (key == 'a') {
    turnLeft = false;
  }
  if (key == 'd') {
    turnRight = false;
  }
}

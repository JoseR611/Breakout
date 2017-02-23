float [] wallColor = {random(255), random(255), random(255)};
int m = 5;
int h = 100/m;
int n = 10;
int w = 400/n;
boolean [][] blocksVisible = new boolean [n][m];
float speedX = random(-3,3);
float speedY = 3;
float ballX = 0;
float ballY = 350;
int click = 0;
int lives = 3;
int restart = 0;
int point = 0;
int level = 1;
void setup(){
  size(400,400);
  background(wallColor[0],wallColor[1],wallColor[2]);
  for(int i = 0; i < blocksVisible.length; i++){
    for(int j = 0; j < blocksVisible[i].length; j++){
      rect(i * w, j * h + 100, w, h);
      blocksVisible[i][j] = true;
    }
  }
}

void draw(){
  background(wallColor[0], wallColor[1], wallColor[2]);
  bricks();
  stroke(0);
  fill(0, 0, 255);//paddle
  rect(mouseX - 25, 360, 50, 10);//paddle  
  fill(0, 255, 0);//ball
  if(click == 0){
    ballX = mouseX;
    ellipse(ballX, ballY, 16, 16);
  }else if(click >= 1){
    ballX = ballX + speedX;
    ballY = ballY + speedY;
    hitRect(); 
    if(ballX >= 390 || ballX <= 10){
      hitSideWalls(); //<>//
    }else if((ballY >= 352 && ballY <= 364 && (ballX >= mouseX - 40 && ballX <= mouseX + 40)) || ballY <= 10){
      topWallPaddle();
    }
    if(ballY >= 400 ){ //<>//
      lives--;
      click = 0; 
      ballY = 350; //<>//
      speedY = speedY * -1;
    } //<>//
    ellipse(ballX, ballY, 16, 16);
  }//ball
  int win = 0;
  for(int i = 0; i < blocksVisible.length; i++){
    for(int j = 0; j < blocksVisible[i].length; j++){
      if(!blocksVisible[i][j]){
        win++;
      }
    }
  }
  if(win == 50 || lives == 0){
    textSize(15);
    background(0);
    if(lives == 0){
      fill(random(255),random(255),random(255));
      for(int i = 0; i <= 10; i++){
        text("GAME OVER", random(400), random(400));
      }
      ballX = 200;
      ballY = 300;
    }
    if(win == 50){
      fill(random(255),random(255),random(255));
      text("You Won!!!", 100,100);
    }
    text("Points Earned:" + point, 100, 200);
    restart++;
    if(restart < 600){
      textSize(20);
      fill(255);
      text("Restarting in 10 seconds...",100,300);
    }
    if(restart == 600){
    background(wallColor[0],wallColor[1],wallColor[2]);
    for(int i = 0; i < blocksVisible.length; i++){
      for(int j = 0; j < blocksVisible[i].length; j++){
        rect(i * w, j * h + 100, w, h);
        blocksVisible[i][j] = true;
      }
    }
    m = 5;
    h = 100/m;
    n = 10;
    w = 400/n;
    speedX = random(-3,3);
    if(win == 50){
      speedY -=0.5; //<>//
      level++;
    }else{
      speedY = 3;
    }
    ballX = 0;
    ballY = 350;
    click = 0;
    lives = 3;
    restart = 0;
    point = 0;
    }
  }   
  point = pointsTotal();
  fill(0);
  textSize(20);
  text("Points:" + point, 10,20);
  text("Lives:" + lives, 330, 20);
  text("Level:" + level, 200, 20);
}

void bricks(){
  for(int i = 0; i < blocksVisible.length; i++){
    for(int j = 0; j < blocksVisible[i].length; j++){
      if(blocksVisible[i][j] == true){
        stroke(0);
        fill(255);
        rect(i * w, j * h + 100, w, h);
      }else if(blocksVisible[i][j] == false){
        stroke(wallColor[0], wallColor[1], wallColor[2]);
        fill(wallColor[0], wallColor[1], wallColor[2]);
        rect(i * w, j * h + 100, w, h);
      }
    }
  } 
}

void mouseClicked(){
  click+=1;
}

int collision(int xr, int yr, int wr, int hr, float xc, float yc, int rc) {
  if(dist(xc, yc, xr, yr) < rc){return 5;}
  if(dist(xc, yc, xr+wr, yr) < rc){return 5;}
  if(dist(xc, yc, xr, yr+hr) < rc){return 5;}
  if(dist(xc, yc, xr+wr, yr+hr) < rc){return 5;}
  for (int xt = xr; xt < xr + wr; xt++) {
    if (dist(xc, yc, xt, yr) < rc) {
      return 1;
    }
    if (dist(xc, yc, xt, yr+hr) < rc) {
      return 2;
    }
  }
  for (int yt = yr; yt < yr + hr; yt++) {
    if (dist(xc, yc, xr, yt) < rc) {
      return 3;
    }
    if (dist(xc, yc, xr+wr, yt) < rc) {
      return 4;
    }
  }
  return -1;
}

void hitRect(){
  int count = 0;
  for(int i = 0; i < blocksVisible.length; i++){
    for(int j = 0; j < blocksVisible[i].length; j++){
      int rectHit = collision(i * w, j * h + 100, w, h, ballX, ballY, 8);
      if(rectHit != -1 && blocksVisible[i][j] == true){
        if(rectHit == 1 || rectHit == 2){
          speedY = speedY * -1;           
          rectHit = -1;
        }else if(rectHit == 3 || rectHit == 4){
          speedX = speedX * -1;           
          rectHit = -1;
        }else{
          count = 1;
        }
          blocksVisible[i][j] = false;
          speedX -= 0.02;
      }
      if(count == 1 && i == blocksVisible.length - 1 && j == blocksVisible[i].length - 1){
        speedX = speedX * - 1;
        speedY = speedY * - 1;
        count = 0;
      }
    }
  }
}

void hitSideWalls(){
  if(ballX >= 390){
        ballX = 390;
      }else{
        ballX = 10;
      }
      speedX = speedX * -1;  
      if(speedX < 0){
        speedX -= 0.025;
      }else{
        speedX += 0.025;
      }
}

void topWallPaddle(){
        int change = round(random(1,2));
        if(change == 2){
          speedX *= - 1;
        }
        speedY = speedY * -1;
        if(ballY <= 10){
          ballY = 11;
        }
        if(speedX < 0){
          speedX -= 0.025;
        }else{
          speedX += 0.025;
        }
}

int pointsTotal(){
  int points = 0;
  for(int i = 0; i < blocksVisible.length; i++){
    for(int j = 0; j < blocksVisible[i].length; j++){
      if(!blocksVisible[i][j]){
        points += 50 - j * 10;
      }
    } 
  }
  return points;
}
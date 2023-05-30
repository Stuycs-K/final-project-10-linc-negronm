class Room{
  private Tile[][] map;
  private int exitX, exitY;
  private int enemiesKilled, enemyCount;
  public int ySize, xSize;
  public int heroX, heroY;
  public boolean targeting;
  public int targX, targY;
  public Enemy[] enemies;
  public float[] enemyDist;
  public Hero hero;
  
  public Room(int xsize, int ysize){
    map = new Tile[ysize][xsize];
    ySize = ysize;
    xSize = xsize;
    exitX = xsize-2;
    exitY = ysize/2;
    heroX = 1;
    heroY = ysize/2;
    enemiesKilled = 0;
    targeting = false;
    targX = heroX;
    targY = heroY;
    hero = new Hero(50, heroX, heroY);
  }
  
  public void rotateMap(){
    Tile[][] newMap = new Tile[ySize][xSize];
    for(int y = 0; y < ySize; y++){
      for(int x = 0; x < xSize; x++){
        newMap[y][x] = map[x][y];
        map[y][x].setY(x);
        map[y][x].setX(y);
      }
    }
    map = newMap;
  }
  
  private boolean isIn(int[] arr, int num){
    for (int i = 0; i < arr.length; i++){
      if (arr[i] == num){
        return true;
      }
    }
    return false;
  }
  
  private Tile[] makeWall(int size, int y){
    Tile[] wall = new Tile[size];
    int gapStart = int(random(1, size-10));
    for (int i = 0; i < size; i++){
      if (i >= gapStart && i < gapStart+10){
        wall[i] = new Tile(i, y);
      }else{
        wall[i] = new Wall(i, y);
      }
    }
    return wall;
  }
  
  public void swap(int x, int y, int desX, int desY){
    Tile oldTile = map[desY][desX];
    Tile moved = map[y][x];
    map[desY][desX] = moved;
    map[y][x] = oldTile;
    moved.setX(desX);
    moved.setY(desY);
    oldTile.setX(x);
    oldTile.setY(y);
  }
  
  public void swapTarget(int x, int y){
    map[targY][targX].untarget();
    map[y][x].target();
    targY = y;
    targX = x;
  }
  
  public void targetMode(){
    targeting = !targeting;
    swapTarget(heroX, heroY);
  }
  
  public void basicAttack(){
    for (int i = 0; i < enemies.length; i++){
      if (map[enemies[i].getY()][enemies[i].getX()].isTargeted){
        hero.basicAttack(enemies[i]);
      }
      map[enemies[i].getY()][enemies[i].getX()].untarget();
    }
  }
  
  public void generateRoom(){
    enemyCount = 0;
    enemiesKilled = 0;
    float r;
    int maxY = map.length;
    int maxX = map[0].length;
    map = new Tile[xSize][ySize];
    int space = xSize/4-1;
    int[] walls = new int[]{space*1-1, space*2-1, space*3-1, space*4-1};
    heroX = 1;
    heroY = ySize/2;
    
    for (int y = 0; y < ySize; y++){
      if (isIn(walls, y)){
          map[y] = makeWall(xSize, y);
      }else{
        for (int x = 0; x < xSize; x++){
          if (y == 0 || y == ySize-1 || x == 0 || x == xSize-1){
            map[y][x] = new Wall(x, y);
          }else{
            map[y][x] = new Tile(x, y);
          }
        }
      }
    }

    rotateMap();
    if(map[ySize/2][1].isWall()){
      map[ySize/2][1] = new Tile(1, ySize/2);
    }
    map[ySize/2][1].setChar(hero);
    // PLACING ENEMIES
    enemies = new Enemy[6];
    enemyDist = new float[6];
    Enemy e;
    while (enemyCount < 6){
      for (int y = 1; y < ySize-1; y++){
        for (int x = xSize/2; x < xSize-1; x++){
          r = random(0, 100);
          if(r < 0.01 && map[y][x].isWall() == false){
            e = new Enemy(25, x, y);
            map[y][x] = new Tile(x, y, e);
            enemies[enemyCount] = e;
            enemyCount++;
            if (enemyCount > 6){
              x = xSize+1;
              y = ySize+1;
            }
          }
        }
      }
    }

  }
  
  public void showRoom(){
    int x = 0;
    int y = 0;
    stroke(255);
    strokeWeight(1);
    while (x < map[0].length){
      while (y < map.length){
        if (map[y][x].isWall() == true){
          fill(0);
          rect(x*20, y*20, 20, 20);
        }else if (x == exitX && y == exitY){
          fill (255, 0, 255);
          rect(x*20, y*20, 20, 20);
        }else if (map[y][x].getChar() != null){
          if (map[y][x].getChar().getType().equals("hero")){
            fill(0, 0, 255);
            rect(x*20, y*20, 20, 20);
          }else if (map[y][x].getChar().getType().equals("enemy")){
            if (map[y][x].getChar().getHealth() <= 0){
              fill(145, 105, 105);
            }else{
              fill(255, 0, 0);
            }
            rect(x*20, y*20, 20, 20);
          }
          fill(0);
          textSize(14);
          if (map[y][x].getChar().health > 0){
            text(map[y][x].getChar().health, x*20+3, y*20);
          }
        }else{
          fill(200);
          rect(x*20, y*20, 20, 20);
        }
        
        fill(255);
        textSize(8);
        text(""+map[y][x].getX()+","+map[y][x].getY(), x*20+5, y*20+20/2);
        if (targeting && map[y][x].isTargeted){
          noFill();
          stroke(255, 255, 0);
          rectMode(CENTER);
          rect(x*20+10, y*20+10, 10, 10);
          rectMode(CORNER);
          stroke(255);
        }
        y++;
      }
    x++;
    y = 0;
    }
    textSize(24);
    fill(0);
    text("Press WASD to move", 670, 30);
    text("Targeting: "+targeting, 670, 60);
    text("Hero position: "+heroX+", "+heroY, 670, 90);
    text("Targeting position: "+targX+", "+targY, 670, 120);
  }
  
  private void printEnemies(){
    String result = "[";
    for (int i = 0; i < enemies.length-1; i++){
      result += enemies[i].toString() + ", ";
    }
    result += enemies[enemies.length-1].toString() + "]";
    println(result);
  }
}

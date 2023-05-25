class Room{
  private Tile[][] map;
  private int exitX, exitY;
  private int enemiesKilled, enemyCount;
  public int ySize, xSize;
  public int heroX, heroY;
  public boolean targeting;
  public int targX, targY;
  
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
    Character character = map[y][x].getChar();
    Character desChar = map[desX][desY].getChar();
    map[y][x].setChar(desChar);
    map[desY][desX].setChar(character);
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
    map[ySize/2][1].setChar(new Hero(50));
    // PLACING ENEMIES
    while (enemyCount <= 5){
      for (int y = 1; y < ySize-1; y++){
        for (int x = xSize/2; x < xSize-1; x++){
          r = random(0, 100);
          if(r < 0.01 && map[y][x].isWall() == false){
            map[y][x] = new Tile(x, y, new Enemy(25));
            enemyCount++;
            if (enemyCount >= 5){
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
    while (x < map[0].length){
      while (y < map.length){
        if (map[y][x].isWall() == true){
          fill(0);
        }else if (x == exitX && y == exitY){
          fill (255, 0, 255);
        }else if (map[y][x].getChar() != null){
          if (map[y][x].getChar().getType().equals("hero")){
            fill(0, 0, 255);
          }else if (map[y][x].getChar().getType().equals("enemy")){
            fill(255, 0, 0);
          }
          
        }else{
          fill(200);
        }
        rect(x*20, y*20, 20, 20);
        fill(255);
        textSize(8);
        text(""+map[y][x].getX()+","+map[y][x].getY(), x*20+5, y*20+20/2);
        if (targeting && y == targY && x == targX){
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
  }
}

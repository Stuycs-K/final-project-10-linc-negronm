class Room{
  private Tile[][] map;
  private int exitX, exitY;
  private int enemiesKilled;
  private int ySize, xSize;
  
  public Room(int xsize, int ysize){
    map = new Tile[ysize][xsize];
    ySize = ysize;
    xSize = xsize;
    exitX = xsize-2;
    exitY = ysize/2;
    enemiesKilled = 0;
  }
  
  private boolean checkWalls(int x, int y){
    if (y-1 >= 0 && map[y-1][x] != null && map[y-1][x].isWall() == true){
      return true;
    }else if (y+1 < map.length && map[y+1][x] != null && map[y+1][x].isWall() == true){
      return true;
    }else if (x-1 >= 0 && map[y][x-1] != null && map[y][x-1].isWall() == true){
      return false;
    }else if (x+1 < map[0].length && map[y][x+1] != null && map[y][x+1].isWall() == true){
      return false;
    }else{
      return false;
    }
    
  }
  
  public void generateRoom(){
    float r;
    int maxY = map.length;
    int maxX = map[0].length;
    for (int y = 0; y < maxY; y++){
      for (int x = 0; x < maxX; x++){
        if (y == 0 || y == maxY-1 || x == 0 || x == maxX-1){
          map[y][x] = new Wall(x, y);
        }else{
          r = random(0, 100);
          if (r < 60 && checkWalls(x, y) == true){
            map[y][x] = new Wall(x, y);
          }else{
            map[y][x] = new Tile(x, y);
          }
        }
      }
    }
    map[ySize/2][1].setChar(new Hero(50));
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
          fill (255, 0, 0);
        }else if (map[y][x].getChar() != null && map[y][x].getChar().getType().equals("hero")){
          fill(0, 0, 225);
        }else{
          fill(200);
        }
        rect(x*20, y*20, 20, 20);
        y++;
      }
    x++;
    y = 0;
    }
  }
}

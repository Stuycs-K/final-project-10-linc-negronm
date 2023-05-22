class Room{
  private Tile[][] map;
  private int exitX, exitY;
  private int enemiesKilled;
  
  public Room(int xsize, int ysize){
    map = new Tile[ysize][xsize];
    exitX = xsize/2;
    exitY = ysize/2;
    enemiesKilled = 0;
  }
  
  public void generateRoom(){
    int maxY = map.length;
    int maxX = map[0].length;
    for (int y = 0; y < maxY; y++){
      for (int x = 0; x < maxX; x++){
        if (y == 0 || y == maxY-1 || x == 0 || x == maxX-1){
          map[y][x] = new Tile(true);
        }else{
          map[y][x] = new Tile(false);
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
        if (map[y][x].getW() == true){
          fill(0);
        }else{
          fill(255);
        }
        rect(x*20, y*20, 20, 20);
        y++;
      }
    }
  }
}

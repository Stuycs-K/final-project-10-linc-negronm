class Tile {
  int x,y;
  
  public Tile(int xpos, int ypos){
    x = xpos;
    y = ypos;
  }
  
  public void changePos(int x, int y){
  this.x =x;
  this.y =y;
  }
  public int calcDis(Tile other){
    return 0;
  }
  public int getX(){
    return x;
  }
  public int gety(){
    return y;
  }
  public boolean isWall(){
    return false;
  }
}

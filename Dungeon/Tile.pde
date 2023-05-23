class Tile {
  int x,y;
  Character chara;
  
  public Tile(int xpos, int ypos){
    x = xpos;
    y = ypos;
    chara = null;
  }
  
  public Tile(int xpos, int ypos, Character character){
    x = xpos;
    y = ypos;
    chara = character;
  }
  
  public void setChar(Character character){
    chara = character;
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

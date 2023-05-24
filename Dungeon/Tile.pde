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
  
  public Character getChar(){
    return chara;
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
  public int getY(){
    return y;
  }
  public void setX(int X){
    x = X;
  }
  public void setY(int Y){
    y = Y;
  }
  public boolean isWall(){
    return false;
  }
}

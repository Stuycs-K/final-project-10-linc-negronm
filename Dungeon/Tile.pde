class Tile {
  int x, y;
  Character chara;
  boolean isTargeted;
  boolean isPath;

  public Tile(int xpos, int ypos) {
    x = xpos;
    y = ypos;
    chara = null;
    isTargeted = false;
    isPath = false;
  }

  public Tile(int xpos, int ypos, Character character) {
    x = xpos;
    y = ypos;
    chara = character;
    isTargeted = false;
  }

  public void setChar(Character character) {
    chara = character;
  }

  public Character getChar() {
    return chara;
  }

  public void target() {
    isTargeted = true;
  }

  public void untarget() {
    isTargeted = false;
  }


  public void changePos(int x, int y) {
    this.x =x;
    this.y =y;
  }
  public float calcDis(Tile other) {
    return dist(x, y, other.getX(), other.getY());
  }
  public int getX() {
    return x;
  }
  public int getY() {
    return y;
  }
  public void setX(int X) {
    x = X;
  }
  public void setY(int Y) {
    y = Y;
  }
  public boolean isWall() {
    return false;
  }
}

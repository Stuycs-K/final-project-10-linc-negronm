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

  public String toString() {
    return "Tile at: " + x + ", " + y;
  }

  public void setChar(Character character) {
    chara = character;
  }

  public Character getChar() {
    return chara;
  }

  public boolean hasChar() {
    if (chara == null) {
      return false;
    }
    return true;
  }

  public boolean hasEnemy() {
    if (chara == null) {
      return false;
    } else if (chara.getType().equals("enemy")) {
      return true;
    } else {
      return false;
    }
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
    return dist(x*20, y*20, other.getX()*20, other.getY()*20);
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
  public boolean isTreasure() {
    return false;
  }
  public void randomBuff(Hero h){
  }
}

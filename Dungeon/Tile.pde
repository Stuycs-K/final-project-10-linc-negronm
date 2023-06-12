class Tile {
  int x, y; // coords
  Character chara; // character on top
  boolean isTargeted; // is it targeted?

  public Tile(int xpos, int ypos) {
    x = xpos;
    y = ypos;
    chara = null;
    isTargeted = false;
  }

  public Tile(int xpos, int ypos, Character character) { // takes a character param
    x = xpos;
    y = ypos;
    chara = character;
    isTargeted = false;
  }

  public String toString() {
    return "Tile at: " + x + ", " + y;
  }

  public void setChar(Character character) { // sets char
    chara = character;
  }

  public Character getChar() { // returns char
    return chara;
  }

  public boolean hasChar() { // does it have a char?
    if (chara == null) {
      return false;
    }
    return true;
  }

  public boolean hasEnemy() { // does it have an enemy?;
    if (chara == null) {
      return false;
    } else if (chara.getType().equals("enemy")) {
      return true;
    } else {
      return false;
    }
  }

  public void target() { // sets target
    isTargeted = true;
  }

  public void untarget() { // untargets
    isTargeted = false;
  }


  public void changePos(int x, int y) { // changes the position of a tile
    this.x =x;
    this.y =y;
  }
  public float calcDis(Tile other) { // calculates pixel distance btween 2 tiles
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
  public void randomBuff(Hero h){ // abstract method for TreasureTile
  }
}

class Wall extends Tile {
  public Wall(int x, int y) {
    super(x, y);
  }
  public boolean isWall() { // is it a wall?
    return true;
  }
}

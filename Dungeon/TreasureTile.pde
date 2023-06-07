class TreasureTile extends Tile {
  boolean treasure;
  public TreasureTile(int x, int y) {
    super(x, y);
    treasure = true;
  }
  public boolean hasTreasure() {
    return treasure;
  }
  public void randomBuff(Hero h){
    int x = (int)random(2);
    if( x ==0){
    h.heal(30);
    }
    if(x == 1){
    
    }
  }
}

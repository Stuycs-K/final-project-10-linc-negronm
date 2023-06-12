class TreasureTile extends Tile {
  public TreasureTile(int x, int y) {
    super(x, y);
  }
  public boolean isTreasure() {
    return true;
  }
  public void randomBuff(Hero h){
    int x = (int)random(2);
    if( x ==0){
    h.heal((int)random(15,30));
    }
    if(x == 1){
    h.damageBuff += 0.2;
    }
  }
}

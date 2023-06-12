class Hero extends Character {
  float damageBuff;
  int[] basicStats; //for each move index 0 is the range of the attack, index 1 is the cooldown of the move, index 2 is the last move count that the move was used
  int[] ability1Stats;
  int[] ability2Stats;
  public Hero(int maxHP, int X, int Y) {
    maxHealth = maxHP;
    health = maxHP;
    moveCap = 7;
    x = X;
    y = Y;
    damageBuff =1.0;
    basicStats = new int[3];
    ability1Stats = new int[3];
    ability2Stats = new int[3];
  }

  public String getType() {
    return "hero";
  }
  
  
  public boolean isStunned() {
    return false;
  }
  
  public String getClassif(){
    return "hero";
  }

  public void basicAttack(Enemy e) {
    e.takeDmg((int)(10 *damageBuff));
    takeDmg(5);
  }
  public void takeDmg(int x) {
    health -= x;
  }
  
  public void debuff(float x){
    damageBuff -= x;
  }
  public int getHealth() {
    return health;
  }
  public void ability1(Enemy e) {
    e.takeDmg((int)(3 *damageBuff));
    heal(5);
  }
  
  public void ability1(Room r){
  }
  
  public void ability2(Enemy e) {
  }
  
  public void ability2(){};
  
  public void heal(int x) {
    health += x;
    if (health > maxHealth) {
      health = maxHealth;
    }
  }
  public boolean isDead() {
    if ( health > 0) {
      return true;
    } else {
      return false;
    }
  }
  public boolean isMage(){
    return false;
  }
}

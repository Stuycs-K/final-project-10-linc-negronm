class Enemy extends Character {
  public int abilityCounter; // ability timer
  int moved; // for move cap purposes
  int stunCounter; // stun turns
  int range; // atk range
  boolean attacked; // did atk?
  String atkMsg, abMsg; // console msgs
  public Enemy(int maxHP, int X, int Y) { // constructor
    maxHealth = maxHP;
    health = maxHP;
    moveCap = 4;
    x = X;
    y = Y;
    moved =0;
    range = 80;
    attacked = false;
    abilityCounter = 0;
    isStunned = false;
  }
  
  // accessor methods
  public String getType() {
    return "enemy";
  }

  public String getClassif() {
    return "enemy";
  }
  
  public boolean isStunned(){
    return isStunned;
  }

  public int getY() {
    return y;
  }

  public int getX() {
    return x;
  }

  public int getHealth() {
    return health;
  }

  public int getMaxHealth() {
    return maxHealth;
  }
  
  public void setHealth(int x){
    health = x;
  }
  
  public String toString() {
    return "Enemy: HP " + health + "(" + getX() + "," + getY() + ")";
  }
  
  // end of accessors

  public void basicAttack(Hero h) { // default atk, should never be used
    h.takeDmg(5);
  }

  public void takeDmg(int x) { // take dmg
    health -= x;
  }
  public void ability() { // default ability, should never be used
    takeDmg(-2);
  }
  
  public void stun(int c){ // for stunning an enemy
    stunCounter = c;
    isStunned = true;
  }

  public void attack(Room r) { // default attack, should never be used
    if (random(1) > .5) {
      basicAttack(r.hero);
    } else {
      ability();
    }
  }
}

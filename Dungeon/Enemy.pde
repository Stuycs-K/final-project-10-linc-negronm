class Enemy extends Character {
  public int abilityCounter;
  int moved;
  int stunCounter;
  boolean attacked;
  public Enemy(int maxHP, int X, int Y) {
    maxHealth = maxHP;
    health = maxHP;
    moveCap = 4;
    x = X;
    y = Y;
    moved =0;
    attacked = false;
    abilityCounter = 0;
  }
  public String getType() {
    return "enemy";
  }

  public String getClassif() {
    return "enemy";
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

  public void move() {
  }
  public void basicAttack(Hero h) {
    h.takeDmg(5);
  }

  public void takeDmg(int x) {
    health -= x;
  }
  public void ability() {
    takeDmg(-2);
  }

  public void attack(Room r) {
    if (random(1) > .5) {
      basicAttack(r.hero);
    } else {
      ability();
    }
  }
}

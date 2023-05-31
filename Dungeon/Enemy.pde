class Enemy extends Character {
  int moved;
  boolean attacked;
  public Enemy(int maxHP, int X, int Y) {
    maxHealth = maxHP;
    health = maxHP;
    moveCap = 4;
    x = X;
    y = Y;
    moved =0;
    attacked = false;
  }
  public String getType() {
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
  }
}

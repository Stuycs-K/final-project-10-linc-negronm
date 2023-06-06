class Hero extends Character {
  float damageBuff;
  public Hero(int maxHP, int X, int Y) {
    maxHealth = maxHP;
    health = maxHP;
    moveCap = 7;
    x = X;
    y = Y;
    damageBuff =1.0;
  }

  public String getType() {
    return "hero";
  }

  public void move() {
  }
  public void basicAttack(Enemy e) {
    e.takeDmg((int)(10 *damageBuff));
    takeDmg(5);
  }
  public void takeDmg(int x) {
    health -= x;
  }
  public int getHealth() {
    return health;
  }
  public void ability1(Enemy e) {
    e.takeDmg((int)(3 *damageBuff));
    heal(5);
  }
  public void ability2(Enemy e) {
  }
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
}

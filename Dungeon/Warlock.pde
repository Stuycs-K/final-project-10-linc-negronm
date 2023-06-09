class Warlock extends Enemy {
  public Warlock(int X, int Y) {
    super(10, X, Y);
  }

  public String getClassif() {
    return "warlock";
  }

  public void basicAttack(Hero h) {
    h.takeDmg(2);
    abilityCounter++;
  }

  public void ability(Enemy[] es) {
    for (int i = 0; i < es.length; i++) {
      if (es[i].getHealth() <= 0) {
        es[i].setHealth(es[i].getMaxHealth() / 2);
      }
    }
    stunCounter = 2;
    abilityCounter = 0;
  }

  public void attack(Room r) {
    if (stunCounter > 0) {
      stunCounter--;
    } else {
      if (abilityCounter >= 10 && random(1) > 0.5) {
        ability(r.enemies);
      } else {
        basicAttack(r.hero);
      }
    }
  }
}

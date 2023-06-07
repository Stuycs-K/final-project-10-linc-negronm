class Skeleton extends Enemy {
  public int abilityCounter;
  Skeleton(int X, int Y) {
    super(25, X, Y);
  }

  public String getClassif() {
    return "skeleton";
  }

  public void basicAttack(Hero h) {
    h.takeDmg(5);
    abilityCounter++;
  }

  public void ability(Hero h) {
    h.takeDmg(10);
    abilityCounter = 0;
  }

  public void attack(Room r) {
    if (stunCounter > 0) {
      stunCounter--;
    } else {
      if (abilityCounter >= 3 && random(1) > 0.5) {
        ability(r.hero);
      } else {
        basicAttack(r.hero);
      }
    }
  }
}

class Arbalist extends Enemy{
  Arbalist(int X, int Y) {
    super(12, X, Y);
    range = 160;
  }

  public String getClassif() {
    return "arbalist";
  }

  public void basicAttack(Hero h) {
    h.takeDmg(7);
    abilityCounter++;
  }

  public void ability(Hero h) {
    h.takeDmg(2);
    h.debuff(0.1);
    abilityCounter = 0;
  }

  public void attack(Room r) {
    if (health <= 0){
      return;
    }
    if (stunCounter > 0) {
      stunCounter--;
      //println("i am stunned");
      if (stunCounter <= 0){
        isStunned = false;
      }
      return;
    } else {
      if (abilityCounter >= 4 && random(1) > 0.5) {
        ability(r.hero);
      } else {
        basicAttack(r.hero);
      }
    }
  }
}

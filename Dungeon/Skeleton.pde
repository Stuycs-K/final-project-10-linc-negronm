class Skeleton extends Enemy {
  Skeleton(int X, int Y) {
    super(25, X, Y);
    range = 60;
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
    stunCounter = 1;
    isStunned = true;
    abilityCounter = 0;
  }

  public void attack(Room r) {
    if (health <= 0){
      return;
    }
    if (stunCounter > 0) {
      stunCounter--;
      addToConsole("Skeleton is stunned and cannot move!");
      if (stunCounter <= 0){
        isStunned = false;
        addToConsole("Skeleton recovers from his stun!");
      }
      return;
    } else {
      if (abilityCounter >= 3 && random(1) > 0.5) {
        ability(r.hero);
        abMsg = "Skeleton hit you hard for 10 damage!";
        addToConsole(abMsg);
      } else {
        basicAttack(r.hero);
        atkMsg = "Skeleton struck you for 5 damage!";
        addToConsole(atkMsg);
      }
    }
  }
}

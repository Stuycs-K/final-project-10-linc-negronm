class Skeleton extends Enemy {
  Skeleton(int X, int Y) {
    super(25, X, Y);
    range = 60;
  }

  public String getClassif() {
    return "skeleton";
  }

  public void basicAttack(Hero h) { // do moderate dmg, charge ability
    h.takeDmg(5);
    abilityCounter++;
  }

  public void ability(Hero h) { // do more dmg
    h.takeDmg(10);
    stunCounter = 1;
    isStunned = true;
    abilityCounter = 0;
  }

  public void attack(Room r) { // chooses move
    if (health <= 0) { // if dead
      return;
    }
    if (stunCounter > 0) { // if stunned
      stunCounter--;
      addToConsole("Skeleton is stunned and cannot move!");
      if (stunCounter <= 0) {
        isStunned = false;
        addToConsole("Skeleton recovers from his stun!");
      }
      return;
    } else {
      if (abilityCounter >= 3 && random(1) > 0.5) { // if ability is ready, 1/2 chance to use it
        ability(r.hero);
        abMsg = "Skeleton hit you hard for 10 damage!";
        addToConsole(abMsg);
      } else { // normal atk
        basicAttack(r.hero);
        atkMsg = "Skeleton struck you for 5 damage!";
        addToConsole(atkMsg);
      }
    }
  }
}

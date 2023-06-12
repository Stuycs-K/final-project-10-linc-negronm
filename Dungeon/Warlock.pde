class Warlock extends Enemy {
  String resd;
  public Warlock(int X, int Y) {
    super(10, X, Y);
    range = 100;
  }

  public String getClassif() {
    return "warlock";
  }

  public void basicAttack(Hero h) { // do small dmg and charge ability
    h.takeDmg(2);
    abilityCounter++;
  }

  public void ability(Enemy[] es) { // raise an enemy from the dead with 1/2 health
    for (int i = 0; i < es.length; i++) {
      if (es[i].getHealth() <= 0) {
        es[i].setHealth(es[i].getMaxHealth() / 2);
        stunCounter = 2;
        isStunned = true;
        resd = es[i].getClassif();
        return;
      }
    }
    abilityCounter = 0;
  }

  public void attack(Room r) {
    if (health <= 0){
      return;
    }
    if (stunCounter > 0) {
      stunCounter--;
      addToConsole("Warlock is stunned and cannot move!");
      if (stunCounter <= 0){ // remove stun when ready
        isStunned = false;
        addToConsole("Warlock recovers from his stun!");
      }
      return;
    } else {
      if (abilityCounter >= 5 && random(1) > 0.5) { // if ability ready, 1/2 chance to use it
        ability(r.enemies);
        if (resd != null){
          abMsg = "Warlock raises a " + resd + " from the grave!";
          addToConsole(abMsg);
        }
      } else { // normal atk
        basicAttack(r.hero);
        atkMsg = "Warlock casts a fireball at you for 5 damage!";
        addToConsole(atkMsg);
      }
    }
  }
}

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
      addToConsole("Arbalist is stunned and cannot move!");
      //println("i am stunned");
      if (stunCounter <= 0){
        isStunned = false;
        addToConsole("Arbalist recovers from his stun!");
      }
      return;
    } else {
      if (abilityCounter >= 4 && random(1) > 0.5) {
        ability(r.hero);
        abMsg = "Arbalist fires a disorienting flare!";
        addToConsole(abMsg);
      } else {
        basicAttack(r.hero);
        atkMsg = "Arbalist shoots you for 5 damage!";
        addToConsole(atkMsg);
      }
    }
  }
}

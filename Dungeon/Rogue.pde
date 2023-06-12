class Rogue extends Hero{
  public Rogue(int X, int Y){
    super(175, X, Y);
    //for each move index 0 is the range of the attack, index 1 is the cooldown of the move, index 2 is the last move count that the move was used
    basicStats = new int[]{200, 0, 0}; // pistol shot
    ability1Stats = new int[]{40, 1, -1}; // pbs
    ability2Stats = new int[]{60, 0, 0}; // Open vein
  }
  
  public String getClassif(){
    return "rogue";
  }
  
  public void basicAttack(Enemy e) { // do damage
    e.takeDmg((int)(13 *damageBuff));
  }
  
  public void ability1(Enemy e) { // do big dmg
    e.takeDmg((int)(25 *damageBuff));
  }
  
  public void ability2(Enemy e) { // give himself dmg buff and heal
    e.takeDmg(int(9 * damageBuff));
    heal(20);
  }
}

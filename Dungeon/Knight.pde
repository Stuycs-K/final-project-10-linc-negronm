class Knight extends Hero{
  public Knight(int X, int Y){
    super(200, X, Y);
    //for each move index 0 is the range of the attack, index 1 is the cooldown of the move, index 2 is the last move count that the move was used
    basicStats = new int[]{80, 0, 0};
    ability1Stats = new int[]{60, 0, 0};
    ability2Stats = new int[]{20, 2, -2};
  }
  
  public String getClassif(){
    return "knight";
  }
  
  public void basicAttack(Enemy e) { // do damage
    e.takeDmg((int)(10 *damageBuff));
  }
  
  public void ability1(Enemy e) { // stun enemy and do little dmg
    e.takeDmg((int)(3 *damageBuff));
    e.stun(2);
  }
  
  public void ability2() { // give himself dmg buff and heal
    damageBuff += 0.2;
    heal(30);
  }
    
}

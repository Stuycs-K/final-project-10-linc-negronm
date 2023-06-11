class Mage extends Hero {
  public Mage(int X, int Y) {
    super(150, X, Y);
    basicStats[0]= 160;
    basicStats[1] =0;
    basicStats[2] =0;
    ability1Stats[0] =80;
    ability1Stats[1] =2;
    ability1Stats[2] =-2;
    ability2Stats[0] =40;
    ability2Stats[1] =3;
    ability2Stats[2] =-3;
  }
  public void basicAttack(Enemy e) { // do damage
    e.takeDmg((int)(10 *damageBuff));
  }

  public void ability1(Room r) { // damage all enemies in range
    for (int i =0; i< r.enemies.length; i++) {
      float dist= enemyDistToHero(r.enemies[i], x, y);
      if ( dist < ability1Stats[0]) { // enemy in range
        r.enemies[i].takeDmg(15);
      }
    }
  }
  public void ability2(Enemy e) { // life steal
    e.takeDmg((int)(10 *damageBuff));
    heal((int)(20 *damageBuff));
  }
  public boolean isMage() {
    return true;
  }

  public String getClassif() {
    return "mage";
  }
}

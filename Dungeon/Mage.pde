class Mage extends Hero {
  public Mage(int maxHP, int X, int Y){
    super(maxHP, X, Y);
    basicStats[0]= 10;
    basicStats[1] =0;
    basicStats[2] =0;
    ability1Stats[0] =4;
    ability1Stats[1] =2;
    ability1Stats[2] =0;
    ability2Stats[0] =1;
    ability2Stats[1] =3;
    ability2Stats[2] =0;
  }
  public void basicAttack(Enemy e) {
    e.takeDmg((int)(10 *damageBuff));
  }
  
  public void ability1(Room r){
    for(int i =0; i< r.enemies.length; i++){
      float dist= enemyDistToHero(r.enemies[i], x, y);
      if( dist < ability1Stats[0]){
        r.enemies[i].takeDmg(20);
      }
    }
    
  }
  public void ability2(Enemy e) {
    e.takeDmg((int)(10 *damageBuff));
    heal((int)(10 *damageBuff));
  }
  public boolean isMage(){
    return true;
  }
  
}

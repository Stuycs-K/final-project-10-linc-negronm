class Enemy extends Character{
  
  public Enemy(int maxHP){
    maxHealth = maxHP;
    health = maxHP;
  }
  
  public void move(){
  }
  public void basicAttack(Enemy e){
  }
  public void takeDmg(int x){
    health -= x;
  }
  public void ability(){
  
  }
  public void die(){
  
  }
}

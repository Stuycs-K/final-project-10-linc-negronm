class Enemy extends Character{
  
  public Enemy(int maxHP){
    maxHealth = maxHP;
    health = maxHP;
  }
  
  public String getType(){
    return "enemy";
  }
  
  public void move(){
  }
  public void basicAttack(){
    int x =2;
  }
  
  public void takeDmg(int x){
    health -= x;
  }
  public void ability(){
  
  }
  public void die(){
  
  }
}

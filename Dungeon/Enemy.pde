class Enemy extends Character{
  
  public Enemy(int maxHP){
    maxHealth = maxHP;
    health = maxHP;
    moveCap = 5;
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

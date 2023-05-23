class Hero extends Character{
  
  public Hero(int maxHP){
    maxHealth = maxHP;
    health = maxHP;
  }
  
  public String getType(){
    return "hero";
  }
  
  public void move(){
  }
  public void basicAttack(Enemy e){
  }
  public void takeDmg(int x){
    health -= x;
  }
  public void ability1(Enemy e){
  }
  public void ability2(Enemy e){
  }
  public void heal(int x){
    health += x;
    if(health > maxHealth){
      health = maxHealth;
    }
  }
  public boolean isDead(){
    if( health > 0){
      return true;
     }else{
      return false;
    }
  }
}

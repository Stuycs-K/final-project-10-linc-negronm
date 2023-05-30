class Hero extends Character{
  
  public Hero(int maxHP, int X, int Y){
    maxHealth = maxHP;
    health = maxHP;
    moveCap = 7;
    x = X;
    y = Y;
  }
  
  public String getType(){
    return "hero";
  }
  
  public void move(){
  }
  public void basicAttack(Enemy e){
    e.takeDmg(10);
    println(e.getHealth());
  }
  public void takeDmg(int x){
    health -= x;
    
  }
  public int getHealth(){
    return health;
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

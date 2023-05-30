class Enemy extends Character{
  
  public Enemy(int maxHP, int X, int Y){
    maxHealth = maxHP;
    health = maxHP;
    moveCap = 5;
    x = X;
    y = Y;
  }
  
  public String getType(){
    return "enemy";
  }
  
  public int getY(){
    return y;
  }
  
  public int getX(){
    return x;
  }
  
  public int getHealth(){
    return health;
  }
  

  
  public String toString(){
    return "Enemy: HP " + health + "(" + getX() + "," + getY() + ")";
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
  
  
}

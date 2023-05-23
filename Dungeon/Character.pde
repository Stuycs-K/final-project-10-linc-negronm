abstract class Character {
  int health;
  int maxHealth;
  int x,y;
  
  abstract String getType();
  abstract void move();
  void takeDmg(int x){
    health -= x;
  }
}

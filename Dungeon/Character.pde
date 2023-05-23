abstract class Character {
  int health;
  int maxHealth;
  int x,y;
  abstract void move();
  void takeDmg(int x){
    health -= x;
  }
}

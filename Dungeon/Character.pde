abstract class Character {
  int health;
  int maxHealth;
  int x,y;
  abstract void move();
  abstract void basicAttack(Enemy e);
  void takeDmg(int x){
    health -= x;
  }
}

abstract class Character {
  int health;
  int maxHealth;
  int x, y;
  int moveCap;

  abstract String getType();
  abstract int getHealth();
  abstract String getClassif();
  abstract void move();
  void takeDmg(int x) {
    health-= x;
  }
  void setY(int Y) {
    y = Y;
  }

  void setX(int X) {
    x = X;
  }
}

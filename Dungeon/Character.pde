abstract class Character {
  int stunCounter;
  boolean isStunned;
  int health;
  int maxHealth;
  int x, y;
  int moveCap;

  abstract String getType(); //returns type
  abstract int getHealth(); //returns health
  abstract String getClassif(); //returns class
  void takeDmg(int x) { //takes an amount damage
    health-= x;
  }
  void setY(int Y) { //sets Y coord
    y = Y;
  }

  void setX(int X) { //sets X cord
    x = X;
  }
  
  abstract boolean isStunned();
}

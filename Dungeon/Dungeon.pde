Room room = new Room(33, 33);
Controller keyboardInput;
int countdown;
boolean heroTurn =false;
boolean enemyTurn =false;
int heroMoved = 0;
int abilityRange;
int ability;
int abilitiesUsed;
final static int BASICATTACK = 0;
final static int ABILITY1 = 1;
final static int ABILITY2 = 2;
Tile left, right, up, down;

public void heroTurn() {
  println("hero turn start");
  heroMoved =0;
  abilitiesUsed = 0;
  heroTurn = true;
}
public void heroTurnEnd() {
  println("hero turn end");
  heroTurn = false;
  enemyTurn();
}
public void enemyTurn() {
  println("enemy turn start");
  resetEnemyStates();
  enemyTurn = true;
}

public void pathFind(Enemy e, Hero h) {
  // keep moving x towards hero, then move y
  if (e.getX() < h.x && (room.map[e.getY()][e.getX()+1].isWall() == false || room.map[e.getY()][e.getX()+1].getChar() != null)) { // enemy to the left and no wall
    println(e.toString() + " moving right");
    room.swap(e.getX(), e.getY(), e.getX()+1, e.getY());
  } else if (e.getX() > h.x && (room.map[e.getY()][e.getX()-1].isWall() == false || room.map[e.getY()][e.getX()+1].getChar() != null)) { // enemy to the right and no wall
    println(e.toString() + " moving left");
    room.swap(e.getX(), e.getY(), e.getX()-1, e.getY());
  } else if (e.getY() > h.y && (room.map[e.getY()-1][e.getX()].isWall() == false || room.map[e.getY()][e.getX()+1].getChar() != null)) { // enemy below and no wall
    println(e.toString() + " moving up");
    room.swap(e.getX(), e.getY(), e.getX(), e.getY()-1);
  } else if (e.getY() < h.y && (room.map[e.getY()+1][e.getX()].isWall() == false || room.map[e.getY()][e.getX()+1].getChar() != null)) { // enemy above and no wall
    println(e.toString() + " moving down");
    room.swap(e.getX(), e.getY(), e.getX(), e.getY()+1);
  } else {
    println("couldn't move");
  }
  println("ENEMY AT: (" + e.getX() + "," + e.getY() + ")");
}
/*
void traceBack(Enemy e) {
  if (y >= 0 && y < room.map.length && x >= 0 && x < COLS) {

    int dist = m.map[r][c];
    if (dist > 0) {
      m.map[r][c]= m.PATH;
      int up = nextValue(m, r-1, c, dist-1);
      int down = nextValue(m, r+1, c, dist-1);
      int left = nextValue(m, r, c - 1, dist-1);
      int right = nextValue(m, r, c + 1, dist-1);
      int min = Math.min(up,Math.min(down,Math.min(left,right)));
      if ( up == min ) {
        traceBack(m, r-1, c);
      } else if ( down == min ) {
        traceBack(m, r+1, c);
      } else if ( left == min ) {
        traceBack(m, r, c-1);
      } else if ( right == min ) {
        traceBack(m, r, c+1);
      }
    }
  }
}

int nextValue(int r, int c, int dist) {
  try {
    int value = m.map[r][c];
    if(value >= 0){
     return value; 
    }
  }
  catch ( ArrayIndexOutOfBoundsException e) {
    
  }
  return Integer.MAX_VALUE;
}
*/

public void resetEnemyStates() {
  for (int i = 0; i < 6; i++) {
    room.enemies[i].attacked = false;
    room.enemies[i].moved = 0;
  }
  println("----------------------------------------------------------------------------------------FINISHED LOOP");
}

public float enemyDistToHero(Enemy e, Hero h) {
  return dist(e.x, e.y, h.x, h.y);
}

public void enemyTurnEnd() {
  println("enemy turn end");
  enemyTurn = false;
  heroTurn();
}

void setup() {
  background(255);
  size(960, 660);
  room.generateRoom();
  room.showRoom();
  textSize(24);
  fill(0);

  keyboardInput = new Controller();
  countdown =0;
  heroTurn();
}

void keyPressed() {
  keyboardInput.press(keyCode);
  if (key == 'r') {
    room = new Room(33, 33);
    room.generateRoom();
    heroMoved =0;
  }
  if (key == 't') {
    room.targetMode();
  }
}

void keyReleased() {
  keyboardInput.release(keyCode);
}
void draw() {
  background(255);
  room.showRoom();
  if (room.targeting) {
    noFill();
    stroke(0, 255, 255);
    strokeWeight(5);
    circle(room.heroX*20+10, room.heroY*20+10, abilityRange*40);
  }
  textSize(24);
  fill(0);
  text("Hero moves left: "+(8-heroMoved), 670, 150);
  text("Hero abilities left: "+(2-abilitiesUsed), 670, 210);
  if (heroMoved > 7) {
    textSize(27);
    fill(255, 0, 0);
    text("MOVE LIMIT REACHED!\nPRESS ENTER TO\nEND TURN", 670, 540);
  }
  left = room.map[room.heroY][room.heroX-1];
  right = room.map[room.heroY][room.heroX+1];
  up = room.map[room.heroY-1][room.heroX];
  down = room.map[room.heroY+1][room.heroX];
  if (heroTurn) {
    if (countdown == 0 && heroMoved <= 7) {
      countdown+=30;
      if (keyboardInput.isPressed(Controller.C_LEFT)) {
        if (room.targeting) {
          if (room.map[room.targY][room.targX-1].calcDis(room.map[room.heroY][room.heroX]) < abilityRange) {
            room.swapTarget(room.targX-1, room.targY);
          } else {
            println("Out of ability range!");
          }
        } else if (!(room.map[room.heroY][room.heroX-1].isWall() || left.getChar() != null && left.getChar().getType().equals("enemy"))) {
          room.swap(room.heroX, room.heroY, room.heroX-1, room.heroY);
          room.heroX -= 1;
          room.hero.x--;
          heroMoved +=1;
          println(heroMoved);
        }
      }
      if (keyboardInput.isPressed(Controller.C_UP)) {
        if (room.targeting) {
          if (room.map[room.targY-1][room.targX].calcDis(room.map[room.heroY][room.heroX]) < abilityRange) {
            room.swapTarget(room.targX, room.targY-1);
          } else {
            println("Out of ability range!");
          }
        } else if (!(room.map[room.heroY-1][room.heroX].isWall() || up.getChar() != null && up.getChar().getType().equals("enemy"))) {
          room.swap(room.heroX, room.heroY, room.heroX, room.heroY-1);
          room.heroY -= 1;
          room.hero.y--;
          heroMoved +=1;
        }
      }
      if (keyboardInput.isPressed(Controller.C_DOWN)) {
        if (room.targeting) {
          if (room.map[room.targY+1][room.targX].calcDis(room.map[room.heroY][room.heroX]) < abilityRange) {
            room.swapTarget(room.targX, room.targY+1);
          } else {
            println("Out of ability range!");
          }
        } else if (!(room.map[room.heroY+1][room.heroX].isWall() || down.getChar() != null && down.getChar().getType().equals("enemy"))) {
          room.swap(room.heroX, room.heroY, room.heroX, room.heroY+1);
          room.heroY += 1;
          room.hero.y++;
          heroMoved +=1;
        }
      }
      if (keyboardInput.isPressed(Controller.C_RIGHT)) {
        if (room.targeting) {
          if (room.map[room.targY][room.targX+1].calcDis(room.map[room.heroY][room.heroX]) < abilityRange) {
            room.swapTarget(room.targX+1, room.targY);
          } else {
            println("Out of ability range!");
          }
        } else if (!(room.map[room.heroY][room.heroX+1].isWall() || right.getChar() != null && right.getChar().getType().equals("enemy"))) {
          room.swap(room.heroX, room.heroY, room.heroX+1, room.heroY);
          room.heroX += 1;
          room.hero.x++;
          heroMoved +=1;
        }
      }
      if (keyboardInput.isPressed(Controller.C_Confirm)) {
        if (room.targeting) {
          if (abilitiesUsed >= 2){
            println("CANNOT USE MORE ABILITIES!");
          }
          else if (ability == BASICATTACK) {
            room.attack(BASICATTACK);
            abilitiesUsed++;
          } else if (ability == ABILITY1) {
            room.attack(ABILITY1);
            abilitiesUsed++;
          }

          room.targetMode();
        }
      }
      if (keyboardInput.isPressed(Controller.C_BasicAttack)) {
        ability = 0;
        abilityRange = 5;
        room.targetMode();
      }
      if (keyboardInput.isPressed(Controller.C_Ability1)) {
        ability = 1;
        abilityRange = 3;
        room.targetMode();
      }
    }
    
    if (countdown > 0) {
      countdown --;
    }
    if (!keyPressed) {
      countdown = 0;
    }
    if (keyboardInput.isPressed(Controller.C_EndTurn)) {
      heroTurnEnd();
    }
    if (enemyTurn) {

      for (int i = 0; i < room.enemies.length; i++) {
        countdown = 0;
        while (room.enemies[i].moved < room.enemies[i].moveCap && !room.enemies[i].attacked) { // while enemy hasnt hit move cap and hasnt attacked
          println("MOVED: " + room.enemies[i].moved);
          if (enemyDistToHero(room.enemies[i], room.hero) >= 4 && countdown == 0) {// if enemy out of range
            println(i + " " + room.enemies[i].toString() + " attempting to move");
            pathFind(room.enemies[i], room.hero);
            countdown += 1000;
            room.enemies[i].moved++;
          } else if (countdown  == 0) { // hero in range
            println(room.enemies[i].toString() + " attacking");
            room.enemies[i].basicAttack(room.hero);
            room.enemies[i].attacked = true;
          }else{
            countdown--;
          }
        }
      }
      enemyTurnEnd();
    }
  }
}

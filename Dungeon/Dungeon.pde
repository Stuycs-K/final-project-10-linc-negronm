Room room = new Room(33, 33);
Controller keyboardInput;
int countdown;
boolean heroTurn =false;
boolean enemyTurn =false;
int heroMoved = 0;
int abilityRange;
int ability;
final static int BASICATTACK = 0;
final static int ABILITY1 = 1;
final static int ABILITY2 = 2;
Tile left, right, up, down;

public void heroTurn() {
  heroMoved =0;
  heroTurn = true;
}
public void heroTurnEnd() {
  heroTurn = false;
  enemyTurn();
}
public void enemyTurn() {
  enemyTurn = true;
  for (int i =0; i< room.enemies.length; i++) {
    room.enemies[i].attacked = false;
  }
}

public void pathFind(Enemy e, Hero h) {
  // keep moving x towards hero, then move y
  if (e.x < h.x && room.map[e.y][e.x+1].isWall() == false) { // enemy to the left and no wall
    room.swap(e.x, e.y, e.x+1, e.y);
  } else if (e.x > h.x && room.map[e.y][e.x-1].isWall() == false) { // enemy to the right and no wall
    room.swap(e.x, e.y, e.x-1, e.y);
  } else if (e.y > h.y && room.map[e.y-1][e.x].isWall() == false) { // enemy below and no wall
    room.swap(e.x, e.y, e.x, e.y-1);
  } else if (e.y < h.y && room.map[e.y+1][e.x].isWall() == false) { // enemy above and no wall
    room.swap(e.x, e.y, e.x, e.y+1);
  }
}

public float enemyDistToHero(Enemy e, Hero h) {
  return dist(e.x, e.y, h.x, h.y);
}

public void enemyTurnEnd() {
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
          if (ability == BASICATTACK) {
            room.attack(BASICATTACK);
          } else if (ability == ABILITY1) {
            room.attack(ABILITY1);
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
    if (key == ENTER || key == RETURN) {
      heroTurnEnd();
      enemyTurn();
    }
  }
  if (enemyTurn) {
    for (int i = 0; i < room.enemies.length; i++) {
      while (room.enemies[i].moved < room.enemies[i].moveCap && !room.enemies[i].attacked) { // while enemy hasnt hit move cap and hasnt attacked
        if (enemyDistToHero(room.enemies[i], room.hero) >= 4) {// if enemy out of range
          pathFind(room.enemies[i], room.hero);
          room.enemies[i].moved++;
        } else { // hero in range
          room.enemies[i].basicAttack(room.hero);
          room.enemies[i].attacked = true;
        }
      }
    }
  }


  enemyTurnEnd();
}

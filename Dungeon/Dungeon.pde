Room room;
Controller keyboardInput;
int countdown; //timer variable
boolean heroTurn =false;
boolean enemyTurn =false;
int heroMoved = 0;
String heroType;
int abilityRange;
int ability;
int abilitiesUsed;
int turnNum;
int roomNum = 0;
int enemiesKilled =0;
int cash = 0;
PImage bg;
boolean gameStarted = false;
Tile popupTile;
boolean popup = false;
final static int BASICATTACK = 0;
final static int ABILITY1 = 1;
final static int ABILITY2 = 2;
Tile left, right, up, down;

//turns methods
public void heroTurn() {
  //println("hero turn start");
  heroMoved =0;
  abilitiesUsed = 0;
  heroTurn = true;
}
public void heroTurnEnd() {
  //println("hero turn end");
  heroTurn = false;
  enemyTurn();
}
public void enemyTurn() {
  //println("enemy turn start");
  resetEnemyStates();
  enemyTurn = true;
}

public void pathFind(Enemy e, Hero h) {
  // keep moving x towards hero, then move y
  if (e.getX() < h.x && (room.map[e.getY()][e.getX()+1].isWall() == false && room.map[e.getY()][e.getX()+1].getChar() == null)) { // if enemy is left of hero and tile to right is not a wall or a character
    //println(e.toString() + " moving right");
    room.swap(e.getX(), e.getY(), e.getX()+1, e.getY());
  } else if (e.getX() > h.x && (room.map[e.getY()][e.getX()-1].isWall() == false && room.map[e.getY()][e.getX()-1].getChar() == null)) { // enemy to the right and no wall
    //println(e.toString() + " moving left");
    room.swap(e.getX(), e.getY(), e.getX()-1, e.getY());
  } else if (e.getY() > h.y && (room.map[e.getY()-1][e.getX()].isWall() == false && room.map[e.getY()-1][e.getX()].getChar() == null)) { // enemy below and no wall
    //println(e.toString() + " moving up");
    room.swap(e.getX(), e.getY(), e.getX(), e.getY()-1);
  } else if (e.getY() < h.y && (room.map[e.getY()+1][e.getX()].isWall() == false && room.map[e.getY()+1][e.getX()].getChar() == null)) { // enemy above and no wall
    //println(e.toString() + " moving down");
    room.swap(e.getX(), e.getY(), e.getX(), e.getY()+1);
  } else {
    //println("couldn't move");
  }
  //println("ENEMY AT: (" + e.getX() + "," + e.getY() + ")");
}


public void resetEnemyStates() {
  for (int i = 0; i < 6; i++) {
    room.enemies[i].attacked = false;
    room.enemies[i].moved = 0;
  }
  //println("----------------------------------------------------------------------------------------FINISHED LOOP");
}

public float enemyDistToHero(Enemy e, Hero h) {
  return dist(e.x * 20, e.y*20, h.x *20, h.y *20);
}
public float enemyDistToHero(Enemy e, int x, int y) {
  return dist(e.x * 20, e.y*20, x *20, y *20);
}

public void enemyTurnEnd() {
  //println("enemy turn end");
  enemyTurn = false;
  heroTurn();
}

public void printStats() {
  textAlign(CORNER);
  textSize(24);
  fill(0);
  text("Coins: " + cash, 670, 30);
  text("Hero moves left: "+(8-heroMoved), 670, 60);
  text("Hero abilities left: "+(2-abilitiesUsed), 670, 90);
  text("Kills needed: "+ (4-enemiesKilled), 670, 120);
  text("Turn number: " + turnNum, 670, 150);
  text("Room number: " + roomNum, 670, 180);
}

void setup() {
  room = new Room(33, 33, "a");
  bg = loadImage("bg.png");
  background(255);
  size(960, 660);
  textSize(24);
  fill(0);

  keyboardInput = new Controller();
  countdown =0;
  heroTurn();
}

void keyPressed() {
  keyboardInput.press(keyCode);
  if (key == 'r') {
    room = new Room(33, 33, heroType);
    gameStarted = false;
    room.generateRoom();
    roomNum = 0;
    heroMoved =0;
    turnNum = 0;
  }
  if (key == 't') {
    room.targetMode();
  }
  if (key == 'i') {
    popup = false;
  }
  if (key == 'z' && gameStarted == false) {
    heroType = "mage";
    room = new Room(33, 33, heroType);
    //println("gamestart");
    gameStarted = true;
    room.gameStarted = true;
    room.generateRoom();
    room.showRoom();
  }
}

void mousePressed() {
  popupTile = room.tileFromCoords(mouseX, mouseY);
  if (room.gameStarted && popupTile != null) {
    popup = true;
  }
}

void keyReleased() {
  keyboardInput.release(keyCode);
}
void draw() {
  background(255);
  room.showRoom();
  if (gameStarted) {
    //println("GAME ON!!!");
    if (room.targeting) { //targeting mode
      noFill();
      stroke(0, 255, 255);
      strokeWeight(5);
      circle(room.heroX*20+10, room.heroY*20+10, abilityRange*40);
      strokeWeight(1);
    }
    if (room.gameStarted) {
      printStats();
    }

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
      int deadCounter =0;
      for (int i =0; i< room.enemies.length; i++) {
        if (room.enemies[i].health <= 0) {
          deadCounter +=1;
        }
      }
      enemiesKilled =deadCounter;
      if ( room.heroX == room.exitX && room.heroY == room.exitY && enemiesKilled >= 4) { //if hero is at the exit, make a new room, reset the hero moves but keep health
        int damageTaken = room.hero.maxHealth - room.hero.health;
        room.generateRoom();
        roomNum++;
        heroMoved =0;
        room.hero.takeDmg(damageTaken);
      }else if(left.isTreasure() || right.isTreasure() || up.isTreasure() || down.isTreasure()){
        if(left.isTreasure()){
          left.randomBuff(room.hero);
          room.map[room.heroY][room.heroX-1] = new Tile(room.heroX-1, room.heroY);
        }
        if(right.isTreasure()){
          right.randomBuff(room.hero);
          room.map[room.heroY][room.heroX+1] = new Tile(room.heroX+1, room.heroY);
        }
        if(up.isTreasure()){
          up.randomBuff(room.hero);
          room.map[room.heroY -1][room.heroX] = new Tile (room.heroX, room.heroY -1);
        }
        if(down.isTreasure()){
          down.randomBuff(room.hero);
          room.map[room.heroY +1][room.heroX] = new Tile (room.heroX, room.heroY +1);
        }
      }else if (countdown == 0 && heroMoved <= 7 || countdown == 0 && keyboardInput.isPressed(Controller.C_EndTurn)) {
        countdown+=30;
        if (keyboardInput.isPressed(Controller.C_LEFT)) {
          if (room.targeting) { //for a direction does targetting to check range
            if (room.map[room.targY][room.targX-1].calcDis(room.map[room.heroY][room.heroX]) < abilityRange) {
              room.swapTarget(room.targX-1, room.targY);
            } else {
              println("Out of ability range!");
            }
          } else if (!(room.map[room.heroY][room.heroX-1].isWall() || left.getChar() != null && left.getChar().getType().equals("enemy"))) {
            room.swap(room.heroX, room.heroY, room.heroX-1, room.heroY); // movement in a direction
            room.heroX -= 1;
            room.hero.x--;
            heroMoved +=1;
            //println(heroMoved);
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
            if (abilitiesUsed >= 2) {
              println("CANNOT USE MORE ABILITIES!");
            } else if (ability == BASICATTACK) {
              room.attack(BASICATTACK);
            } else if (ability == ABILITY1) {
              room.attack(ABILITY1);
            } else if (ability == ABILITY2) {
              room.attack(ABILITY2);
            }

            room.targetMode();
          }
        }
        if (keyboardInput.isPressed(Controller.C_BasicAttack) && (turnNum >= room.hero.basicStats[1] + room.hero.basicStats[2])) {
          ability = 0;
          abilityRange = room.hero.basicStats[0];
          room.hero.basicStats[2] = turnNum;
          room.targetMode();
        }
        if (keyboardInput.isPressed(Controller.C_Ability1)&& (turnNum >= room.hero.ability1Stats[1] + room.hero.ability1Stats[2])) {
          ability = 1;
          abilityRange = room.hero.ability1Stats[0];
          room.hero.ability1Stats[2] = turnNum;
          room.targetMode();
        }
        if (keyboardInput.isPressed(Controller.C_Ability2)&& (turnNum >= room.hero.ability2Stats[1] + room.hero.ability2Stats[2])) {
          ability = 2;
          abilityRange = room.hero.ability2Stats[0];
          room.hero.ability2Stats[2] = turnNum;
          room.targetMode();
        }
        if (keyboardInput.isPressed(Controller.C_EndTurn)) {
          if (room.targeting) {
            room.targetMode();
          }
          turnNum++;
          keyboardInput.inputs[Controller.C_EndTurn] = false;
          heroTurnEnd();
        }
      }



      if (countdown > 0) {
        countdown --;
      }
      if (!keyPressed) {
        countdown = 0;
      }


      if (enemyTurn) {

        for (int i = 0; i < room.enemies.length; i++) {
          while (room.enemies[i].moved < room.enemies[i].moveCap && !room.enemies[i].attacked) { // while enemy hasnt hit move cap and hasnt attacked
            //println("MOVED: " + room.enemies[i].moved);
            float eDist = enemyDistToHero(room.enemies[i], room.hero);
            if (eDist >= 80 && room.enemies[i].getHealth() > 0) {// if enemy out of range
              //println(eDist + "tiles away");
              //println(i + " " + room.enemies[i].toString() + " attempting to move");
              pathFind(room.enemies[i], room.hero);
              room.enemies[i].moved++;
            } else { // hero in range
              //println(room.enemies[i].toString() + " attacking");
              room.enemies[i].attack(room);
              room.enemies[i].attacked = true;
            }
          }
        }
        enemyTurnEnd();
      }
    }
    if (popup) {
      room.showTileInfo(popupTile);
    }
  }
}

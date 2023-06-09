Room room;
Controller keyboardInput; //used to take inputs from the player
int countdown; //timer variable
boolean heroTurn =false;
boolean enemyTurn =false;
int heroMoved = 0;
String heroType = "a";
int abilityRange;
int ability;
int abilitiesUsed;
int turnNum;
int roomNum = 0;
int enemiesKilled =0;
PImage bg, over, knight, mage, rogue, skeleton, skeletonCorpse, warlock, warlockCorpse, arbalist, arbalistCorpse, treasureTile; //images for game elements
boolean gameStarted = false;
Tile popupTile;
boolean popup = false;
String heroInQuestion;
int totalEnemiesKilled = 0;
ArrayList<String> console = new ArrayList<String>(6); //Console is a way to display hero and enemy actions
final static int BASICATTACK = 0;
final static int ABILITY1 = 1;
final static int ABILITY2 = 2;
Tile left, right, up, down;

//turns methods, used to swithch between the player's and computer's turn
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
public void enemyTurnEnd() {
  //println("enemy turn end");
  enemyTurn = false;
  heroTurn();
}

public void pathFind(Enemy e, Hero h) {
  // causes enemies to keep moving x towards hero, then move y
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


public void resetEnemyStates() { //resets the enemies between turns
  for (int i = 0; i < 6; i++) {
    room.enemies[i].attacked = false;
    room.enemies[i].moved = 0;
  }
  //println("----------------------------------------------------------------------------------------FINISHED LOOP");
}

public float enemyDistToHero(Enemy e, Hero h) { //calculates the distance from a particular enemy to a hero
  return dist(e.x * 20, e.y*20, h.x *20, h.y *20);
}
public float enemyDistToHero(Enemy e, int x, int y) {
  return dist(e.x * 20, e.y*20, x *20, y *20);
}

public void addToConsole(String s){ //adds actions to console and only stores 6 actions
  console.add(s);
  if (console.size() > 6){
    console.remove(0);
  }
}

public void printStats() { //prints out the numbers useful to the player
  textAlign(CORNER);
  textSize(24);
  fill(0);
  text("Room number: " + roomNum, 670, 30);
  text("Turn number: " + turnNum, 670, 60);
  if (enemiesKilled >= 4) {
    text("Kills needed: 0", 670, 90);
  } else {
    text("Kills needed: "+ (4-enemiesKilled), 670, 90);
  }
  text("Hero moves left: "+(8-heroMoved), 670, 120);
  text("Hero abilities left: "+(2-abilitiesUsed), 670, 150);
  text("Damage buff: " + (int((room.hero.damageBuff-1.0)*100)) + "%", 670, 180);
}

public void printConsole() { //prints out the console in a rectangle with text in it
  int start = 240;
  String cons = "";
  for (int i = 0; i < console.size(); i++){
    cons+= console.get(i) + "\n";
  }
  stroke(255);
  fill(0);
  rect(665, start-5, 290, 330);
  fill(255);
  textSize(18);
  text(cons, 670, start, 285, 330);
}

void setup() {
  room = new Room(33, 33, "a"); 
  bg = loadImage("bg.png"); //Loads the images associated with different game elements
  over = loadImage("over.png");
  knight = loadImage("knight.png");
  mage = loadImage("mage.png");
  rogue = loadImage("rogue.png");
  skeleton = loadImage("skeleton.png");
  skeletonCorpse = loadImage("skeletonCorpse.png");
  warlock = loadImage("warlock.png");
  warlockCorpse = loadImage("warlockCorpse.png");
  arbalist = loadImage("arbalist.png");
  arbalistCorpse = loadImage("arbalistCorpse.png");
  treasureTile = loadImage("treasureTile.png");
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
  if (key == 'r') { //restarts the run
    room = new Room(33, 33, heroType);
    gameStarted = false;
    room.generateRoom();
    roomNum = 0;
    heroMoved =0;
    turnNum = 0;
  }
  if (key == 't') { //targeting
    room.targetMode();
  }
  if (key == 'i') { //closes the info popups
    popup = false;
  }
  if (gameStarted == false && key == 'z' || key == 'x' || key == 'c') { //character selection
    if (key == 'z')
      heroType = "mage";
    if (key == 'x')
      heroType = "knight";
    if (key == 'c')
      heroType = "rogue";

    heroInQuestion = heroType;
    room = new Room(33, 33, heroType);
    //println("gamestart");
    gameStarted = true;
    room.gameStarted = true;
    room.generateRoom();
    room.showRoom();
  }
}

void mousePressed() {
  if (gameStarted) { //does a popup about the info associated with a tile/character
    popupTile = room.tileFromCoords(mouseX, mouseY);
    if (room.gameStarted && popupTile != null) {
      popup = true;
    }
  } else {
    if (mouseX >= 20 && mouseX <= 100 && mouseY >= 510 && mouseY <= 590) { // mage info
      //println("magfe into");
      popup = true;
      heroInQuestion = "mage";
    } else if (mouseX >= 120 && mouseX <= 200 && mouseY >= 510 && mouseY <= 590) { // knight info
      //println("knight info");
      popup = true;
      heroInQuestion = "knight";
    } else if (mouseX >= 220 && mouseX <= 300 && mouseY >= 510 && mouseY <= 590) { // knight info
      //println("rogue info");
      popup = true;
      heroInQuestion = "rogue";
    }
  }
}

void keyReleased() { //helps controller work
  keyboardInput.release(keyCode);
}
void draw() {
  background(255);
  room.showRoom();
  if (gameStarted) { //checks for not being in the character select screen
    //println("GAME ON!!!");
    if (room.targeting) { //targeting mode
      noFill();
      stroke(0, 255, 255);
      strokeWeight(5);
      circle(room.heroX*20+10, room.heroY*20+10, abilityRange*2);
      strokeWeight(1);
    }
    if (room.gameStarted && room.hero.getHealth() > 0) { //prints out stats and console as long as you're not on the character select or game over screens
      printStats();
      printConsole();
    }

    if (heroMoved > 7) { //tells player to end turn when move limit is reached
      textSize(27);
      fill(255, 0, 0);
      text("MOVE LIMIT REACHED!", 670, 600);
      textSize(24);
      text("PRESS ENTER TO END TURN", 670, 630);
    }
    left = room.map[room.heroY][room.heroX-1]; //The tiles next to the player
    right = room.map[room.heroY][room.heroX+1];
    up = room.map[room.heroY-1][room.heroX];
    down = room.map[room.heroY+1][room.heroX];

    if (heroTurn) { //hero turn
      enemiesKilled =0;
      for (int i =0; i< room.enemies.length; i++) { //updates enemiesKilled
        if (room.enemies[i].health <= 0) {
          enemiesKilled +=1;
        }
      }
      room.enemiesKilled = enemiesKilled;
      if ( room.heroX == room.exitX && room.heroY == room.exitY && enemiesKilled >= 4) { //if hero is at the exit, make a new room, reset the hero moves and damageBuff but keep health
        room.generateRoom();
        roomNum++;
        heroMoved =0;
        //room.hero.takeDmg(damageTaken);
        room.hero.damageBuff = 1.0;
      }else if(left.isTreasure() || right.isTreasure() || up.isTreasure() || down.isTreasure()){ //checks if player is next to a treasure tile and activates the treasure
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
      }else if (countdown == 0 && heroMoved <= 7 || countdown == 0 && keyboardInput.isPressed(Controller.C_EndTurn)) { //Hero action portion
        countdown+=30;
        if (keyboardInput.isPressed(Controller.C_LEFT)) {
          if (room.targeting) { //for a direction moves targeting
            if (room.targX > 0 && room.map[room.targY][room.targX-1].calcDis(room.map[room.heroY][room.heroX]) < abilityRange) {
              room.swapTarget(room.targX-1, room.targY);
            } else {
              addToConsole("Out of ability range!");
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
          if (room.targeting) {//for a direction moves targeting
            if (room.targY > 0 && room.map[room.targY-1][room.targX].calcDis(room.map[room.heroY][room.heroX]) < abilityRange) {
              room.swapTarget(room.targX, room.targY-1);
            } else {
              addToConsole("Out of ability range!");
            }
          } else if (!(room.map[room.heroY-1][room.heroX].isWall() || up.getChar() != null && up.getChar().getType().equals("enemy"))) {
            room.swap(room.heroX, room.heroY, room.heroX, room.heroY-1);// movement in a direction
            room.heroY -= 1;
            room.hero.y--;
            heroMoved +=1;
          }
        }
        if (keyboardInput.isPressed(Controller.C_DOWN)) {
          if (room.targeting) {//for a direction moves targeting
            if (room.targY < room.ySize-1 && room.map[room.targY+1][room.targX].calcDis(room.map[room.heroY][room.heroX]) < abilityRange) {
              room.swapTarget(room.targX, room.targY+1);
            } else {
             addToConsole("Out of ability range!");
            }
          } else if (!(room.map[room.heroY+1][room.heroX].isWall() || down.getChar() != null && down.getChar().getType().equals("enemy"))) {
            room.swap(room.heroX, room.heroY, room.heroX, room.heroY+1); // movement in a direction
            room.heroY += 1;
            room.hero.y++;
            heroMoved +=1;
          }
        }
        if (keyboardInput.isPressed(Controller.C_RIGHT)) {
          if (room.targeting) {//for a direction moves targeting
            if (room.targX < room.xSize-1 && room.map[room.targY][room.targX+1].calcDis(room.map[room.heroY][room.heroX]) < abilityRange) {
              room.swapTarget(room.targX+1, room.targY);
            } else {
             addToConsole("Out of ability range!");
            }
          } else if (!(room.map[room.heroY][room.heroX+1].isWall() || right.getChar() != null && right.getChar().getType().equals("enemy"))) {
            room.swap(room.heroX, room.heroY, room.heroX+1, room.heroY); // movement in a direction
            room.heroX += 1;
            room.hero.x++;
            heroMoved +=1;
          }
        }
        if (keyboardInput.isPressed(Controller.C_Confirm)) { //confirms an attack or ability by the player for all 3 possible actions
          if (room.targeting) {
            if (abilitiesUsed >= 2) {
             addToConsole("CANNOT USE MORE ABILITIES!");
            } else if (ability == BASICATTACK) {
              room.attack(BASICATTACK);
              room.hero.basicStats[2] = turnNum;
            } else if (ability == ABILITY1) {
              room.attack(ABILITY1);
              room.hero.ability1Stats[2] = turnNum;
            } else if (ability == ABILITY2) {
              room.attack(ABILITY2);
              room.hero.ability2Stats[2] = turnNum;
            }
            
            room.targetMode();
          }
        }
        if (keyboardInput.isPressed(Controller.C_BasicAttack) && (turnNum >= room.hero.basicStats[1] + room.hero.basicStats[2])) { // turn num is greater than or equal to cooldown + turn last used
          ability = BASICATTACK; //calls for a Basic attack
          abilityRange = room.hero.basicStats[0];
          room.targetMode();
        }
        if (keyboardInput.isPressed(Controller.C_Ability1)&& (turnNum >= room.hero.ability1Stats[1] + room.hero.ability1Stats[2])) {
          ability = ABILITY1; //calls for ability 1
          abilityRange = room.hero.ability1Stats[0];
          room.targetMode();
        }
        if (keyboardInput.isPressed(Controller.C_Ability2)&& (turnNum >= room.hero.ability2Stats[1] + room.hero.ability2Stats[2])) {
          ability = ABILITY2; // calls for ability 2
          abilityRange = room.hero.ability2Stats[0];
          room.targetMode();
        }
        if (keyboardInput.isPressed(Controller.C_EndTurn)) { //ends hero turn
          if (room.targeting) {
            room.targetMode();
          }
          turnNum++;
          keyboardInput.inputs[Controller.C_EndTurn] = false;
          heroTurnEnd();
        }
      }



      if (countdown > 0) { //timer counting down
        countdown --;
      }
      if (!keyPressed) { //resets if keys are not pressed
        countdown = 0;
      }


      if (enemyTurn) {

        for (int i = 0; i < room.enemies.length; i++) { //loops over all enemies in a room
          while (room.enemies[i].moved < room.enemies[i].moveCap && !room.enemies[i].attacked) { // while enemy hasnt hit move cap and hasnt attacked
            //println("MOVED: " + room.enemies[i].moved);
            float eDist = enemyDistToHero(room.enemies[i], room.hero);
            if (room.enemies[i].isStunned){
              room.enemies[i].attack(room);
              room.enemies[i].attacked = true;
            }
            else if (eDist >= room.enemies[i].range && room.enemies[i].getHealth() > 0) {// if enemy out of range
              //println(eDist + "tiles away");
              //println(i + " " + room.enemies[i].toString() + " attempting to move");
              pathFind(room.enemies[i], room.hero);
              room.enemies[i].moved++;
            } else if (!room.isWallBetween(room.enemies[i].getX(), room.enemies[i].getY(), room.heroX, room.heroY)) { // hero in range and not behind wall
              //println(room.enemies[i].toString() + " attacking");
              room.enemies[i].attack(room);
              room.enemies[i].attacked = true;
            } else {
              room.enemies[i].attacked = true;
            }
          }
        }
        enemyTurnEnd();
      }
    }
    if (popup) { //popup function
      room.showTileInfo(popupTile);
    }
  }
  if (popup && !gameStarted) {
    room.showHeroInfo(heroInQuestion);
  }
}

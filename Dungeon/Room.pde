class Room {
  private Tile[][] map; //  2d tile array
  private int exitX, exitY; // exit coords
  private int enemiesKilled, enemyCount; // enemy stats
  private String[] enemyClasses = new String[]{"skeleton", "warlock", "arbalist"}; // different enemy types
  public int ySize, xSize; // size of map
  public int heroX, heroY; // hero coords
  public boolean targeting; // targeting mode
  public int targX, targY; // target coords
  public int warlockCt, arbCt; // number of certain enemies
  public Enemy[] enemies; // enemy list
  public Hero hero; // the hero
  public boolean gameStarted; // is game started
  int fountainCt = 0; // number of treasure tiles



  public Room(int xsize, int ysize, String HERO) { // constructor
    map = new Tile[ysize][xsize];
    ySize = ysize;
    xSize = xsize;
    exitX = xsize-2;
    exitY = ysize/2;
    heroX = 1;
    heroY = ysize/2;
    enemiesKilled = 0;
    targeting = false;
    targX = heroX;
    targY = heroY;
    if (HERO.equals("mage")) {
      hero = new Mage(heroX, heroY);
    } else if (HERO.equals("knight")) {
      hero = new Knight(heroX, heroY);
    } else if (HERO.equals("rogue")) {
      hero = new Rogue(heroX, heroY);
    } else {
      //println("invalid");
    }
    warlockCt = 0;
    gameStarted = false;
  }

  public void rotateMap() { // rotates map 90 degrees, for generation purposes
    Tile[][] newMap = new Tile[ySize][xSize];
    for (int y = 0; y < ySize; y++) {
      for (int x = 0; x < xSize; x++) {
        newMap[y][x] = map[x][y];
        map[y][x].setY(x);
        map[y][x].setX(y);
      }
    }
    map = newMap;
  }

  private boolean isIn(int[] arr, int num) { // is a number in an array, generation helper
    for (int i = 0; i < arr.length; i++) {
      if (arr[i] == num) {
        return true;
      }
    }
    return false;
  }

  private Tile[] makeWall(int size, int y) { // make a wall with a gap, for generation
    Tile[] wall = new Tile[size];
    int gapStart = int(random(1, size-10));
    for (int i = 0; i < size; i++) {
      if (i >= gapStart && i < gapStart+10) {
        wall[i] = new Tile(i, y);
      } else {
        wall[i] = new Wall(i, y);
      }
    }
    return wall;
  }

  private Enemy chooseEnemy(int i, int X, int Y) { // translates number into enemy, for generation
    Enemy e;
    if (i == 0) {
      e = new Skeleton(X, Y);
    } else if (i == 1) {
      e = new Warlock(X, Y);
    } else if (i == 2) {
      e = new Arbalist(X, Y);
    } else {
      e = new Enemy(10, X, Y);
    }
    return e;
  }

  public void swap(int x, int y, int desX, int desY) { // swaps 2 tiles and changes their coords
    //println("tile at (" + x + "," + y + ") now at (" + desX + "," + desY + ")");
    Tile oldTile = map[desY][desX];
    Tile moved = map[y][x];
    map[desY][desX] = moved;
    map[y][x] = oldTile;
    moved.setX(desX);
    moved.setY(desY);
    oldTile.setX(x);
    oldTile.setY(y);
    if (moved.getChar() != null) {
      moved.getChar().setX(desX);
      moved.getChar().setY(desY);
    }
    //println("MOVED TILE NOW AT: " + moved.getX() + "," + moved.getY() + ")");
  }


  public void swapTarget(int x, int y) { // swaps targeted tile
    if (x < 0 || x >= xSize || y < 0 || y >= ySize) {
      return;
    }
    map[targY][targX].untarget();
    map[y][x].target();
    targY = y;
    targX = x;
  }

  public void targetMode() { // toggles target mode
    targeting = !targeting;
    swapTarget(heroX, heroY);
  }

  public void attack(int ability) { // does attack based on ability and hero selection
    if (hero.getClassif().equals("knight")) { // knight
      if (ability == BASICATTACK) {
        for (int i = 0; i < enemies.length; i++) { // search enemies
          Enemy e = enemies[i];
          if (map[e.getY()][e.getX()].isTargeted && !(isWallBetween(heroX, heroY, e.getX(), e.getY())) && e.getHealth() > 0) { // if healthy enemy targeted and no wall between
            hero.basicAttack(e);
            addToConsole("You chopped a " + e.getClassif() + " with your battleaxe!");
            abilitiesUsed++;
            map[e.getY()][e.getX()].untarget();
          }
        }
      }

      if (ability == ABILITY1) { // intimidate
        for (int i = 0; i < enemies.length; i++) { // search enemies
          Enemy e = enemies[i];
          if (map[e.getY()][e.getX()].isTargeted && !(isWallBetween(heroX, heroY, e.getX(), e.getY())) && e.getHealth() > 0) { // if healthy enemy targeted and no wall between
            hero.ability1(e);
            addToConsole("You hit a " + e.getClassif() + " over the head and stunned it!");
            abilitiesUsed++;
            map[e.getY()][e.getX()].untarget();
          }
        }
      }

      if (ability == ABILITY2) { // inspire
        hero.ability2();
        addToConsole("You unleashed a battlecry and inspired yourself!");
        abilitiesUsed++;
      }
    }// end of knight


    else if (hero.getClassif().equals("mage")) { // mage abs
      if (ability == BASICATTACK) { // hex
        for (int i = 0; i < enemies.length; i++) { // search enemies
          Enemy e = enemies[i];
          if (map[e.getY()][e.getX()].isTargeted && e.getHealth() > 0) { // if healthy enemy targeted
            hero.basicAttack(e);
            addToConsole("You cast a hex on a " + e.getClassif() + "!");
            abilitiesUsed++;
            map[e.getY()][e.getX()].untarget();
          }
        }
      }

      if (ability == ABILITY1) { // artillery
        hero.ability1(this);
        addToConsole("You called upon the abyss to strike down nearby enemies!");
        abilitiesUsed++;
      }

      if (ability == ABILITY2) { // life steal
        for (int i = 0; i < enemies.length; i++) { // search enemies
          Enemy e = enemies[i];
          if (map[e.getY()][e.getX()].isTargeted && e.getHealth() > 0) { // if healthy enemy
            hero.ability2(e);
            addToConsole("You drained a " + e.getClassif() + " of its lifeforce!");
            abilitiesUsed++;
            map[e.getY()][e.getX()].untarget();
          }
        }
      }
    } // end of mage

    else if (hero.getClassif().equals("rogue")) { //pistol shot
      if (ability == BASICATTACK) {
        for (int i = 0; i < enemies.length; i++) { // search enemies
          Enemy e = enemies[i];
          if (map[e.getY()][e.getX()].isTargeted && !(isWallBetween(heroX, heroY, e.getX(), e.getY())) && e.getHealth() > 0) { // if healthy enemy targeted and no wall between
            hero.basicAttack(e);
            addToConsole("You took aim and shot a " + e.getClassif() + "!");
            abilitiesUsed++;
            map[e.getY()][e.getX()].untarget();
          }
        }
      }

      if (ability == ABILITY1) { // pbs
        for (int i = 0; i < enemies.length; i++) { // search enemies
          Enemy e = enemies[i];
          if (map[e.getY()][e.getX()].isTargeted && !(isWallBetween(heroX, heroY, e.getX(), e.getY())) && e.getHealth() > 0) { // if healthy enemy targeted and no wall between
            hero.ability1(e);
            addToConsole("You hit a " + e.getClassif() + " with a point blank shot!");
            abilitiesUsed++;
            map[e.getY()][e.getX()].untarget();
          }
        }
      }

      if (ability == ABILITY2) { // open vein
        for (int i = 0; i < enemies.length; i++) { // search enemies
          Enemy e = enemies[i];
          if (map[e.getY()][e.getX()].isTargeted && !(isWallBetween(heroX, heroY, e.getX(), e.getY())) && e.getHealth() > 0) { // if healthy enemy targeted and no wall between
            hero.ability2(e);
            addToConsole("You sliced a " + e.getClassif() + " and healed!");
            abilitiesUsed++;
            map[e.getY()][e.getX()].untarget();
          }
        }
      }
    } // end of rogue
  }

  public void generateRoom() { // randomly generates a room with walls, enemies, and treasure.
    enemyCount = 0;
    enemiesKilled = 0;
    map = new Tile[xSize][ySize];
    int space = xSize/4-1;
    int[] walls = new int[]{space*1-1, space*2-1, space*3-1, space*4-1}; // makes walls at certain intervals
    heroX = 1;
    heroY = ySize/2;

    for (int y = 0; y < ySize; y++) {
      if (isIn(walls, y)) { // if row is selected for walling
        map[y] = makeWall(xSize, y); // puts a wall there
      } else {
        for (int x = 0; x < xSize; x++) {
          if (y == 0 || y == ySize-1 || x == 0 || x == xSize-1) { // if edge
            map[y][x] = new Wall(x, y);
          } else { // places treasure
            int chance = (int)random(0, 300);
            if ( chance == 0) {
              map[y][x] = new TreasureTile(x, y);
              fountainCt++;
            } else {
              map[y][x] = new Tile(x, y); // places floor
            }
          }
        }
      }
    }

    rotateMap(); // rotates it 90 degrees, proper orientation
    if (map[ySize/2][1].isWall()) { // if hero tile is a wall, remove it
      map[ySize/2][1] = new Tile(1, ySize/2);
    }
    map[ySize/2][1].setChar(hero); // place the hero
    // PLACING ENEMIES
    enemies = new Enemy[6];
    Enemy e;
    int randx, randy, randClass;
    int i = 0;
    warlockCt = 0;
    arbCt = 0;
    while (enemyCount < 6) { // while there are less than 6 enemies, generate a random one and place it randomly
      randx = int(random(xSize/2, xSize));
      randy = int(random(1, ySize-1));
      if (map[randy][randx].isWall() == false && map[randy][randx].getChar() == null) { // if its a valid spawning location
        randClass = int(random(0, enemyClasses.length));
        while (randClass == 1 && warlockCt >= 2 || randClass == 2 && arbCt >= 1) { // if it tries to generate a warlock/arb with too many on screen
          randClass = int(random(0, enemyClasses.length));
        }
        if (randClass == 1) {
          warlockCt++;
        }
        if (randClass == 2) {
          arbCt++;
        }
        e = chooseEnemy(randClass, randx, randy);
        map[randy][randx].setChar(e);
        enemyCount++;
        enemies[i] = e;
        i++;
      }
    }

    while (fountainCt < 3) { // ensures minimum 3 fountains
      randx = int(random(1, xSize-1));
      randy = int(random(1, ySize-1));
      if (map[randy][randx].isWall() == false && map[randy][randx].getChar() == null) {
        map[randy][randx] = new TreasureTile(randx, randy);
        fountainCt++;
      }
    }
  }

  public void showRoom() { // displays the room
    if (!(gameStarted)) { // character select screen
      background(0);
      image(bg, 0, 0);
      fill(255, 0, 0);
      textAlign(CENTER);
      textSize(48);
      text("CALIGINOUS CELLAR", width/2, 80);
      textSize(24);
      text("How far can you get?", width/2, 110);
      textSize(32);
      textAlign(CORNER);
      text("Select a character to continue:", 20, 3*height/4);
      fill(0, 0, 255);
      stroke(255);
      rect(20, 510, 80, 80);
      fill(120);
      rect(120, 510, 80, 80);
      fill(2, 48, 32);
      rect(220, 510, 80, 80);
      fill(255);
      textAlign(CENTER);
      text("Z", 60, 560);
      text("Mage", 60, 620);
      text("X", 160, 560);
      text("Knight", 160, 620);
      text("C", 260, 560);
      text("Rogue", 260, 620);
      textSize(24);
      text("WASD to move/target", width/2, 160);
      text("1, 2, 3 to select/deselect abilities", width/2, 190);
      text("SPACE to confirm a hit", width/2, 220);
      text("ENTER to end a turn", width/2, 250);
      text("Click on a tile/hero to learn more about it!", width/2, 280);
    } else if (hero.getHealth() <= 0) { // game over screen
      background(0);
      image(over, 0, 0);
      fill(255, 0, 0);
      textAlign(CENTER);
      textSize(48);
      text("GAME OVER!", width/2, height/4);
      fill(255);
      textSize(24);
      text("You made it " + roomNum + " rooms.", width/2, height/4 + 50);
      text("Press 'R' to restart.", width/2, height/4 + 80);
    } else { // game
      textAlign(LEFT);
      int x = 0;
      int y = 0;
      stroke(255);
      strokeWeight(1);
      // displays map
      while (x < map[0].length) {
        while (y < map.length) {
          if (map[y][x].isWall() == true) {
            fill(0);
            rect(x*20, y*20, 20, 20);
          } else if (x == exitX && y == exitY) {
            fill (255, 0, 255);
            rect(x*20, y*20, 20, 20);
          } else if (map[y][x].getChar() != null) {
            if (map[y][x].getChar().getType().equals("hero")) {
              if (map[y][x].getChar().getClassif().equals("mage")) {
                fill(0, 0, 255);
              } else if (map[y][x].getChar().getClassif().equals("knight")) {
                fill (120);
              } else if (map[y][x].getChar().getClassif().equals("rogue")) {
                fill(2, 48, 32);
              }
              rect(x*20, y*20, 20, 20);
            } else if (map[y][x].getChar().getType().equals("enemy")) {
              Character e = map[y][x].getChar();
              if (e.getHealth() <= 0) {
                fill(145, 105, 105);
              } else if (e.getClassif().equals("skeleton")) {
                fill(255, 0, 0);
              } else if (e.getClassif().equals("warlock")) {
                fill(150, 0, 255);
              } else if (e.getClassif().equals("arbalist")) {
                fill (61, 43, 31);
              } else {
                fill (0);
              }
              rect(x*20, y*20, 20, 20);
            }
            fill(0);
            textSize(14);
            if (map[y][x].getChar().health > 0) {
              textAlign(CENTER);
              text(map[y][x].getChar().health, x*20+10, y*20);
            }
          } else if (map[y][x].isTreasure()) {
            fill(0, 255, 0);
            rect(x*20, y*20, 20, 20);
          } else {
            fill(200);
            rect(x*20, y*20, 20, 20);
          }

          fill(255);
          textSize(8);
          textAlign(CENTER);
          //text(""+map[y][x].getX()+","+map[y][x].getY(), x*20+10, y*20+10); // coordinates
          if (targeting && map[y][x].isTargeted) { // displays target
            noFill();
            stroke(255, 255, 0);
            rectMode(CENTER);
            rect(x*20+10, y*20+10, 10, 10);
          }
          if (map[y][x].hasEnemy() && map[y][x].getChar().isStunned()) { // displays stunned characters
            //println("stunned");
            noFill();
            stroke(255, 255, 0);
            rectMode(CENTER);
            strokeWeight(4);
            rect(x*20+10, y*20+10, 18, 18);
            strokeWeight(1);
          }
          rectMode(CORNER);
          stroke(255);
          y++;
        }
        x++;
        y = 0;
      }
      textSize(24);
      fill(0);
    }
  }


  public Tile tileFromCoords(int x, int y) { // returns tile given coords, helper for mouse click
    if (x > 660) {
      return null;
    }
    int tileCol = x/20;
    int tileRow = y/20;
    return map[tileRow][tileCol];
  }




  public boolean isWallBetween(int X, int Y, int desX, int desY) { //checks if a wall Tile exists between two tiles
    boolean result = false;
    if (desX > X) { // loop from x to des x
      if (desY > Y) { // loop from y to des y
        for (int i =X; i <=desX; i++) { // same y different x
          if (map[Y][i].isWall()) {
            result = true;
          }
          if (map[desY][i].isWall()) {
            result = true;
          }
        }
        for (int i =Y; i <=desY; i++) { // same x different y
          if (map[i][X].isWall()) {
            result = true;
          }
          if (map[i][desX].isWall()) {
            result = true;
          }
        }
      } else if ( desY == Y) { // same y level
        for (int i =X; i <=desX; i++) { // go thru x
          if (map[Y][i].isWall()) {
            result = true;
          }
        }
      } else { // des y to y
        for (int i =X; i <=desX; i++) { // same y different x
          if (map[Y][i].isWall()) {
            result = true;
          }
          if (map[desY][i].isWall()) {
            result = true;
          }
        }
        for (int i =desY; i <=Y; i++) {
          if (map[i][X].isWall()) {
            result = true;
          }
          if (map[i][desX].isWall()) {
            result = true;
          }
        }
      }
    } else if ( desX == X) { // same x level
      if (desY > Y) { // y to des y
        for (int i =Y; i <=desY; i++) {
          if (map[i][X].isWall()) {
            result = true;
          }
        }
      } else if ( desY == Y) { // same thing entirely
        result = map[Y][X].isWall();
      } else { // des y to y
        for (int i =desY; i <=Y; i++) {
          if (map[i][X].isWall()) {
            result = true;
          }
        }
      }
    } else {
      if (desY > Y) {
        for (int i =desX; i <=X; i++) {
          if (map[Y][i].isWall()) {
            result = true;
          }
          if (map[desY][i].isWall()) {
            result = true;
          }
        }
        for (int i =Y; i <=desY; i++) {
          if (map[i][X].isWall()) {
            result = true;
          }
          if (map[i][desX].isWall()) {
            result = true;
          }
        }
      } else if ( desY == Y) {
        for (int i =desX; i <=X; i++) {
          if (map[Y][i].isWall()) {
            result = true;
          }
        }
      } else {
        for (int i =desX; i <=X; i++) {
          if (map[Y][i].isWall()) {
            result = true;
          }
          if (map[desY][i].isWall()) {
            result = true;
          }
        }
        for (int i =desY; i <=Y; i++) {
          if (map[i][X].isWall()) {
            result = true;
          }
          if (map[i][desX].isWall()) {
            result = true;
          }
        }
      }
    }
    return result;
  }

  public void showHeroInfo(String h) { // displays info for a hero
    fill(0, 50);
    strokeWeight(0);
    rect(0, 0, 960, 660);
    stroke(255);
    strokeWeight(5);
    rectMode(CENTER);
    fill(0);
    rect(width/2, height/2, 480, 330, 15);
    rectMode(CORNER);
    if (h.equals("mage")) { // mage
      textAlign(CENTER);
      textSize(36);
      fill(255);
      strokeWeight(3);
      text("MAGE", width/2, height/2-125);
      textAlign(CENTER);
      image(mage, 260, 195, 141, 257);
      textSize(18);
      text("Press 'I' to dismiss", width/2, height/2+150); // dismiss
      textAlign(CORNER);
      text(" - A mysterious man with knowledge of the occult. " +
        " \n- Frail, but can target multiple enemies." +
        " \n- Ability one: Abyssal Artillery: Do damage within 4 tiles." +
        " \n- Ability two: Life Sap: Steals lifeforce from the enemy.", width/2-75, height/2-95, 310, 230);
    } else if (h.equals("knight")) { // knight
      textAlign(CENTER);
      textSize(36);
      fill(255);
      strokeWeight(3);
      text("KNIGHT", width/2, height/2-125);
      image(knight, 260, 195, 141, 257);
      textSize(18);
      text("Press 'I' to dismiss", width/2, height/2+150); // dismiss
      textAlign(CORNER);
      text(" - A helmeted man with a heavy handaxe. " +
        " \n- Strong and can empower himself!" +
        " \n- Ability one: Intimidate: Do less damage, but stun the enemy." +
        " \n- Ability two: Inspiring Cry: Heal and buff yourself.", width/2-75, height/2-95, 330, 230);
    } else if (h.equals("rogue")) { // rogue
      textAlign(CENTER);
      textSize(36);
      fill(255);
      strokeWeight(3);
      text("ROGUE", width/2, height/2-125);
      image(rogue, 260, 195, 141, 257);
      textSize(18);
      text("Press 'I' to dismiss", width/2, height/2+150); // dismiss
      textAlign(CORNER);
      text(" - A mysterious man who'll kill for coin. " +
        " \n- Can dispatch foes near and far alike." +
        " \n- Ability one: Point Blank Shot: Does massive damage but only up close." +
        " \n- Ability two: Open vein: Slice the enemy and heal yourself.", width/2-75, height/2-95, 330, 230);
    }
    strokeWeight(1);
  }

  public void showTileInfo(Tile t) { // shows info for a tile
    if (t == null) { // if no tile abort
      return;
    }
    Character tchar = t.getChar();
    //top left corner of popup is 240, 165);
    fill(0, 50);
    rect(0, 0, 960, 660);
    stroke(255);
    strokeWeight(5);
    rectMode(CENTER);
    fill(0);
    rect(width/2, height/2, 480, 330, 15);
    rectMode(CORNER);
    if (t.getX() == exitX && t.getY() == exitY) { // exit
      textAlign(CENTER);
      textSize(36);
      fill(255);
      strokeWeight(3);
      text("EXIT", width/2, height/2-125); // tile name
      fill(255, 0, 255);
      rect(260, 185, 80, 80, 15); // tile pic
      fill(255);
      textSize(18);
      textAlign(CORNER);
      text("(" + t.x + ", " + t.y + ")", 260, 285); // position
      if (enemiesKilled >= 4) {
        text(" - The door to the next Room! The seal seems to have broken! Head through the door to enter the next room.", width/2-100, height/2-95, 330, 230);
      } else {
        text(" - The door to the next Room! It seems to have a magical seal on it. Maybe if you kill enough enemies, the seal will break?", width/2-100, height/2-95, 330, 230); //Description
      }
      textAlign(CENTER);
      text("Press 'I' to dismiss", width/2, height/2+150); // dismiss
    } else if (t.isWall()) { // wall
      textAlign(CENTER);
      textSize(36);
      fill(255);
      strokeWeight(3);
      text("WALL", width/2, height/2-125); // tile name
      fill(0);
      rect(260, 185, 80, 80, 15); // tile pic
      fill(255);
      textSize(18);
      textAlign(CORNER);
      text("(" + t.x + ", " + t.y + ")", 260, 285); // position
      text(" - It's a wall. ", width/2-100, height/2-95); //Description
      textAlign(CENTER);
      text("Press 'I' to dismiss", width/2, height/2+150); // dismiss
    } else if (tchar == null) { // no character
      if ( t.isTreasure()) { // is treasure
        image(treasureTile, 250, 195, 141, 257); // tile pic
        textAlign(CENTER);
        textSize(36);
        fill(255);
        strokeWeight(3);
        text("TREASURE TILE", width/2, height/2-125); // tile name
        fill(0, 255, 0);

        fill(255);
        textSize(18);
        textAlign(CORNER);
        text(" - A strange fountain with mystical properties " +
          " \n - Go near the fountain to recieve a buff or a heal", width/2-100, height/2-95, 330, 230); //Description
        textAlign(CENTER);
        text("Press 'I' to dismiss", width/2, height/2+150); // dismiss
      } else { // the floor
        textAlign(CENTER);
        textSize(36);
        fill(255);
        strokeWeight(3);
        text("FLOOR", width/2, height/2-125); // tile name
        fill(200);
        rect(260, 185, 80, 80, 15); // tile pic
        fill(255);
        textSize(18);
        textAlign(CORNER);
        text("(" + t.x + ", " + t.y + ")", 260, 285); // position
        text(" - It's the floor. ", width/2-100, height/2-95); //Description
        textAlign(CENTER);
        text("Press 'I' to dismiss", width/2, height/2+150); // dismiss
      }
    } else if (tchar.getType().equals("enemy")) { // an enemy
      if (tchar.getClassif().equals("skeleton")) { // skelly
        textAlign(CENTER);
        textSize(36);
        fill(255);
        strokeWeight(3);
        text("SKELETON", width/2, height/2-125); // tile name
        fill(255, 0, 0); // pic color
        if (tchar.getHealth() <= 0) {
          image(skeletonCorpse, 250, 195, 141, 257);
        } else {
          image(skeleton, 250, 195, 141, 257); // tile pic
        }
        fill(255);
        textSize(18);
        textAlign(CORNER);
        text(" - A skeleton! Your basic trash mob." +
          " \n - Can attack you, or use a devastating special attack." +
          " \n - He needs a moment to catch his breath after, however.", width/2-100, height/2-95, 330, 230); //Description
        textAlign(CENTER);
        text("Press 'I' to dismiss", width/2, height/2+150); // dismiss
      } else if (tchar.getClassif().equals("warlock")) { // warlock
        textAlign(CENTER);
        textSize(36);
        fill(255);
        strokeWeight(3);
        text("WARLOCK", width/2, height/2-125); // tile name
        fill(150, 0, 255); // pic color
        if (tchar.getHealth() <= 0) {
          image(warlockCorpse, 250, 195, 141, 257);
        } else {
          image(warlock, 250, 195, 141, 257); // tile pic
        }
        fill(255);
        textSize(18);
        textAlign(CORNER);
        text(" - A powerful warlock with the power to raise the dead!" +
          " \n - Every 5 turns, he will attempt to resurrect an ally." +
          " \n - Using the dark arts is draining, so he will be temporarily stunned after.", width/2-100, height/2-95, 330, 230); //Description
        textAlign(CENTER);
        text("Press 'I' to dismiss", width/2, height/2+150); // dismiss
      } else if (tchar.getClassif().equals("arbalist")) { // crossbow guy
        textAlign(CENTER);
        textSize(36);
        fill(255);
        strokeWeight(3);
        text("ARBALIST", width/2, height/2-125); // tile name
        fill(150, 0, 255); // pic color
        if (tchar.getHealth() <= 0) {
          image(arbalistCorpse, 250, 195, 141, 257);
        } else {
          image(arbalist, 250, 195, 141, 257); // tile pic
        }
        fill(255);
        textSize(18);
        textAlign(CORNER);
        text(" - An undead soldier with a heavy crossbow." +
          " \n - Every 4 turns, he will launch a disorienting flare that decreases your damage.", width/2-100, height/2-95, 330, 230); //Description
        textAlign(CENTER);
        text("Press 'I' to dismiss", width/2, height/2+150); // dismiss
      }
    } else if (tchar.getType().equals("hero")) { // if hero
      showHeroInfo(tchar.getClassif()); // use hero info method
    }
  }
}

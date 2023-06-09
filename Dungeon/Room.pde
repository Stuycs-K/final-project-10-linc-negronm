class Room {
  private Tile[][] map;
  private int exitX, exitY;
  private int enemiesKilled, enemyCount;
  private String[] enemyClasses = new String[]{"skeleton", "warlock"};
  public int ySize, xSize;
  public int heroX, heroY;
  public boolean targeting;
  public int targX, targY;
  public int warlockCt;
  public Enemy[] enemies;
  public float[] enemyDist;
  public Hero hero;
  public boolean gameStarted;



  public Room(int xsize, int ysize, String HERO) {
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
    if (HERO.equals("mage")){
      hero = new Mage(150, heroX, heroY);
    } else {
      hero = new Hero(150, heroX, heroY);
    }
    warlockCt = 0;
    gameStarted = false;
  }

  public void rotateMap() {
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

  private boolean isIn(int[] arr, int num) {
    for (int i = 0; i < arr.length; i++) {
      if (arr[i] == num) {
        return true;
      }
    }
    return false;
  }

  private Tile[] makeWall(int size, int y) {
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

  private Enemy chooseEnemy(int i, int X, int Y) {
    Enemy e;
    if (i == 0) {
      e = new Skeleton(X, Y);
    } else if (i == 1) {
      e = new Warlock(X, Y);
    } else {
      e = new Enemy(10, X, Y);
    }
    return e;
  }

  public void swap(int x, int y, int desX, int desY) {
    println("tile at (" + x + "," + y + ") now at (" + desX + "," + desY + ")");
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
    println("MOVED TILE NOW AT: " + moved.getX() + "," + moved.getY() + ")");
  }

  public void dePath() {
    for (int y = 0; y < map.length; y++) {
      for (int x = 0; x < map[y].length; x++) {
        if (map[y][x].isPath) {
          map[y][x].isPath = false;
        }
      }
    }
  }

  public void swapTarget(int x, int y) {
    map[targY][targX].untarget();
    map[y][x].target();
    targY = y;
    targX = x;
  }

  public void targetMode() {
    targeting = !targeting;
    swapTarget(heroX, heroY);
  }

  public void attack(int ability) {
    for (int i = 0; i < enemies.length; i++) {
      if (map[enemies[i].getY()][enemies[i].getX()].isTargeted && enemies[i].getHealth() > 0) {
        if (ability == Dungeon.BASICATTACK) {
          hero.basicAttack(enemies[i]);
        } else if (ability == Dungeon.ABILITY1) {
          if(hero.isMage()){
          hero.ability1(this);
          }else{
          hero.ability1(enemies[i]);
          }
        } 
        else if (ability == Dungeon.ABILITY2) {
          hero.ability2(enemies[i]);
        }else {
          println("invalid ability");
        }
        if (enemies[i].getHealth() <= 0) {
          enemiesKilled++;
        }
      }
      map[enemies[i].getY()][enemies[i].getX()].untarget();
    }
  }

  public void generateRoom() {
    enemyCount = 0;
    enemiesKilled = 0;
    float r;
    int maxY = map.length;
    int maxX = map[0].length;
    map = new Tile[xSize][ySize];
    int space = xSize/4-1;
    int[] walls = new int[]{space*1-1, space*2-1, space*3-1, space*4-1};
    heroX = 1;
    heroY = ySize/2;

    for (int y = 0; y < ySize; y++) {
      if (isIn(walls, y)) {
        map[y] = makeWall(xSize, y);
      } else {
        for (int x = 0; x < xSize; x++) {
          if (y == 0 || y == ySize-1 || x == 0 || x == xSize-1) {
            map[y][x] = new Wall(x, y);
          } else {
            map[y][x] = new Tile(x, y);
          }
        }
      }
    }

    rotateMap();
    if (map[ySize/2][1].isWall()) {
      map[ySize/2][1] = new Tile(1, ySize/2);
    }
    map[ySize/2][1].setChar(hero);
    // PLACING ENEMIES
    enemies = new Enemy[6];
    enemyDist = new float[6];
    Enemy e;
    int randx, randy, randClass;
    int i = 0;
    while (enemyCount < 6) {
      randx = int(random(xSize/2, xSize));
      randy = int(random(1, ySize-1));
      if (map[randy][randx].isWall() == false && map[randy][randx].getChar() == null) {
        randClass = int(random(0, enemyClasses.length));
        while (randClass == 1 && warlockCt >= 2) {
          randClass = int(random(0, enemyClasses.length));
        }
        if (randClass == 1) {
          warlockCt++;
        }
        e = chooseEnemy(randClass, randx, randy);
        map[randy][randx].setChar(e);
        enemyCount++;
        enemies[i] = e;
        i++;
      }
    }
  }

  public void showRoom() {
    if (!(gameStarted)) {
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
      fill(255);
      textAlign(CENTER);
      text("Z", 60, 560);
      text("Mage", 60, 620);
      textSize(24);
      text("WASD to move/target", width/2, 160);
      text("1, 2, 3 to select/deselect abilities", width/2, 190);
      text("SPACE to confirm a hit", width/2, 220);
      text("ENTER to end a turn", width/2, 250);
    } else if (hero.getHealth() <= 0) {
      background(0);
      fill(255, 0, 0);
      textAlign(CENTER);
      textSize(48);
      text("GAME OVER!", width/2, height/4);
      fill(255);
      textSize(24);
      text("You made it " + roomNum + " rooms.", width/2, height/4 + 50);
      text("Press 'R' to restart.", width/2, height/4 + 80);
    } else {
      textAlign(LEFT);
      int x = 0;
      int y = 0;
      stroke(255);
      strokeWeight(1);
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
              fill(0, 0, 255);
              rect(x*20, y*20, 20, 20);
            } else if (map[y][x].getChar().getType().equals("enemy")) {
              Character e = map[y][x].getChar();
              if (e.getHealth() <= 0) {
                fill(145, 105, 105);
              } else if (e.getClassif().equals("skeleton")) {
                fill(255, 0, 0);
              } else if (e.getClassif().equals("warlock")) {
                fill(150, 0, 255);
              } else {
                fill (255, 0, 0);
              }
              rect(x*20, y*20, 20, 20);
            }
            fill(0);
            textSize(14);
            if (map[y][x].getChar().health > 0) {
              textAlign(CENTER);
              text(map[y][x].getChar().health, x*20+10, y*20);
            }
          } else {
            fill(200);
            rect(x*20, y*20, 20, 20);
          }

          fill(255);
          textSize(8);
          textAlign(CENTER);
          text(""+map[y][x].getX()+","+map[y][x].getY(), x*20+10, y*20+10);
          if (targeting && map[y][x].isTargeted) {
            noFill();
            stroke(255, 255, 0);
            rectMode(CENTER);
            rect(x*20+10, y*20+10, 10, 10);
            rectMode(CORNER);
            stroke(255);
          }
          y++;
        }
        x++;
        y = 0;
      }
      textSize(24);
      fill(0);
    }
  }


  private void printEnemies() {
    String result = "[";
    for (int i = 0; i < enemies.length-1; i++) {
      result += enemies[i].toString() + ", ";
    }
    result += enemies[enemies.length-1].toString() + "]";
    println(result);
  }

  public Tile tileFromCoords(int x, int y) {
    if (x > 660) {
      return null;
    }
    int tileCol = x/20;
    int tileRow = y/20;
    return map[tileRow][tileCol];
  }

  public boolean isWallBetween(int X, int Y, int desX, int desY) { //checks if a wall Tile exists between two tiles
    boolean result = false;
    if (desX > X) {
      if (desY > Y) {
        for (int i =X; i <=desX; i++) {
          if (map[i][Y].isWall()) {
            result = true;
          }
          if (map[i][desY].isWall()) {
            result = true;
          }
        }
        for (int i =Y; i <=desY; i++) {
          if (map[X][i].isWall()) {
            result = true;
          }
          if (map[desX][i].isWall()) {
            result = true;
          }
        }
      } else if ( desY == Y) {
        for (int i =X; i <=desX; i++) {
          if (map[i][Y].isWall()) {
            result = true;
          }
        }
      } else {
        for (int i =X; i <=desX; i++) {
          if (map[i][Y].isWall()) {
            result = true;
          }
          if (map[i][desY].isWall()) {
            result = true;
          }
        }
        for (int i =desY; i <=Y; i++) {
          if (map[X][i].isWall()) {
            result = true;
          }
          if (map[desX][i].isWall()) {
            result = true;
          }
        }
      }
    } else if ( desX == X) {
      if (desY > Y) {
        for (int i =Y; i <=desY; i++) {
          if (map[X][i].isWall()) {
            result = true;
          }
        }
      } else if ( desY == Y) {
        result =map[X][Y].isWall();
      } else {
        for (int i =desY; i <=Y; i++) {
          if (map[X][i].isWall()) {
            result = true;
          }
        }
      }
    } else {
      if (desY > Y) {
        for (int i =desX; i <=X; i++) {
          if (map[i][Y].isWall()) {
            result = true;
          }
          if (map[i][desY].isWall()) {
            result = true;
          }
        }
        for (int i =Y; i <=desY; i++) {
          if (map[X][i].isWall()) {
            result = true;
          }
          if (map[desX][i].isWall()) {
            result = true;
          }
        }
      } else if ( desY == Y) {
        for (int i =desX; i <=X; i++) {
          if (map[i][Y].isWall()) {
            result = true;
          }
        }
      } else {
        for (int i =desX; i <=X; i++) {
          if (map[i][Y].isWall()) {
            result = true;
          }
          if (map[i][desY].isWall()) {
            result = true;
          }
        }
        for (int i =desY; i <=Y; i++) {
          if (map[X][i].isWall()) {
            result = true;
          }
          if (map[desX][i].isWall()) {
            result = true;
          }
        }
      }
    }
    return result;
  }

  public void showTileInfo(Tile t) {
    Character tchar = t.getChar();
    if (t == null) {
      return;
    }
    //top left corner of popup is 240, 165);
    fill(0, 50);
    rect(0, 0, 960, 660);
    stroke(255);
    strokeWeight(5);
    rectMode(CENTER);
    fill(0);
    rect(width/2, height/2, 480, 330, 15);
    rectMode(CORNER);
    if (t.isWall()) {
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
      text(" - It's a wall. ", width/2-30, height/2-95); //Description
      textAlign(CENTER);
      text("Press 'I' to dismiss", width/2, height/2+150); // dismiss
    } else if (tchar == null) {
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
      text(" - It's the floor. ", width/2-30, height/2-95); //Description
      textAlign(CENTER);
      text("Press 'I' to dismiss", width/2, height/2+150); // dismiss
    } else if (tchar.getType().equals("enemy")) { // an enemy
      if (tchar.getClassif().equals("skeleton")) {
        textAlign(CENTER);
        textSize(36);
        fill(255);
        strokeWeight(3);
        text("SKELETON", width/2, height/2-125); // tile name
        fill(255, 0, 0); // pic color
        rect(260, 185, 80, 80, 15); // tile pic
        fill(255);
        textSize(18);
        textAlign(CORNER);
        text("(" + t.x + ", " + t.y + ")", 260, 285); // position
        text(" - A skeleton! Your basic trash mob.", width/2-30, height/2-95); //Description
        textAlign(CENTER);
        text("Press 'I' to dismiss", width/2, height/2+150); // dismiss
      } else if (tchar.getClassif().equals("warlock")) {
      }
    }
  }
}

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
  
  

  public Room(int xsize, int ysize) {
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
    hero = new Hero(500, heroX, heroY);
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
          hero.ability1(enemies[i]);
        } else {
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
        while (randClass == 1 && warlockCt >= 2){
          randClass = int(random(0, enemyClasses.length));
        }
        if (randClass == 1){
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
      text("GAME OVER! \n PRESS R TO RESTART.", width/2, height/2);
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
              text(map[y][x].getChar().health, x*20+3, y*20);
            }
          } else {
            fill(200);
            rect(x*20, y*20, 20, 20);
          }

          fill(255);
          textSize(8);
          text(""+map[y][x].getX()+","+map[y][x].getY(), x*20+5, y*20+20/2);
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
}

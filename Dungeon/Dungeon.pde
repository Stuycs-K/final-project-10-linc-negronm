Room room = new Room(33, 33);
Controller keyboardInput;
int countdown;
boolean heroTurn =false;
boolean enemyTurn =false;
int heroMoved = 0;

public void heroTurn(){
  heroMoved =0;
  heroTurn = true;
}
public void heroTurnEnd(){
  heroTurn = false;
  enemyTurn();
} 
public void enemyTurn(){
  enemyTurn = true;
}
public void enemyTurnEnd(){
  enemyTurn = false;
  heroTurn();
}
void setup(){
  background(255);
  size(960,660);
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
  if (key == 'r'){
    room.generateRoom();
    heroMoved =0;
  }
  if (key == 't'){
  room.targeting = !room.targeting;
}
}

void keyReleased() {
  keyboardInput.release(keyCode);
}
void draw(){
  background(255);
  room.showRoom();
  if(heroTurn){
    if(countdown == 0 && heroMoved <= 7){
    countdown+=30;
  if (keyboardInput.isPressed(Controller.C_LEFT)){
    if(!(room.map[room.heroY][room.heroX-1].isWall())){
      room.swap(room.heroX, room.heroY, room.heroX-1, room.heroY);
      room.heroX -= 1;
      heroMoved +=1;
    }
  }
  if (keyboardInput.isPressed(Controller.C_UP)) {
    if(!(room.map[room.heroY-1][room.heroX].isWall())){
      room.swap(room.heroX, room.heroY, room.heroX, room.heroY-1);
      room.heroY -= 1;
      heroMoved +=1;
    }
  }
  if (keyboardInput.isPressed(Controller.C_DOWN)) {
    if(!(room.map[room.heroY+1][room.heroX].isWall())){
      room.swap(room.heroX, room.heroY, room.heroX, room.heroY+1);
      room.heroY += 1;
      heroMoved +=1;
    }
  }
  if (keyboardInput.isPressed(Controller.C_RIGHT)) {
    if(!(room.map[room.heroY][room.heroX+1].isWall())){
      room.swap(room.heroX, room.heroY, room.heroX+1, room.heroY);
      room.heroX += 1;
      heroMoved +=1;
    }
  }
}
if(countdown > 0){
    countdown --;
  }
if(!keyPressed){
  countdown = 0;
}
if(key == ENTER || key == RETURN){
    heroTurnEnd();
    enemyTurn();
  }

  }
 if(enemyTurn){
 
   enemyTurnEnd();
 }

}

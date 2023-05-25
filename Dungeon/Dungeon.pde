Room room = new Room(33, 33);
Controller keyboardInput;
int countdown;
void setup(){
  background(255);
  size(960,660);
  room.generateRoom();
  room.showRoom();
  textSize(24);
  fill(0);
  text("Press WASD to move", 670, 30);
  keyboardInput = new Controller();
}

void keyPressed() {
  keyboardInput.press(keyCode);
}

void keyReleased() {
  keyboardInput.release(keyCode);
}
void draw(){
  room.showRoom();
  if(countdown == 0){
    countdown+=45;
  if (keyboardInput.isPressed(Controller.C_LEFT)){
    room.swap(room.heroX, room.heroY, room.heroX-1, room.heroY);
    room.heroX -= 1;
  }
  if (keyboardInput.isPressed(Controller.C_UP)) {
    room.swap(room.heroX, room.heroY, room.heroX, room.heroY-1);
    room.heroY -= 1;
  }
  if (keyboardInput.isPressed(Controller.C_DOWN)) {
    room.swap(room.heroX, room.heroY, room.heroX, room.heroY+1);
    room.heroY += 1;
  }
  if (keyboardInput.isPressed(Controller.C_RIGHT)) {
    room.swap(room.heroX, room.heroY, room.heroX+1, room.heroY);
    room.heroX += 1;
  }
}
if(countdown > 0){
    countdown --;
  }

/*void keyPressed(){
  if (key == 'r'){
    room.generateRoom();
  }
  if (key == 'w'){
    room.swap(room.heroX, room.heroY, room.heroX, room.heroY-1);
    room.heroY -= 1;
  }*/
}

Room room = new Room(33, 33);
void setup(){
  background(255);
  size(960,660);
  room.generateRoom();
  room.showRoom();
  textSize(24);
  fill(0);
  text("Press WASD to move", 670, 30);
}


void draw(){
  room.showRoom();
}

void keyPressed(){
  if (key == 'r'){
    room.generateRoom();
  }
  if (key == 'w'){
    room.swap(room.heroX, room.heroY, room.heroX, room.heroY-1);
    room.heroY -= 1;
  }
}

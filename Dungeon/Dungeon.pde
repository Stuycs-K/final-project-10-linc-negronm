Room room = new Room(33, 33);
void setup(){
  size(660,660);
  room.generateRoom();
  room.showRoom();
}


void draw(){
  room.showRoom();
}

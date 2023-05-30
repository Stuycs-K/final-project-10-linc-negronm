class Controller {
  static final int C_LEFT = 0;
  static final int C_RIGHT = 1;
  static final int C_UP = 2;
  static final int C_DOWN = 3;
  static final int C_BasicAttack =4;
  static final int C_Ability1 =5;
  static final int C_Ability2 =6;
  static final int C_Target =7;
  static final int C_Confirm=8;
  boolean [] inputs;

  public Controller() {
    inputs = new boolean[9];//2 valid buttons
  }

  
  boolean isPressed(int code) {
    return inputs[code];
  }
  void press(int code) {
    if(code == 'A')
      inputs[C_LEFT] = true;
    if(code == 'D')
      inputs[C_RIGHT] = true;
    if(code == 'W')
      inputs[C_UP] = true;
    if(code == 'S')
      inputs[C_DOWN] = true;
    if(code == '1')
      inputs[C_BasicAttack] = true;
    if(code == '2')
      inputs[C_Ability1] = true;
    if(code == '3')
      inputs[C_Ability2] = true;
    if(code == 'T')
      inputs[C_Target] = true;
    if(code == ' ')
      inputs[C_Confirm] = true;
  }
  void release(int code) {
    if(code == 'A')
    inputs[C_LEFT] = false;
    if(code == 'D')
    inputs[C_RIGHT] = false;
    if(code == 'W')
      inputs[C_UP] = false;
    if(code == 'S')
      inputs[C_DOWN] = false;
    if(code == '1')
      inputs[C_BasicAttack] = false;
    if(code == '2')
      inputs[C_Ability1] = false;
    if(code == '3')
      inputs[C_Ability2] = false;
    if(code == 'T')
      inputs[C_Target] = false;
    if(code == ' ')
      inputs[C_Confirm] = false;
  }
  
  
}

import processing.serial.*;

Serial port;
int pressed = 0;

void anim() {
  allON();
  delay(30000);
  for(int i = 0; i < 20; i++){
    row();
  }
  for(int i = 0; i < 40; i++){
    column();
  }
  for(int i = 0; i < 30000; i++){
    rand();
  }
}

void allON() {
  int output = 255;
  byte [] matrix = new byte[40+1];
  matrix[0] = (byte) 0x55;
  for (int j=0; j < 40; j++) {
    matrix[j+1] = (byte) output;
  }
  port.write(matrix);
  println(matrix);
}

void binRow() {
  int output = 0;
  byte [] matrix = new byte[40+1];
  matrix[0] = (byte) 0x55;
  for (int j = 1; j < 41; j++) {
    matrix[j] = (byte) (j);
  }
  port.write(matrix);
  println(matrix);
}

void rand() {
  byte [] matrix = new byte[40+1];
  matrix[0] = (byte) 0x55;
  for (int j = 1; j < 41; j++) {
    matrix[j] = (byte) (random(0,255));
  }
  port.write(matrix);
  println(matrix);
  delay(150);
}

void column() {
  byte [] matrix = new byte[40+1];
  matrix[0] = (byte) 0x55;
  for(int col = 0; col < 8; col++) {
    for (int j = 1; j < 41; j++) {
      matrix[j] = (byte) (pow(2,col));
    }
      port.write(matrix);
      println(matrix);
      delay(80);
  }
}

void row() {
  byte [] matrix = new byte[40+1];
  matrix[0] = (byte) 0x55;
  for (int j = 2; j < 41; j++) {
    matrix[j-1] = (byte) (0);
    matrix[j] = (byte) (255);
    port.write(matrix);
    println(matrix);
    delay(75);
  }
}

void cleanScreen() {
  int output = 0;
  byte [] matrix = new byte[40+1];
  matrix[0] = (byte) 0x55;
  for (int j=0; j < 40; j++) {
    matrix[j+1] = (byte) output;
  }
  port.write(matrix);
  println(matrix);
}

void mousePressed() {
  pressed++;
  anim();
}

void setup() {
  port = new Serial(this,"COM3",9600);
}

void draw() {
  anim();
}

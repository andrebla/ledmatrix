// 40 x 8 LED Matrix Wall by Andre Aureliano - http://www.fiozera.com.br/
// Arduino Code

//Columns Shift Register
int latchPinC = 11;
int clockPinC = 10;
int dataPinC = 12;

//Rows Shift Register
int latchPinR = 5;
int clockPinR = 4;
int dataPinR = 3;

int bufferPin = 2;

byte matrix[40];
byte matconv[40][8];
long matout[5][8];
byte head;
int state = 0;

void matconvert() {
  for(int row = 0; row < 40; row++) {
    for(int col = 0; col <8; col++) {
      matconv[row][col] = bitRead( matrix[row], col) ;
    }
  }
  for(int col = 0; col < 8; col++) {
    for(int row = 0; row < 40; row++) {
      for(int r = 0; r < 5; r++) {
        matout[r][col] = bitWrite( matout[r][col], row - (8 * r), matconv[row][col]);
      }
    }
  }
  panelOut();
}

void panelOut() {
  for (int col = 0; col < 8; col++) {
    int colbit = 1 << col;
    digitalWrite(latchPinC, LOW);
    shiftOut(dataPinC, clockPinC, MSBFIRST, colbit);
    digitalWrite(latchPinR, LOW);
    shiftOut(dataPinR, clockPinR, MSBFIRST, matout[4][col]);
    shiftOut(dataPinR, clockPinR, MSBFIRST, matout[3][col]);
    shiftOut(dataPinR, clockPinR, MSBFIRST, matout[2][col]);
    shiftOut(dataPinR, clockPinR, MSBFIRST, matout[1][col]);
    shiftOut(dataPinR, clockPinR, MSBFIRST, matout[0][col]);
    digitalWrite(bufferPin, HIGH);
    digitalWrite(latchPinC, HIGH);
    digitalWrite(latchPinR, HIGH);
    digitalWrite(bufferPin, LOW);
  }
}

void setup() {
  for(int row = 0; row < 2; row++) {
    for(int col = 0; col < 8; col++) {
      matout[row][col] = 0;
    }
  }
  pinMode(bufferPin, OUTPUT);
  pinMode(clockPinC, OUTPUT);
  pinMode(latchPinC, OUTPUT);
  pinMode(dataPinC,  OUTPUT);
  pinMode(clockPinR, OUTPUT);
  pinMode(latchPinR, OUTPUT);
  pinMode(dataPinR,  OUTPUT);
  digitalWrite(clockPinC, LOW);
  digitalWrite(latchPinC, LOW);
  digitalWrite(dataPinC,  LOW);
  digitalWrite(clockPinR, LOW);
  digitalWrite(latchPinR, LOW);
  digitalWrite(dataPinR,  LOW);
  Serial.begin(9600);
  head = (byte) 0x55;
}

void loop() {
  if (Serial.available()>0) {
    int input = Serial.read();
    switch (state) {
    case 0:
      if (input==head) {
        state = 1;
      }
      break;
    case 1:
    case 2:
    case 3:
    case 4:
    case 5:
    case 6:
    case 7:
    case 8:
    case 9:
    case 10:
    case 11:
    case 12:
    case 13:
    case 14:
    case 15:
    case 16:
    case 17:
    case 18:
    case 19:
    case 20:
    case 21:
    case 22:
    case 23:
    case 24:
    case 25:
    case 26:
    case 27:
    case 28:
    case 29:
    case 30:
    case 31:
    case 32:
    case 33:
    case 34:
    case 35:
    case 36:
    case 37:
    case 38:
    case 39:
      if((byte) input < 0) {
        matrix[state-1] = (byte) input + 256;
        state++;
        break;
      }
      else {
        matrix[state-1] = (byte) input;
        state++;
        break;
      }
    case 40:
      if((byte) input < 0) {
        matrix[state-1] = (byte) input + 256;
        state = 0;
        matconvert();
        break;
      }
      else {
        matrix[state-1] = (byte) input;
        state = 0;
        matconvert();
        break;
      }
    }
  }
  else {
    panelOut();
  }
}

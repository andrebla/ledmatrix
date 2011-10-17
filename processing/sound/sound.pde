import processing.serial.*;
import ddf.minim.*;
import ddf.minim.analysis.*;

Serial port;
Minim minim;
AudioPlayer song;
BeatDetect beat;
BeatListener bl;

byte [] matrix = new byte[40+1];

float kickSize, snareSize, hatSize;


class BeatListener implements AudioListener {
  private BeatDetect beat;
  private AudioPlayer source;
  BeatListener(BeatDetect beat, AudioPlayer source) {
    this.source = source;
    this.source.addListener(this);
    this.beat = beat;
  }
  void samples(float[] samps) {
    beat.detect(source.mix);
  }
  void samples(float[] sampsL, float[] sampsR) {
    beat.detect(source.mix);
  }
}

void setup() {
  size(512, 200, P3D);
  port = new Serial(this,"COM7",9600);
  minim = new Minim(this);
  song = minim.loadFile("songname.mp3", 2048); //Insert correct song name
  song.play();
  beat = new BeatDetect(song.bufferSize(), song.sampleRate());
  beat.setSensitivity(300);
  kickSize = snareSize = hatSize = 16;
  bl = new BeatListener(beat, song);  
  textFont(createFont("Helvetica", 16));
  textAlign(CENTER);
}

void draw() {
  background(0);
  fill(255);
  if(beat.isKick()) {
    matrix[0] = (byte) 0x55;
    matrix[1] = 31;
    matrix[2] = 17;
    matrix[3] = 17;
    matrix[4] = 17;
    matrix[5] = 31;
    matrix[6] = 17;
    matrix[7] = 0;
    matrix[8] = 0;
    matrix[9] = 0;
    matrix[10] = 17;
    matrix[11] = 17;
    matrix[12] = 0;
    matrix[13] = 0;
    matrix[14] = 0;
    matrix[15] = 17;
    matrix[16] = 17;
    matrix[17] = 0;
    matrix[18] = 0;
    matrix[19] = 0;
    matrix[20] = 17;
    matrix[21] = 31;
    matrix[22] = 17;
    matrix[23] = 17;
    matrix[24] = 17;
    matrix[25] = 31;
    port.write(matrix);
    println(matrix);
    kickSize = 32;
  }
  if(beat.isSnare()) {
      snareSize = 32;
  }
  if(beat.isHat()) {
    
      hatSize = 32;
  }
  matrix[0] = (byte) 0x55;
  for (int j=0; j < 40; j++) {
    matrix[j+1] = (byte) 0;
  }
  port.write(matrix);
  println(matrix);
  textSize(kickSize);
  text("KICK", width/4, height/2);
  textSize(snareSize);
  text("SNARE", width/2, height/2);
  textSize(hatSize);
  text("HAT", 3*width/4, height/2);
  kickSize = constrain(kickSize * 0.95, 16, 32);
  snareSize = constrain(snareSize * 0.95, 16, 32);
  hatSize = constrain(hatSize * 0.95, 16, 32);
}

void stop() {
  song.close();
  minim.stop();
  super.stop();
}

import processing.serial.*;

Serial port;

int w = 8;
int h = 40;
int res = 15;
 
PFont visitor;
int[][] board;
int[][] matrix;
int x_loc, y_loc, x_pel, y_pel, speed, curFrame, leng, score, score_inc, direction;
boolean gameover;
byte [] msg = new byte[h+1];
 
void setup(){
  port = new Serial(this,"COM3",9600);
  size(w * res, h * res);
  board = new int[w][h];
  matrix = new int[w][h];
  in();
}
 
void in(){
  background(0);
  x_loc = 0;
  y_loc = 0;
  speed = 8;
  curFrame = 0;
  leng = 3;
  direction = 1;
  gameover = false;
  for(int i = 0; i < w; i++){
    for(int u = 0; u < h; u++){
      board[i][u] = 0;
    }
  }
   
  fill(255);
  noStroke();
  
  x_pel = round(random(w - 2)) + 1;
  y_pel = round(random(h - 2)) + 1;
  
  rect(x_loc, y_loc, res, res);
}
 
void draw(){
  msg[0] = (byte) 0x55;
  if(!gameover){
    if(curFrame == speed){
      background(0);
       
      switch(direction){
        case 0:
          y_loc -= 1;
          break;
        case 1:
          x_loc += 1;
          break;
        case 2:
          y_loc += 1;
          break;
        case 3:
          x_loc -= 1;
          break;
        default:
          println("no direction");
          break;
      }
      
      for(int i = 0; i < w; i++){
        for(int u = 0; u < h; u++){
          if(board[i][u] > 0){
            board[i][u]--;
          }
        }
      }
       
      if(x_loc >= 0 && x_loc < w && y_loc >= 0 && y_loc < h && board[x_loc][y_loc] == 0)
        board[x_loc][y_loc] = leng;
      else
        gameover = true;
         
      if(x_loc == x_pel && y_loc == y_pel){
         leng++;
         score += score_inc;
   
          x_pel = round(random(w - 2)) + 1;
          y_pel = round(random(h - 2)) + 1;
      }
       
      curFrame = 0;
     
      board[x_pel][y_pel] = 1;
      for(int u = 0; u < h; u++){
        int result = 0;
        for(int i = 0; i < w; i++){
          if(board[i][u] != 0){
            rect(i * res, u * res, res, res);
            matrix[i][u] = 1;
            
          }
          else{
            matrix[i][u] = 0;
          }
          result = int(result + (pow(2,i) * matrix[i][u]));
          int(result);
          msg[u+1] = (byte) result;
        }
      }
      port.write(msg);
      println(msg);
       
      rect(x_pel * res, y_pel * res, res, res);
     
      textAlign(RIGHT);
      fill(255);
    }
     
    curFrame++;
  }else{
    background(0);
    textAlign(CENTER);
    fill(255);
    text("- GAME OVER -", w * res / 2, h * res / 2);
    textAlign(RIGHT);
  }
}
 
void keyPressed(){
  switch(keyCode){
    case UP:
      if(direction != 2)
        direction = 0;
      break;
    case DOWN:
      if(direction != 0)
        direction = 2;
      break;
    case LEFT:
      if(direction != 1)
        direction = 3;
      break;
    case RIGHT:
      if(direction != 3)
        direction = 1;
      break;
  }
}
 
void mousePressed(){
  println("pressed");
  if(gameover){
    in();
  }
}

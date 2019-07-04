//Maze game that uses a maze making algorithom
//By JoshDKane

int cols, rows;
int dx, dy;
int fx, fy;

float biginclockdr = 0;
float clockd = 0;

boolean done = false;
boolean win = false;
boolean startclockd = false;
boolean gotclockd = false;

boolean isTyping = false;
boolean playing = false;

boolean showStat = false;
boolean showClicker = false;

//How large will each cell be:

int w = 40;
IntList numbers = new IntList();

ArrayList<Cell> stack = new ArrayList<Cell>();
ArrayList<Cell> grid = new ArrayList<Cell>();

//For color picking
color playerColor = color(0, 251, 0);
color gridColor = color(255, 100, 255);

PImage colorPicker;

boolean showPicker = false;
boolean gridPicker = false;

Cell current;

void setup() {

  //Screen size:

  //size(800, 800);
  //size(720, 480);
  size(1080, 720);
  //fullScreen();

  frameRate(120);

  colorPicker = loadImage("color-picker.png");

  dx = int(random(cols/2, cols)) * w;
  dy = int(random(rows/2, rows)) * w;

  background(51);
}

void draw() {

  if (playing) {

    game();
  } else {

    menu();
  }
}

void mouseReleased() {

  if (!playing) {

    if (mouseX > width / 1.65 && mouseX < width / 1.65 + 50) {
      if (mouseY > height - 98 && mouseY < height - 48) {

        showClicker = !showClicker;
      }
    }
  }
}

void keyPressed() { //up right down left

  if (done) {

    if (!win) {

      if (keyCode == UP || key == 'w') {

        if (current.walls[0] != true) {

          current = grid.get(index(current.i, current.j - 1));
        }
      }

      if (keyCode == RIGHT || key == 'd') {

        if (current.walls[1] != true) {

          current = grid.get(index(current.i + 1, current.j));
        }
      }

      if (keyCode == DOWN || key == 's') {

        if (current.walls[2] != true) {

          current = grid.get(index(current.i, current.j + 1));
        }
      }

      if (keyCode == LEFT || key == 'a') {

        if (current.walls[3] != true) {

          current = grid.get(index(current.i - 1, current.j));
        }
      }
    }
  }

  if (win) {

    if (key == 'a') {

      reset();
    }
  }
}

void keyReleased() {

  if (isTyping) {

    if (key == '1') { 
      w = (w * 10) + 1;
      numbers.append(1);
    }
    if (key == '2') { 
      w = (w * 10) + 2;
      numbers.append(2);
    }
    if (key == '3') { 
      w = (w * 10) + 3;
      numbers.append(3);
    }
    if (key == '4') { 
      w = (w * 10) + 4;
      numbers.append(4);
    }
    if (key == '5') { 
      w = (w * 10) + 5;
      numbers.append(5);
    }
    if (key == '6') { 
      w = (w * 10) + 6;
      numbers.append(6);
    }
    if (key == '7') { 
      w = (w * 10) + 7;
      numbers.append(7);
    }
    if (key == '8') { 
      w = (w * 10) + 8;
      numbers.append(8);
    }
    if (key == '9') { 
      w = (w * 10) + 9;
      numbers.append(9);
    }
    if (key == '0') { 
      w = (w * 10);
      numbers.append(0);
    }
    if (key == BACKSPACE) { 
      if (numbers.size() > 0) {

        int last = numbers.get(numbers.size() - 1); 
        w = (w - last) / 10;
        numbers.remove(numbers.size() - 1);
      }
    }
    if (key == ENTER) {
      isTyping = false;
      playing = true;
      reset();
    }
  }
}

void mouseDragged() {

  if (showPicker) {

    if (mouseX > width / 2 - 50 && mouseX < width / 2 + 178) {
      if (mouseY > 150 && mouseY < 378) {

        if (mousePressed) {

          color newColor = get(mouseX, mouseY);
          playerColor = newColor;
        }
      }
    }
  } else if (gridPicker) {

    if (mouseX > width / 2 - 50 && mouseX < width / 2 + 178) {
      if (mouseY > 150 && mouseY < 378) {

        if (mousePressed) {
          color newColor = get(mouseX, mouseY);
          gridColor = newColor;
        }
      }
    }
  }
}

void reset() {

  cols = floor(width/w);
  rows = floor(height/w);

  background(51);

  for (int i = 0; i < grid.size(); i++) {

    grid.remove(i);
  }

  done = false;
  win = false;
  startclockd = false;
  gotclockd = false;

  if (!showClicker) {

    showStat = false;
  } else {

    showStat = true;
  }

  stack = new ArrayList<Cell>();
  grid = new ArrayList<Cell>();

  for (int j = 0; j < rows; j++) {

    for (int i = 0; i < cols; i++) {

      Cell cell = new Cell(i, j);
      grid.add(cell);
    }
  }

  current = grid.get(0);
}


void game() {

  current.visited = true;
  current.highlight();

  Cell next = current.checkNeighbors();

  if (next != null) {

    next.visited = true;

    stack.add(current);

    removeWalls(current, next);

    current = next;
  } else if (stack.size() > 0) {

    Cell temp = stack.get(stack.size() - 1);
    current = temp;
    stack.remove(stack.size() - 1);
  }

  if (current == grid.get(0) && !done) {

    if (!startclockd) {

      clockd = 0;
      biginclockdr = millis();
      startclockd = true;
    }

    ArrayList<Cell> endPos = new ArrayList<Cell>();

    noStroke();
    fill(255, 0, 0);

    for (Cell g : grid) {

      int counter = 0;

      if (g.walls[0] == true) {

        counter += 1;
      }

      if (g.walls[1] == true) {

        counter += 1;
      }

      if (g.walls[2] == true) {

        counter += 1;
      }

      if (g.walls[3] == true) {

        counter += 1;
      }

      if (counter == 3) {

        endPos.add(g);
      }
    }

    int theEnd = int(random(1, endPos.size()));

    Cell end = endPos.get(theEnd);
    end.end = true;

    fx = end.i;
    fy = end.j;
    fx = fx * w;
    fy = fy * w;

    done = true;
  }

  if (showStat) {

    for (int i = 0; i < grid.size(); i++) {

      Cell g = grid.get(i);
      g.show();
      current.highlight();
    }
  }

  if (done) {

    showStat = true;

    current.highlight();

    int cx = current.i;
    int cy = current.j;
    cx = cx * w;
    cy = cy * w;

    if (cx == fx && cy == fy) {

      win = true;
    }
  }

  if (win) {

    cursor(ARROW);

    if (!gotclockd) {

      clockd = millis() - biginclockdr;
      gotclockd = true;
    }

    textAlign(CENTER);

    fill(255);

    textSize((width / 10) + 30);

    text("You won", (width / 2), height / 5);

    textSize((width / 20) + 20);

    text("Seconds:" + (clockd / 1000), width / 2, height / 2.5);

    text("Hit 'A' to play again", (width / 2), height / 1.5);

    if (mouseX > width / 2 - 75 && mouseX < width / 2 + 100) {
      if (mouseY > height / 1.35 && mouseY < height / 1.35 + 90) {

        fill(0, 0, 255);
        if (mousePressed) {
          isTyping = false;
          playing = false;
          showPicker = false;
        }
      } else {
        fill(255, 0, 0);
      }
    } else {
      fill(255, 0, 0);
    }

    rect(width / 2 - 100, height / 1.35, 200, 90);

    fill(0);
    text("Menu", width / 2, height / 1.2);
  } else {  

    noCursor();
  }
}

void menu() {

  background(51);

  textAlign(LEFT);
  fill(0);

  textSize((width / 20) + 20);  
  text("Select cell size:", 10, 100);

  text("Player Color:", 10, 200);
  text("Grid Color:", 10, 270);
  text("Show Algorithom:", 10, height - 50);

  if (!gridPicker && !showPicker) {

    fill(gridColor);
    stroke(0);
    strokeWeight(2);
    rect(width / 2 - 50, 220, 50, 50);

    if (mouseX > width / 2 - 50 && mouseX < width / 2) {
      if (mouseY > 220 && mouseY < 270) {

        if (mousePressed) {
          isTyping = false;
          gridPicker = true;
        }
      }
    }
  } else  if (gridPicker) {

    image(colorPicker, width / 2 - 50, 150, 228, 228);

    fill(255, 0, 0);
    rect(width / 2 + 200, 150, 20, 20);

    fill(0);
    textSize(20);
    text("X", width / 2 + 205, 168);
    textSize((width / 20) + 20);

    fill(gridColor);
    rect(width / 2 + 200, 180, 20, 20);

    if (mouseX > width / 2 + 200 && mouseX < width / 2 + 220) {
      if (mouseY > 150 && mouseY < 170) {
        if (mousePressed) {
          gridPicker = false;
        }
      }
    }
  }


  if (!showPicker && !gridPicker) {

    fill(playerColor);
    stroke(0);
    strokeWeight(2);
    rect(width / 2 - 50, 150, 50, 50);

    if (mouseX > width / 2 - 50 && mouseX < width / 2) {
      if (mouseY > 150 && mouseY < 200) {

        if (mousePressed) {
          isTyping = false;
          showPicker = true;
        }
      }
    }
  } else  if (showPicker) {

    image(colorPicker, width / 2 - 50, 150, 228, 228);

    fill(255, 0, 0);
    rect(width / 2 + 200, 150, 20, 20);

    fill(0);
    textSize(20);
    text("X", width / 2 + 205, 168);
    textSize((width / 20) + 20);

    fill(playerColor);
    rect(width / 2 + 200, 180, 20, 20);

    if (mouseX > width / 2 + 200 && mouseX < width / 2 + 220) {
      if (mouseY > 150 && mouseY < 170) {
        if (mousePressed) {

          showPicker = false;
        }
      }
    }
  }

  fill(255);
  stroke(0);
  rect(width / 1.65, height - 98, 50, 50);

  if (showClicker) {

    fill(0);
    textSize(50);
    text("X", width / 1.625, height - 55);
    textSize((width / 20) + 20);
  }

  textAlign(CENTER);

  stroke(0);
  strokeWeight(5);
  fill(255);

  rect(width / 2 + 20, 20, 500, 110);

  if (mouseX > width / 2 - 75 && mouseX < width / 2 + 80) {
    if (mouseY > height / 1.75 && mouseY < height / 1.75 + 100) {

      fill(0, 255, 0);

      if (mousePressed) {
        isTyping = false;
        playing = true;
        showPicker = false;

        if (w <= 10) {

          w = 40;
        }
        if (w >= 120) {

          w = 100;
        }

        reset();
      }
    } else {
      fill(255, 0, 0);
    }
  } else {
    fill(255, 0, 0);
  }

  rect(width / 2 - 75, height / 1.75, 155, 100);

  fill(0);
  text("Play", width / 2, height / 1.5);

  strokeWeight(1);

  if (mouseX > width / 2 + 20 && mouseX < width / 2 + 520) {
    if (mouseY > 20 && mouseY < 130) {

      cursor(TEXT);

      if (mousePressed) {
        isTyping = true;
        w = 0;

        numbers = new IntList();
      }
    } else {    

      cursor(ARROW);
    }
  } else {    

    cursor(ARROW);
  }

  fill(0);
  textAlign(LEFT);
  text(str(w), width / 2 + 40, 100);

  if (playing) {
    background(51);
  }
}

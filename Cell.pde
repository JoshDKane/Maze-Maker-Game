class Cell {

  int i;
  int j;

  boolean[] walls = {true, true, true, true}; //top right bottom left

  boolean visited = false;
  boolean end = false;

  Cell(int i, int j) {

    this.i = i;
    this.j = j;
  }

  void highlight() {

    int x = i * w;
    int y = j * w;

    noStroke();
    fill(playerColor);

    rect(x + (w / 4), y + (w / 4), w / 2, w / 2);
  }

  void show() {

    int x = i * w;
    int y = j * w;   

    if (end) {

      noStroke();
      fill(255, 0, 0);

      rect(x, y, w, w);
    } else if (visited) {

      noStroke();
      fill(gridColor);

      rect(x, y, w, w);
    }

    stroke(0);
    strokeWeight(4);

    if (walls[0] == true) {

      line(x, y, x + w, y);
    }

    if (walls[1] == true) {

      line(x + w, y, x + w, y + w);
    }

    if (walls[2] == true) {

      line(x + w, y + w, x, y + w);
    }

    if (walls[3] == true) {

      line(x, y + w, x, y);
    }
  }

  Cell checkNeighbors() {

    ArrayList<Cell> neighbors = new ArrayList<Cell>();

    Cell top = null;
    Cell right = null;
    Cell bottom = null;
    Cell left = null;

    if (index(i, j - 1) != -1) {

      top = grid.get(index(i, j - 1));
    }

    if (index(i + 1, j) != -1) {

      right = grid.get(index(i + 1, j));
    }

    if (index(i, j + 1) != -1) {

      bottom = grid.get(index(i, j + 1));
    }

    if (index(i - 1, j) != -1) {

      left = grid.get(index(i - 1, j));
    }


    if (top != null && !top.visited) {

      neighbors.add(top);
    }

    if (right != null && !right.visited) {

      neighbors.add(right);
    }

    if (bottom != null && !bottom.visited) {

      neighbors.add(bottom);
    }

    if (left != null && !left.visited) {

      neighbors.add(left);
    }


    if (neighbors.size() > 0) {

      int r = floor(random(0, neighbors.size()));

      return neighbors.get(r);
    } else {

      return null;
    }
  }
}


int index(int i, int j) {

  if (i < 0 || j < 0 || i > cols - 1 || j > rows - 1) {

    return -1;
  }

  return i + j * cols;
}

void removeWalls(Cell a, Cell b) {

  int x = a.i - b.i;

  if (x == 1) {

    a.walls[3] = false;
    b.walls[1] = false;
  } else if (x == -1) {

    a.walls[1] = false;
    b.walls[3] = false;
  } else {

    int y = a.j - b.j;

    if (y == 1) {

      a.walls[0] = false;
      b.walls[2] = false;
    } else if (y == -1) {

      a.walls[2] = false;
      b.walls[0] = false;
    }
  }
}
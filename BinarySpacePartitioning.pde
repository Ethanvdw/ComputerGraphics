import java.util.ArrayList;

ArrayList<Node> nodes = new ArrayList<Node>();

void setup() {
  size(800, 600, P3D);
  createBSPTree();
}

void draw() {
  background(200);
  translate(width/2, height/2);
  rotateX(-mouseY * 0.01);
  rotateY(-mouseX * 0.01);
  renderBSPTree();
}

void createBSPTree() {
  // Create the root node with the entire space
  Node root = new Node(new PVector(-200, -200, -200), new PVector(200, 200, 200));
  nodes.add(root);

  // Split the root node into two child nodes
  root.split();

  // Add more splits as needed
  for (Node n : nodes) {
    if (random(1) < 0.1) {
      n.split();
    }
  }
}

void renderBSPTree() {
  for (Node n : nodes) {
    n.render();
  }
}

class Node {
  PVector min, max;
  Node front, back;

  Node(PVector min, PVector max) {
    this.min = min;
    this.max = max;
  }

  void split() {
    PVector split_normal = new PVector(random(-1, 1), random(-1, 1), random(-1, 1));
    float split_dist = random(min.dist(max)) + min.dist(max) * 0.1;

    front = new Node(min.copy(), max.copy());
    back = new Node(min.copy(), max.copy());

    for (int i = 0; i < 3; i++) {
      if (split_normal.array()[i] > 0) {
        front.max.array()[i] = front.min.array()[i] + split_dist;
        back.min.array()[i] = back.max.array()[i] - split_dist;
      } else {
        front.min.array()[i] = front.max.array()[i] - split_dist;
        back.max.array()[i] = back.min.array()[i] + split_dist;
      }
    }

    nodes.add(front);
    nodes.add(back);
  }

  void render() {
    stroke(0);
    noFill();
    box(max.x - min.x, max.y - min.y, max.z - min.z);

    if (front != null) {
      front.render();
      back.render();
    }
  }
}

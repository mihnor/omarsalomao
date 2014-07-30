// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Forces (Gravity and Fluid Resistence) with Vectors 

// Demonstration of multiple force acting on bodies (Mover class)
// Bodies experience gravity continuously
// Bodies experience fluid resistance when in "water"

// Five moving bodies

// posição do vetor de sopro
PVector baseBlow;

//vetor de intencidade e direção do acelerometro
PVector gravity;
PImage fundo; 

//finger
Finger cursor;

ArrayList<Mover> movers;

void setup() {
  size(768, 1024);
  background(255);
  cursor = new Finger(40);
  movers = new ArrayList<Mover>();

  fundo = loadImage("omar_full_1024.png");

  image(fundo, 0, 0);
  tint(255, 20);
  createDots("positions_20_1024.xml");
  noSmooth();
  baseBlow = new PVector(width/2, height);
  gravity = new PVector(0, 0);
}

void draw() {
  cursor.radius = 10;
  //background(255);

  // Draw water
  // liquid.display();

  for (int i = 0; i < movers.size(); i++) {

    //BLOW FUNCTION
    
//    Mover movers_ = movers.get(i);
//
//    friction(movers_);
//    movers_.applyForce(gravity);
//
//
//    // Update and display
//    movers_.update();
//    movers_.display();
//    movers_.checkEdges();


//FINGERS FUNCTIONS
    movers.get(i).displayDrag();
    cursor.update();
  }

  //  ellipse(baseBlow.x, baseBlow.y, 30, 30);
}

//void mousePressed() {
//  blow();
//}

//blow antonio
//void blow() {
//  for (int i = 0; i < movers.size(); i++) {
//    Mover movers_ = movers.get(i);
//    
//    float force = map( movers_.location.y, 0, height, 0, 15);
//    if (force < 1) {
//      println(force);
//    }
//    PVector direction = new PVector(0, force*-1);
//    movers_.applyForce(direction);
//  }
//}

//blow antonio e clelio
void blow() {
  for (int i = 0; i < movers.size(); i++) {
    Mover movers_ = movers.get(i);

    PVector actualLoc = movers_.location;
    float magBlowX;

    if (actualLoc.x < width/2) {
      magBlowX = -0.5 *  mag(baseBlow.x, actualLoc.x);
    }
    else {
      magBlowX = 0.5* mag(baseBlow.x, actualLoc.x);
    }
    float magBlowY = mag(baseBlow.y, actualLoc.y);


    float forceY = map( movers_.location.y, 0, height, 0, 2);
    float forceX = map( magBlowX, 0, height, 0, 2);
    if (forceY >= 0) {
      PVector direction = new PVector(0, forceY*-1);
      movers_.applyForce(direction);
    }
  }
}

void mousePressed() {

//  blow();
  cursor.clicked(movers);
  
}

void mouseDragged() {

  cursor.drag();
}

void mouseReleased() {

  cursor.moverIds.clear();
}


void keyPressed() {
  if (key=='s') {
    saveFrame("img/"+frameCount+"omar.png");
  }
  else if (key == CODED) {
    if (keyCode == UP) {
      gravity.y = gravity.y - 0.1;
    } 
    else if (keyCode == DOWN) {
      gravity.y = gravity.y + 0.1;
    } 
    else if (keyCode == LEFT) {
      gravity.x = gravity.x - 0.1;
    }
    else if (keyCode == RIGHT) {
      gravity.x = gravity.x + 0.1;
    }
  }

  println(gravity);
}

// Restart all the Mover objects randomly
//void reset() {
//  for (int i = 0; i < movers.length; i++) {
//    movers[i] = new Mover(random(0.5, 3), random(width), random(height));
//  }
//}


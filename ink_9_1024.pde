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

ArrayList<Mover> movers;

void setup() {
  size(768, 1024);
  background(255);
  movers = new ArrayList<Mover>();
  
  fundo = loadImage("omar_full_1024.png");
  
  image(fundo, 0, 0);

  createDots("positions_20_1024.xml");
  noSmooth();
  baseBlow = new PVector(width/2, height);
  gravity = new PVector(0,0);
}

void draw() {
  //background(255);

  // Draw water
  // liquid.display();

    for (int i = 0; i < movers.size(); i++) {
  
      Mover movers_ = movers.get(i);
      
      friction(movers_);
      movers_.applyForce(gravity);
  
  
      // Update and display
      movers_.update();
      movers_.display();
      movers_.checkEdges();
    }

  ellipse(baseBlow.x, baseBlow.y, 30, 30);
}

void mousePressed() {
  blow();
}

void blow() {
    for (int i = 0; i < movers.size(); i++) {
      Mover movers_ = movers.get(i);
      float force = map( movers_.location.y, 0, height, 0, 15);
      if(force < 1){
      println(force);
      }
      PVector direction = new PVector(0, force*-1);
      movers_.applyForce(direction);
    }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      gravity.y = gravity.y - 0.1;
    } else if (keyCode == DOWN) {
       gravity.y = gravity.y + 0.1;
    } else if(keyCode == LEFT){
     gravity.x = gravity.x - 0.1;
    }else if(keyCode == RIGHT){
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


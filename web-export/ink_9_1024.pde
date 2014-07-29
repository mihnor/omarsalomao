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

  createDots("positions_170_1024.xml");
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

// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com
 
 // Liquid class 
 class Liquid {

  
  // Liquid is a rectangle
  float x,y,w,h;
  // Coefficient of drag
  float c;

  Liquid(float x_, float y_, float w_, float h_, float c_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    c = c_;
  }
  
  // Is the Mover in the Liquid?
  boolean contains(Mover m) {
    PVector l = m.location;
    if (l.x > x && l.x < x + w && l.y > y && l.y < y + h) {
      return true;
    }  
    else {
      return false;
    }
  }
  
  // Calculate drag force
  PVector drag(Mover m) {
    // Magnitude is coefficient * speed squared
    float speed = m.velocity.mag();
    float dragMagnitude = c * speed * speed;

    // Direction is inverse of velocity
    PVector dragForce = m.velocity.get();
    dragForce.mult(-1);
    
    // Scale according to magnitude
    // dragForce.setMag(dragMagnitude);
    dragForce.normalize();
    dragForce.mult(dragMagnitude);
    return dragForce;
  }
  
  void display() {
    noStroke();
    fill(50);
    //rect(x,y,w,h);
  }

}

// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

class Mover {

  // location, velocity, and acceleration 
  PVector prevLocation;
  PVector location;
  PVector velocity;
  PVector acceleration;
  
  // Mass is tied to size
  float mass;

  Mover(float m, float x, float y) {
    mass = m;
    location = new PVector(x, y);
    prevLocation = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    
  }

  // Newton's 2nd law: F = M * A
  // or A = F / M
  void applyForce(PVector force) {
    // Divide by mass 
    PVector f = PVector.div(force, mass);
    // Accumulate all forces in acceleration
    acceleration.add(f);
  }

  void update() {
    
    prevLocation.x = location.x;
    prevLocation.y = location.y;
    
    // Velocity changes according to acceleration
    velocity.add(acceleration);
    // Location changes by velocity
    location.add(velocity);
    // We must clear acceleration each frame
    acceleration.mult(0);
    
    
  }
  
  // Draw Mover
  void display() {
    stroke(0);
    //strokeWeight(mass);
    //fill(127, 200);
    line(prevLocation.x, prevLocation.y, location.x, location.y);
   // ellipse(location.x, location.y, mass, mass);
    //println( prevLocation.y +" , " +  location.y);
  }
  
  // Bounce off bottom of window
  void checkEdges() {
    if (location.y > height) {
      velocity.y *= 0;  // A little dampening when hitting the bottom
      location.y = height;
    }
  }
}


void friction(Mover m) {

  float c = 0.6;
  PVector friction = m.velocity.get();
  if (friction.mag() <= c) {
    float d = friction.mag();
    friction.mult(-1);
    friction.normalize();
    friction.mult(d);
    m.applyForce(friction);
  } 
  else {
    friction.mult(-1);
    friction.normalize();
    friction.mult(c);

    //Apply the friction force vector to the object.
    m.applyForce(friction);
    //println(friction.y);
  }
}

XML xml;


void createDots(String fileName_) {

  xml = loadXML(fileName_);
  // Get all the child nodes named "bubble"
  XML[] children = xml.getChildren("pos");
  println(children.length);


  for (int i = 0; i < children.length; i++) {
    //    XML positionElement = children[i];


    int x = children[i].getInt("x");
    int y = children[i].getInt("y");
    println("x: "+ x + " y: " + y);
    movers.add(new Mover(2, x, y));
  }
}



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
    
    Mover movers_ = movers.get(i);

    friction(movers_);
    movers_.applyForce(gravity);


    // Update and display
    movers_.update();
    movers_.display();
    movers_.checkEdges();


//FINGERS FUNCTIONS
//    movers.get(i).displayDrag();
//    cursor.update();
  }

  //  ellipse(baseBlow.x, baseBlow.y, 30, 30);
}

void mousePressed() {
  blow();
}

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

//void mousePressed() {
//
////  blow();
//  cursor.clicked(movers);
//  
//}
//
//void mouseDragged() {
//
//  cursor.drag();
//}
//
//void mouseReleased() {
//
//  cursor.moverIds.clear();
//}


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



class Finger {

  
  ArrayList moverIds;
  float radius;
  PVector pos;
  boolean hide;

  Finger(float radius_) {

    this.radius = radius_;
    pos = new PVector(mouseX, mouseY);
    moverIds = new ArrayList<Integer>();
  };

  void clicked(ArrayList<Mover> mvs) {
    
    for (int i =0; i < mvs.size(); i++){
      
      Mover m = mvs.get(i);
      if(m.checkFinger(this)){
//        m.isActive = true;
        moverIds.add(i); 
      }else{
//        m.isActive = false;
      }
      
    }
     println(moverIds);
  }
  
  void drag(){
 

    
    for(int i = 0 ; i < moverIds.size(); i++){
     
       int id = (Integer)this.moverIds.get(i);
       
       
       movers.get(id).updateDrag(mouseX - pmouseX, mouseY - pmouseY);
       
    }
    
  };
  
  void update(){
    
    pos.set(mouseX, mouseY);
    
  }

  void display() {
    fill(255, 100);
    ellipse(pos.x, pos.y, radius, radius);
  };
}

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

  boolean isDead;
  float pixelRun;

  boolean isActive = false;

  // Mass is tied to size
  float mass;

  Mover(float m, float x, float y) {
    mass = m;
    location = new PVector(x, y);
    prevLocation = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    this.isActive = false;
  }

  // Newton's 2nd law: F = M * A
  // or A = F / M
  void applyForce(PVector force) {
    // Divide by mass 
    PVector f = PVector.div(force, mass);
    // Accumulate all forces in acceleration
    acceleration.add(f);
  }
  boolean getActive() {
    return this.isActive;
  }
  
  void updateDrag(int mX, int mY) {
    //    this.location.set(mX, mY);
    this.isActive = true;
    //    float distVecX = dist(prevLocation.x, mX);
    //    float distVecX = dist(prevLocation.y, mY);
    this.prevLocation = this.location;


    this.pixelRun += sqrt(pow(mX, 2) + pow(mY, 2));


    this.location.x =  mX + this.prevLocation.x;
    this.location.y =  mY + this.prevLocation.y;
    //    this.location.y =  mY;
    //    
    //    this.location.x = this.prevLocation.x - mX;
    //    this.location.y = this.prevLocation.y - mY;
    //
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


  boolean isDead() {
    if (this.pixelRun < 500) {
      return false;
    }
    else {
      return true;
    }
  }
  // Draw Mover
  void display() {
    float cx1, cx2, cy1, cy2;
    cx1 = 0.0;
    cy1 = 0.0;
    cx2 = 0.0;
    cy2 = 0.0;

    stroke(0, 150);
    strokeWeight(random(0.1, 2));
    //strokeWeight(mass);
    //fill(127, 200);
    noFill();
    bezier(prevLocation.x, prevLocation.y, prevLocation.x + cx1 + noise(cx1) +random(-1, 1), prevLocation.y + cy1  + noise(0, 2), location.x, location.y, location.x + cx2 + noise(0, 20)  + random(-1, 1), location.y + cy2 + noise(0, 20)  + random(0, 1));
    //    line(prevLocation.x, prevLocation.y, location.x, location.y);
    // ellipse(location.x, location.y, mass, mass);
    //println( prevLocation.y +" , " +  location.y);
  }
  
    void displayDrag() {

    float cx1, cx2, cy1, cy2;
    cx1 = 0.0;
    cy1 = 0.0;
    cx2 = 0.0;
    cy2 = 0.0;


    //    strokeWeight(noise(100,200));
    
    if ( !this.isDead() && this.getActive()) {
    
      strokeWeight(map(this.pixelRun, 0, 500, 4, 0.1));
      stroke(0, map(this.pixelRun, 0, 300, 20, 0));
      fill(0, map(this.pixelRun, 0, 300, 80, 10));
      ellipse(this.location.x, this.location.y,2,2);
      line(this.prevLocation.x, this.prevLocation.y, this.location.x, this.location.y);
//      bezier(prevLocation.x, prevLocation.y, prevLocation.x + cx1 + noise(prevLocation.x), prevLocation.y + cy1  + noise(prevLocation.y), location.x, location.y, location.x + cx2 + noise(location.x), location.y + cy2 + noise(location.y));
    }
    //    strokeWeight(random(0.1, 4));
    //fill(127, 200);
    
    //    bezier(prevLocation.x, prevLocation.y, prevLocation.x + cx1 + noise(cx1) +random(-1, 1), prevLocation.y + cy1  + noise(0, 2), location.x, location.y, location.x + cx2 + noise(0, 20)  + random(-1, 1), location.y + cy2 + noise(0, 20)  + random(0, 1)); 
        


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
  
    boolean checkFinger(Finger f) {


    return (this.location.dist(f.pos) < f.radius);
  }
  
}

void friction(Mover m) {

  float c = 0.04;
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
    movers.add(new Mover(random(0.5,2), x, y));
  }
}



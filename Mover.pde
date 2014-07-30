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


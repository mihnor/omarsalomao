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


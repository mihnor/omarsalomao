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


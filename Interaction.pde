
void keyPressed() {
  //if (key=='p') {
  //  showPoly=!showPoly;
  //}
  if (key=='s') {
    showSmoothPoly=!showSmoothPoly;
  }
  if (key=='m') {
    //show poly's mass center
    Vec2D center=poly.getCentroid();
    fill(0, 255, 0);
    ellipse(center.x, center.y, 50, 50);
  }
  if (keyCode==UP) {
    kinectAngle+=2;
    kinect.setTilt(kinectAngle);
  }
  if (keyCode==DOWN) {
    kinectAngle-=2;
    kinect.setTilt(kinectAngle);
  }
  if (key=='=') {
    maxDepth+=20;
  }
  if (key=='-') {
    maxDepth-=20;
  }

  //}
}
boolean showSmoothPoly=false;

void getBodyPoly() {

  smoothedImg=getSmoothedImage();

  //calculate blobs
  smoothedImg.loadPixels();
  theBlobDetection.computeBlobs(smoothedImg.pixels);

  //pushMatrix();
  //drawBlobsAndEdges(false, true);//drawPolygonBlobs
  //popMatrix();


  smoothPoly();
  if (showSmoothPoly) {
    noFill();
    stroke(0, 0, 255);
    pushMatrix();
    gfx.polygon2D(poly); 
    popMatrix();
  }

  polyConstraint.setPolygon(poly);
  //VerletPhysics2D.addConstraintToAll(polyConstraint, s.particles);
}




PImage getSmoothedImage() {

  PImage depthImg=new PImage(640, 480);


  //image(kinect.getDepthImage(), 640, 0, 160, 120);

  //for display
  depthImg.loadPixels();
  int[] rawDepth = kinect.getRawDepth();
  for (int i=0; i < rawDepth.length; i++) {
    //if (rawDepth[i] >= minDepth && rawDepth[i] <= maxDepth) {
    if (rawDepth[i] <= maxDepth) {
      depthImg.pixels[i] = color(0);//pixels are black between the min and max distance
    } else {
      depthImg.pixels[i] = color(255);
    }
  }

  depthImg.updatePixels();
  //image(depthImg, 640, 120, 160, 120);


  //depthImg.resize(320, 240);
  opencv.loadImage(kinect.getDepthImage());
  opencv.contrast(2);
  opencv.invert();


  PImage processedImg=opencv.getOutput();
  //image(processedImg, 640, 120, 160, 120);
  //processedImg.resize(640, 480);
  processedImg.loadPixels();
  int[] cs=processedImg.pixels;
  for (int i=0; i < cs.length; i++) {
    if (rawDepth[i] > maxDepth) {
      processedImg.pixels[i] = color(255);//pixels are black between the min and max distance
    } 
    //else {
    //  processedImg.pixels[i] = color(255);
    //}
  }
  processedImg.updatePixels();

  //processedImg.resize(320, 240);
  opencv.loadImage(processedImg);
  opencv.dilate();
  opencv.erode();
  opencv.blur(10);

  //The third pic
  processedImg=opencv.getOutput();
  //processedImg.resize(640, 480);
  //image(processedImg, 640, 240, 160, 120);
  return processedImg;
}



void smoothPoly(){
  // create the polygon from the blobs
  polyBlob.reset();
  polyBlob.createPolygon();//update Polygon2D object poly

  if (poly.getNumVertices()!=0) {

  try {
    poly.toOutline();
    poly=poly.reduceVertices(10);
    poly=poly.smooth(0.5, 0.25).smooth(0.5, 0.25);
  }
  catch(Exception e) {
  }
  }

}
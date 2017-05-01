//figure get
//next, rope
//next collision



import java.awt.Polygon;
import java.util.*;
import java.nio.*;
import processing.opengl.*; // opengl

import org.openkinect.processing.*;
import blobDetection.*;
import gab.opencv.*;

//PGraphics img;

Kinect kinect;
OpenCV opencv;
BlobDetection theBlobDetection;
PolygonBlob poly = new PolygonBlob();

int kinectWidth = 640;
int kinectHeight = 480;
int minDepth =  900;
//int maxDepth =  4500; //4.5m
int maxDepth =  1500;

PImage img;
PImage depthImg;

PImage blobs;

float reScale;

String[] palettes = {
  "-1117720,-13683658,-8410437,-9998215,-1849945,-5517090,-4250587,-14178341,-5804972,-3498634", 
  "-67879,-9633503,-8858441,-144382,-4996094,-16604779,-588031", 
  "-16711663,-13888933,-9029017,-5213092,-1787063,-11375744,-2167516,-15713402,-5389468,-2064585"
};

// ==================================================

// ==================================================
void setup()
{
  frameRate(15);
  // Works with Processing 2.0b3
  //img = createGraphics(640, 480);

  //img.beginDraw();
  //img.background(255);
  //img.noStroke();
  //img.fill(0);
  //for (int i=0;i<20;i++) {
  //  float r = random(50);
  //  img.ellipse(random(img.width), random(img.height), r, r);
  //}
  //img.endDraw();
  img=loadImage("cat.png");

  kinect=new Kinect(this);
  println("Kinect connected");
  kinect.initDepth();
  kinect.enableIR(true);

  opencv = new OpenCV(this, 640, 480);

  theBlobDetection = new BlobDetection(img.width, img.height);
  //theBlobDetection.setPosDiscrimination(false);
  theBlobDetection.setThreshold(0.2);

  // Size of applet
  size(1280, 960);
  blobs = createImage(640, 480, RGB);


  depthImg=new PImage(640, 480);
}

// ==================================================
// draw()
// ==================================================
void draw()
{
  background(100);
  //image(kinect.getVideoImage(), 0, 0);
  image(kinect.getDepthImage(), 0, 0);

  depthImg.loadPixels();

  int[] rawDepth = kinect.getRawDepth();
  for (int i=0; i < rawDepth.length; i++) {
    if (rawDepth[i] >= minDepth && rawDepth[i] <= maxDepth) {
      depthImg.pixels[i] = color(255);
    } else {
      depthImg.pixels[i] = color(0);
    }
  }

  depthImg.updatePixels();

  image(depthImg, 640, 0);

  opencv.loadImage(depthImg);
  opencv.gray();
  opencv.contrast(1.35);
  opencv.dilate();
  opencv.erode();
  opencv.blur(4);
  PImage processedImg=opencv.getOutput();
  image(processedImg, 0, 480);

  processedImg.loadPixels();
  theBlobDetection.computeBlobs(processedImg.pixels);
  pushMatrix();
  translate(0, 480);
  drawBlobsAndEdges(false, true);
  popMatrix();
  
  poly.reset();
  // create the polygon from the blobs (custom functionality, see class)
  poly.createPolygon();
  println(poly.contains(mouseX, mouseY));
    

  text(minDepth, 0, 20);
  text(maxDepth, 0, 50);
}

// ==================================================
// drawBlobsAndEdges()
// ==================================================
void drawBlobsAndEdges(boolean drawBlobs, boolean drawEdges)
{
  noFill();
  Blob b;
  EdgeVertex eA, eB;
  for (int n=0; n<theBlobDetection.getBlobNb(); n++)
  {
    b=theBlobDetection.getBlob(n);
    if (b!=null)
    {
      // Edges
      if (drawEdges)
      {
        strokeWeight(2);
        stroke(0, 255, 0);
        for (int m=0; m<b.getEdgeNb(); m++)
        {
          eA = b.getEdgeVertexA(m);
          eB = b.getEdgeVertexB(m);
          if (eA !=null && eB !=null)
            line(eA.x*depthImg.width, eA.y*depthImg.height, eB.x*depthImg.width, eB.y*depthImg.height);
        }
      }

      // Blobs
      if (drawBlobs)
      {
        strokeWeight(1);
        stroke(255, 0, 0);
        rect(b.xMin*depthImg.width, b.yMin*depthImg.height, b.w*depthImg.width, b.h*depthImg.height);
      }
    }
  }
}


void keyPressed() {
  if (key=='=') minDepth+=10;
  else if (key=='-') minDepth-=10;
  else if (key=='9') maxDepth+=10;
  else if (key=='0') maxDepth-=10;
}
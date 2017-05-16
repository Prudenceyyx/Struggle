//figure get

import java.awt.Polygon;
import java.util.*;
import java.nio.*;

import processing.opengl.*; // opengl

import org.openkinect.processing.*;
import blobDetection.*;
import gab.opencv.*;

Kinect kinect;
OpenCV opencv;

int kinectWidth = 640;
int kinectHeight = 480;
int minDepth =  450;
int maxDepth =  990;
int kinectAngle=7;

PImage img;
PImage smoothedImg;

BlobDetection theBlobDetection;//v3ga library
PolygonBlob polyBlob = new PolygonBlob();
Polygon2D poly;//Smoothed Bodyshape
//Vec2D prevCenter;

ArrayList<ParticleString2DK> removeList=new ArrayList<ParticleString2DK>();
ArrayList<ParticleString2D> groundropes=new ArrayList<ParticleString2D>();
float groundLevel=height*0.95;//under which the rope is locked and disappear after a certain time


void setup()
{
  frameRate(40);
  initKinect();
  initBlobDetection();
  size(640, 480);

  initRopes();
  polyConstraint = new PolygonConstraint(poly, false);
}

void draw()
{
  background(255);
  physics.update();
  getBodyPoly();//update Polygon2D poly

  //println(poly.getNumVertices()==0);// 0 if no people

  //1.If rope is on ground, remove all constraints, remove from ropes;

  for (ParticleString2DK rope : ropes) {

    if (rope.isOnGround()) {

      //rope.removeConstraints();
      removeList.add(rope);
      //add repulse effect in spring perhaps//in start when pressed the mosuse
      rope.getTail().lock();
    }
  }

  for (ParticleString2DK rope : removeList) {
    groundropes.add(rope);
    ropes.remove(rope);
  }
  removeList.clear();


  deleteGroundRopes();


  //2.if no people, then all the ropes are up to gravity
  if (poly.getNumVertices()==0) {
    println("no people");
    for (ParticleString2DK rope : ropes) {
      rope.unlock();
      //rope.removeConstraints();
    }
    //physics.removeConstraint(polyConstraint);
    //prevCenter=null;
  } else {
  //3.1 If people, add enough strings where the people is
    if (ropes.size()<10&&frameCount%20==0) {
      addRope();
      //nextTime=millis()+int(random(2000,4000));
    }
  //}

    //3.if new poly, translate the sticky particles according to the centroid
    //while the effect turns out not good;
    //Vec2D centroid=poly.getCentroid();
    //if(prevCenter==null){
    //  prevCenter=centroid;
    //}
    //Vec2D direction=centroid.sub(prevCenter);

    for (ParticleString2DK rope : ropes) {
      for (VerletParticle2D p : rope.particles) {
        if (p.isLocked()) {
          //p.set(p.x+direction.x,p.y+direction.y);
          Vec2D tp=poly.getClosestPointTo(p);
          if (tp!=null) {
            p.set(tp.x, tp.y);
          }
        }
      }
    }


    //4. if ropes collide with the poly constraint, particles are stuck to it util the rope is stuck.
    for (ParticleString2DK rope : ropes) {
      if (!rope.isSticky()) {//for ropes that are not yet sticky
        int i=0;
        while (!(rope.isSticky() || i==rope.particles.size())) {//make the free particle that collides with the polygon
          VerletParticle2D p=rope.particles.get(i);
          //Vec2D tp=new Vec2D(p.x, p.y);
          if (!p.isLocked() & poly.containsPoint(p)) {
            p.lock();//sticky until the string is sticky
            rope.stickyNumber++;
          }
          i+=1;
        }

        if (rope.isSticky()) {
          rope.timeStamp();//record the time it becomes sticky
          for (VerletParticle2D v : rope.particles) {
            if (!v.isLocked()) {//free the rest particles
              try {
                v.removeConstraint(polyConstraint);
              }
              catch(Exception e) {
              }
            }
          }
        }
      }
    }
    
  }
//5.for all sticky ropes, if it stays longer than a certain time, it falls
    fallRopes();
  
  Ropedraw();

//  text(minDepth, 0, 20);
//  text(maxDepth, 0, 50);
//  text(frameRate, 0, 80);
//  text(frameCount, 0, 110);
}


void addRope() {
  Vec2D stepDir=new Vec2D(random(-1, 1), random(0.5, 1)).normalizeTo(5);
  Vec2D centroid=poly.getCentroid();
  ParticleString2DK s=new ParticleString2DK(physics, new Vec2D(random(centroid.x-30, centroid.x+30), random(5, 10)), stepDir, 25, 1, 0.5);
  ropes.add(s);
  for (VerletParticle2D v : s.particles) {
    physics.addBehavior(new AttractionBehavior2D(v, 5, -3));
  }
}

void fallRopes() {
  int i=0;
  int now=millis();
  for (ParticleString2DK rope : ropes) {
    if (i<3) {
      if (rope.isSticky()) {
        if (now-rope.stickyTimeStamp>rope.stickyTimeLength) {
          rope.unlock();
          rope.removeConstraints();
          rope.stickyNumber=0;
        }
        i++;
      }
    } else {
      break;
    }
  }
}


void initKinect() {
  kinect=new Kinect(this);
  println("Kinect connected");
  kinect.initDepth();
  kinect.enableIR(true);
  kinect.enableMirror(true);
  kinect.setTilt(kinectAngle);
  opencv = new OpenCV(this, 640, 480);
}
//Added Surface Constrain

//Thread Demo
import toxi.physics2d.constraints.*;
import toxi.physics2d.behaviors.*;
import toxi.physics2d.*;
import toxi.geom.*;
import toxi.math.*;
import toxi.util.*;
import toxi.processing.*;

import java.util.Iterator;

int NUM_PARTICLES = 50;
int REST_LENGTH = 5;

VerletPhysics2D physics;
VerletParticle2D head,tail;

ToxiclibsSupport gfx;

Polygon2D poly;
PolygonConstraint polyConstraint;

boolean isTailLocked;

void setup() {
  size(600,600);
  smooth();
  physics=new VerletPhysics2D();
  physics.addBehavior(new GravityBehavior2D(new Vec2D(0, 0.15f)));
  physics.setWorldBounds(new Rect(0, 0, width, height));
  Vec2D stepDir=new Vec2D(1,1).normalizeTo(REST_LENGTH);
  ParticleString2D s=new ParticleString2D(physics, new Vec2D(), stepDir, NUM_PARTICLES, 1, 0.1);
  head=s.getHead();
  //head.lock();
  tail=s.getTail();
  
  //poly constrain
  poly = new Circle(100).toPolygon2D(9).translate(width / 2, height / 2);
  poly.get(0).x *= 0.66f;
  
  gfx = new ToxiclibsSupport(this);

  
  polyConstraint = new PolygonConstraint(poly,false);
  
  VerletPhysics2D.addConstraintToAll(polyConstraint, s.particles);
  
  
}

void draw() {
  background(255);
  //stroke(255,100);
    gfx.polygon2D(poly); 
  stroke(0);
  strokeWeight(2);
  noFill();
  //head.set(mouseX,mouseY);
  physics.update();
  //beginShape();
  //for(Iterator i=physics.particles.iterator(); i.hasNext();) {
  //  VerletParticle2D p=(VerletParticle2D)i.next();
  //  vertex(p.x,p.y);
  //}
  //endShape();
  
  for(VerletSpring2D s : physics.springs) {
    line(s.a.x,s.a.y, s.b.x, s.b.y);
  }
  for(Iterator i=physics.particles.iterator(); i.hasNext();) {
    VerletParticle2D p=(VerletParticle2D)i.next();
    ellipse(p.x,p.y,5,5);
  }
}

void mousePressed() {
  Vec2D stepDir=new Vec2D(1,1).normalizeTo(REST_LENGTH);
  ParticleString2D s=new ParticleString2D(physics, new Vec2D(mouseX,mouseY), stepDir, NUM_PARTICLES, 1, 0.1);
  VerletPhysics2D.addConstraintToAll(polyConstraint, s.particles);
  
  //isTailLocked=!isTailLocked;
  //if (isTailLocked) {
  //  tail.lock();
  //} 
  //else {
  //  tail.unlock();
  //}
}


//// http://codingtra.in
//// http://patreon.com/codingtrain
//// Code for: https://youtu.be/jrk_lOg_pVA

//import toxi.physics3d.*;
//import toxi.physics3d.behaviors.*;
//import toxi.physics3d.constraints.*;
//import toxi.geom.*;

//float zoff = 0.0;

//int cols = 40;
//int rows = 40;

//Particle[][] particles = new Particle[cols][rows];
//ArrayList<Spring> springs;

//float w = 8;//Spring length

//PImage flag;

//VerletPhysics3D physics;

//void setup() {
//  size(800, 600, P3D); 
//  springs = new ArrayList<Spring>();

//  physics = new VerletPhysics3D();
//  Vec3D gravity = new Vec3D(0, 0.05, 0);
//  //Vec3D gravity = new Vec3D(0.05, 0, 0);
//  GravityBehavior3D gb = new GravityBehavior3D(gravity);
//  physics.addBehavior(gb);

  
//  float y = -rows*w/2;
//  for (int j = 0; j < rows; j++) {
//    float x = -cols*w/2;
//    for (int i = 0; i < cols; i++) {
    
    
//      Particle p = new Particle(x, y, 0);
//      particles[i][j] = p;
//      physics.addParticle(p);
//      x = x + w;
//      w+=0.1;
      
//    }
//    w=8;
//    y = y + w;
//  }

//  for (int i = 0; i < cols; i++) {
//    for (int j = 0; j < rows; j++) {
//      Particle a = particles[i][j];
//      if (i != cols-1) {
//        Particle b1 = particles[i+1][j];
//        Spring s1 = new Spring(a, b1);
//        springs.add(s1);
//        physics.addSpring(s1);
//      }
//      //if (j != rows-1) {
//      //  Particle b2 = particles[i][j+1];
//      //  Spring s2 = new Spring(a, b2);
//      //  springs.add(s2);
//      //  physics.addSpring(s2);
//      //}
//    }
//  }
//  for(int i=0;i<rows;i++){
//  particles[0][i].lock();
//  }

//  //particles[0][0].lock();
//  //particles[0][rows-1].lock();
//}
//float a = 0;

//void draw() {
//  background(51);
//  translate(width/2, height/2);
//  //rotateY(a);
//  a += 0.01;
//  physics.update();

//  strokeWeight(4);
//  stroke(255);
//  line(-cols*w/2, -rows*w/2, -cols*w/2, rows*w);

//  stroke(255);
//  noStroke();
//  noFill();
//  float yoff = 0;
//  for (int j = 0; j < rows; j++) {
//    //beginShape(TRIANGLE_STRIP);
//    float xoff = 0;
//    for (int i = 0; i < cols-1; i++) {
//      //float u = map(i, 0, cols, 0, flag.width);
//      //float v = map(j, 0, rows, 0, flag.height);
//      Particle p1= particles[i][j];
//      //vertex(p1.x, p1.y, p1.z, u, v);
//      vertex(p1.x,p1.y,p1.z);
//      //Particle p2= particles[i][j+1];
//      //v = map(j+1, 0, rows, 0, flag.height);
//      //vertex(p2.x, p2.y, p2.z, u, v);
//      Particle p2= particles[i+1][j];
//      vertex(p2.x, p2.y, p2.z);
//      particles[i][j].display();

//      float wx = map(noise(xoff, yoff, zoff), 0, 1, -0.1, 1);
//      float wy = map(noise(xoff+5000, yoff+5000, zoff), 0, 1, -0.1, 0.1);
//      float wz = map(noise(xoff+10000, yoff+10000, zoff), 0, 1, -0.1, 0.1);
//      //Vec3D wind = new Vec3D(wx,wy,wz);
//      //p1.addForce(wind);
//      xoff += 0.1;
//    }
//    yoff += 0.1;
//    //endShape();
//  }

//  for (Spring s : springs) {
//    s.display();
//  }
//  zoff += 0.1;
//}
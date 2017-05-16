//Added Surface Constrain
//Added Stickiness
//Added polygon transformation
//Thread Demo
import toxi.physics2d.constraints.*;
import toxi.physics2d.behaviors.*;
import toxi.physics2d.*;
import toxi.geom.*;
import toxi.math.*;
import toxi.util.*;
import toxi.processing.*;

import java.util.Iterator;
import java.util.List;

int NUM_PARTICLES = 25;
int REST_LENGTH = 5;

VerletPhysics2D physics;
VerletParticle2D head, tail;

ToxiclibsSupport gfx;


PolygonConstraint polyConstraint;
ArrayList<ParticleString2DK> ropes=new ArrayList<ParticleString2DK>();


void initRopes() {
  physics=new VerletPhysics2D();
  physics.addBehavior(new GravityBehavior2D(new Vec2D(0, 0.15f)));
  physics.setWorldBounds(new Rect(0, 0, width, height));

  gfx = new ToxiclibsSupport(this);
  
}


//void collisionDetect(){
//   for (ParticleString2DK rope : ropes) {
//    rope.checkStickiness();
//    rope.update();
//  }
//}

void deleteGroundRopes() {

  int i=0;//when the ground ropes are too many, delete them, but only delete at most 6 roeps at one time


  while (groundropes.size()>20 && frameCount%70==0 && i<8) {
    //when there are too many grounropes
    ParticleString2D rope=(ParticleString2D)groundropes.remove(0);
    i+=1;
    for (VerletParticle2D p : rope.particles) {   
      physics.removeParticle(p);
    }
    for (VerletSpring2D s : rope.links) {
      physics.removeSpring(s);
    }
  }
}


void Ropedraw() {
  //stroke(255,100);
  stroke(0);
  strokeWeight(6);
  fill(0,180);
  for (VerletSpring2D s : physics.springs) {
    line(s.a.x, s.a.y, s.b.x, s.b.y);
  }
  noStroke();
  for (Iterator i=physics.particles.iterator(); i.hasNext(); ) {
    VerletParticle2D p=(VerletParticle2D)i.next();
    ellipse(p.x, p.y, 4, 4);
  }
}

void mousePressed() {
  //Add a rope
  Vec2D stepDir=new Vec2D(random(-1, 1), random(0.5, 1)).normalizeTo(REST_LENGTH);
  ParticleString2DK s=new ParticleString2DK(physics, new Vec2D(mouseX, mouseY), stepDir, NUM_PARTICLES, 1, 0.5);
  //VerletPhysics2D.addConstraintToAll(polyConstraint, s.particles);
  for(VerletParticle2D v:s.particles){
   physics.addBehavior(new AttractionBehavior2D(v, 7, -3));
  }
  ropes.add(s);
}
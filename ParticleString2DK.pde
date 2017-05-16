
class ParticleString2DK extends ParticleString2D {
  boolean stickiness=false;
  int stickyParameter;
  int stickyTimeLength;
  int stickyTimeStamp;
  int stickyNumber=0;
  
  //Constructors
  //ParticleString2DK(VerletPhysics2D physics, 
  //  List<VerletParticle2D> plist, float strength) {
  //  super( physics, plist, strength);
  //  stickyParameter=random(2,6)/10; //0.4~0.7
  //  stickyTimeLength=int(random(3000,6000));
  //}

  ParticleString2DK(VerletPhysics2D physics, Vec2D pos, Vec2D step, 
    int num, float mass, float strength) {
    super( physics, pos, step, num, mass, strength);
    stickyParameter=int(random(4,7)/10*num); 
    stickyTimeLength=int(random(8000,13000));
  }

  boolean isOnGround(){
    int onGroundNum=0;
   for (VerletParticle2D p : particles) {
      if(p.y>height*0.9){
         onGroundNum+=1;
      }
    }
   return onGroundNum/this.particles.size()>=0.6;
  }

  void unlock(){
    for (VerletParticle2D p : particles) {
      p.unlock();
    }
    this.stickyNumber=0;
  }
  void timeStamp(){
    this.stickyTimeStamp=millis();
  }

  boolean isSticky() {
    return stickyNumber>stickyParameter;
  }

  void checkStickiness() {
    this.stickyNumber=0;
    for (VerletParticle2D p : particles) {
      if (p.isLocked()) {
        stickyNumber+=1;
      }
    }

    
  }
  
  void removeConstraints(){
    for (Iterator i=physics.particles.iterator(); i.hasNext(); ) {
      VerletParticle2D p=(VerletParticle2D)i.next();
      p.unlock();
      try{
      p.removeConstraint(polyConstraint);
      }catch(Exception e){
      }
    }
    stickiness=false;
  }
  

  //void update() {
  //  if (this.isSticky()) {
  //    for (VerletParticle2D p : particles) {
  //      if (!p.isLocked()) {
  //        p.removeAllConstraints();
  //        //p.removeConstraints((ParticleConstarint2D)polyConstraint);
  //      }
  //    }
  //  } else {
  //    for (VerletParticle2D p : particles) {
  //      //If the particle collides with the constraint
  //      //stick the particle to it
  //      if (this.stickiness==false) {
  //        Vec2D tp=new Vec2D(p.x, p.y);
  //        if (poly.containsPoint(tp)) {
  //          p.lock();
  //          this.checkStickiness();
  //        }
  //      }
  //    }
  //  }
  //}
}
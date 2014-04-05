//
//  MotionManagerSingleton.m
//  MyFirstGame
//
//  Created by STEFAN on 29.03.14.
//  Copyright (c) 2014 Stefan. All rights reserved.
//

#import "MotionManagerSingleton.h"


#define cLowPassFacor 0.95

@implementation MotionManagerSingleton

static CMMotionManager* _motionManager;
static CMAttitude* _referenceAttitude;
static bool bActive;

+(CMMotionManager*)getMotionManager {
    if (_motionManager==nil) {
        _motionManager=[[CMMotionManager alloc]init];
        _motionManager.deviceMotionUpdateInterval=0.25;
        bActive=true;
        [_motionManager startDeviceMotionUpdates];
    } else if (bActive==false) {
        bActive=true;
        [_motionManager startDeviceMotionUpdates];
    }
    return _motionManager;
}


+(GLKVector3)getMotionVectorWithLowPass{
    // Motion
    CMAttitude *attitude = self.getMotionManager.deviceMotion.attitude;
    if (_referenceAttitude==nil) {
        // Cache Start Orientation
        _referenceAttitude = [_motionManager.deviceMotion.attitude copy];
    } else {
        // Use start orientation to calibrate
        [attitude multiplyByInverseOfAttitude:_referenceAttitude];
    }
    return [self lowPassWithVector: GLKVector3Make(attitude.pitch,attitude.roll,attitude.yaw)];
}

+(void)stop {
    if (_motionManager!=nil) {
        [_motionManager stopDeviceMotionUpdates];
        bActive=false;
    }
}


+(GLKVector3)lowPassWithVector:(GLKVector3)vector
{
    static GLKVector3 lastVector;
    
    
    vector.x = vector.x * cLowPassFacor + lastVector.x * (1.0 - cLowPassFacor);
	vector.y = vector.y * cLowPassFacor + lastVector.y * (1.0 - cLowPassFacor);
    vector.z = vector.z * cLowPassFacor + lastVector.z * (1.0 - cLowPassFacor);
    
    lastVector = vector;
    return vector;
}

@end

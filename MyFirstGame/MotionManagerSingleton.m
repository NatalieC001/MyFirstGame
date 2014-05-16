//
//  MotionManagerSingleton.m
//  MotionDemo
//
//  Created by STEFAN on 07.04.14.
//  Copyright (c) 2014 Stefan. All rights reserved.
//


#import "MotionManagerSingleton.h"

// Damping factor
#define cLowPassFacor 0.95

@implementation MotionManagerSingleton

static CMMotionManager* _motionManager;
static CMAttitude* _referenceAttitude;
static bool bActive;

// only one instance of CMMotionManager can be used in your project.
// => Implement as Singleton which can be used in the whole application
+(CMMotionManager*)getMotionManager {
    if (_motionManager==nil) {
        _motionManager=[[CMMotionManager alloc]init];
        _motionManager.deviceMotionUpdateInterval=0.25;
        [_motionManager startDeviceMotionUpdates];
        bActive=true;
    } else if (bActive==false) {
        [_motionManager startDeviceMotionUpdates];
        bActive=true;
    }
    return _motionManager;
}

// Returns a vector with the orientation values
// At the first time a reference orientation is saved to ensure the motion detection works for multiple device positions
+(GLKVector3)getMotionVectorWithLowPass{
    // Motion
    CMAttitude *attitude = self.getMotionManager.deviceMotion.attitude;
    if (_referenceAttitude==nil) {
        // Cache Start Orientation to calibrate the device. Wait for a short time to give MotionManager enough time to initialize
        [self performSelector:@selector(calibrate) withObject:nil afterDelay:0.25];
        
    } else {
        // Use start orientation to calibrate
        [attitude multiplyByInverseOfAttitude:_referenceAttitude];
        NSLog(@"roll: %f", attitude.roll);
    }
    return [self lowPassWithVector: GLKVector3Make(attitude.yaw,attitude.roll,attitude.pitch)];
}

+(void)calibrate {
    _referenceAttitude = [self.getMotionManager.deviceMotion.attitude copy];
}

// Stop collection motion data to save energy
+(void)stop {
    if (_motionManager!=nil) {
        [_motionManager stopDeviceMotionUpdates];
        _referenceAttitude=nil;
        bActive=false;
    }
}

// Damp the jitter caused by hand movement
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

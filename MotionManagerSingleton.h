//
//  MotionManagerSingleton.h
//  MyFirstGame
//
//  Created by STEFAN on 29.03.14.
//  Copyright (c) 2014 Stefan. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>
#import <GLKit/GLKit.h>

@interface MotionManagerSingleton : NSObject

+(GLKVector3)getMotionVectorWithLowPass;
+(void)stop;

@end

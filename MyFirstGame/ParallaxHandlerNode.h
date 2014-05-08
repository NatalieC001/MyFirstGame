//
//  ParallaxHandlerNode.h
//  MyFirstGame
//
//  Created by STEFAN on 24.03.14.
//  Copyright (c) 2014 Stefan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "MotionManagerSingleton.h"
#import <GLKit/GLKit.h>

@interface ParallaxHandlerNode : SKNode

-(void)addBackgroundLayer:(NSArray*)tiles DirectionY:(int)directionY StepSize:(float)stepSize ScaleFactorX:(float)scaleFactorX ScaleFactorY:(float)scaleFactorY;

-(void)scroll:(float)speed;

-(id)initWithSize:(CGSize)Size;

@end

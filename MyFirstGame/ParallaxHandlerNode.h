//
//  ParallaxHandlerNode.h
//  MyFirstGame
//
//  Created by STEFAN on 24.03.14.
//  Copyright (c) 2014 Stefan. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "MotionManagerSingleton.h" // New
#import <GLKit/GLKit.h> // New

@interface ParallaxHandlerNode : SKNode

-(void)addBackgroundLayer:(NSArray*)tiles;

-(void)scroll:(float)speed;

-(id)initWithSize:(CGSize)Size;

@end

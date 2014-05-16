//
//  ParallaxHandlerNode.m
//  MyFirstGame
//
//  Created by STEFAN on 24.03.14.
//  Copyright (c) 2014 Stefan. All rights reserved.
//

#import "ParallaxHandlerNode.h"

#define cFactorForAngleToGetSpeedX 6
#define cFactorForAngleToGetSpeedY 1.5
#define cSpeedY 4 // speed in y direction is independend from horizontal speed

@implementation ParallaxHandlerNode

CGSize _containerSize;
NSMutableArray* _directions;
NSMutableArray* _stepsizes;

-(id)initWithSize:(CGSize)size {
    _containerSize=size;
    // Initialize the Arrays to store the direction and stepsize information
    _directions = [[NSMutableArray alloc] init];
    _stepsizes = [[NSMutableArray alloc] init];
    
    return [self init];
}

// Add a background layer.
-(void)addBackgroundLayer:(NSArray*)tiles DirectionY:(int)directionY StepSize:(float)stepSize ScaleFactorX:(float)scaleFactorX ScaleFactorY:(float)scaleFactorY{
    
    [_directions addObject:[NSNumber numberWithInt:directionY]];
    [_stepsizes addObject:[NSNumber numberWithFloat:stepSize]];
    
    // Create static background
    if ([tiles count]==1 ) {
        SKSpriteNode *background=[SKSpriteNode spriteNodeWithImageNamed:(NSString*)[tiles objectAtIndex:0]];
        // Scale size to enable parallax effect
        background.size=CGSizeMake(_containerSize.width*scaleFactorX, _containerSize.height*scaleFactorY);
        background.position=CGPointMake(_containerSize.width/2, _containerSize.height/2);
        [self addChild:background];
    } else {
        // Create a background for infinite scrolling
        
        // Create a SKNode a root element
        SKNode *background=[[SKNode alloc]init];
        [self addChild:background];
        
        // Create and add tiles to the node
        for (int i=0; i<[tiles count]; i++) {
            NSString *item = [tiles objectAtIndex:i];
            SKSpriteNode *tile;
            if (![item isEqualToString: @""]) {
                // Add an emtpy screen
                tile=[SKSpriteNode spriteNodeWithImageNamed:item];
                // Scale size to enable parallax effect
                tile.size=CGSizeMake(_containerSize.width, _containerSize.height * scaleFactorY);
                tile.position=CGPointMake(_containerSize.width/2+(i*_containerSize.width), (_containerSize.width-tile.size.width)/2);
            } else {
                tile=[[SKSpriteNode alloc] init];
                // Scale size to enable parallax effect
                tile.size=CGSizeMake(_containerSize.width, _containerSize.height * scaleFactorY);
                tile.position=CGPointMake(_containerSize.width/2+(i*_containerSize.width), _containerSize.height/2);
            }
            [background addChild:tile];
        }
        // position background at the second screen
        background.position=CGPointMake(-_containerSize.width, _containerSize.height/2);
    }
}

// Infinite scrolling:
// - Scroll the backgrounds and switch back if the end or the start screen is reached
// - Speed depends on layer to simulate deepth
-(void)scroll:(float)speed {
    
    GLKVector3 vMotionVector = [MotionManagerSingleton getMotionVectorWithLowPass];
    float dMotionFactorX=vMotionVector.x*cFactorForAngleToGetSpeedX;
    float dMotionFactorY=vMotionVector.y*cFactorForAngleToGetSpeedY;
    
    CGPoint parallaxPos;
    
    for (int i=0; i<self.children.count;i++) {
        SKNode *node = [self.children objectAtIndex:i];
        SKSpriteNode *spriteNode;
        parallaxPos=node.position;
        
        // If more than one screen => Scrolling with tiles
        if (node.children.count>0) {
            spriteNode = (SKSpriteNode*)[node.children objectAtIndex:0];
            parallaxPos.x+=speed*(i+1)*dMotionFactorX; //Changed
            
            if (dMotionFactorX>0) {
                if (parallaxPos.x>=0) {
                    // switch between first and last screen
                    parallaxPos.x=-_containerSize.width*(node.children.count-1);
                }
            } else if (dMotionFactorX<0) {
                if (parallaxPos.x<-_containerSize.width*(node.children.count-1)) {
                    // switch between last and first screen
                    parallaxPos.x=0;
                }
            }
        } else {
            spriteNode = (SKSpriteNode*)node;
            float dDiff=(spriteNode.size.width - _containerSize.width)/2;
            parallaxPos.x+=speed*(i+1)*dMotionFactorX;
            if (dMotionFactorX>0) {
                if (parallaxPos.x>=_containerSize.width/2+dDiff) {
                    parallaxPos.x=_containerSize.width/2+dDiff;
                }
            } else if (dMotionFactorX<0) {
                if (parallaxPos.x<_containerSize.width/2-dDiff) {
                    parallaxPos.x=_containerSize.width/2-dDiff;
                }
            }
        }
        
        // Vertical scrolling
        float dDiffY=(spriteNode.size.height - _containerSize.height)/2; // pixels above and below to scroll
        float dStepSize=[[_stepsizes objectAtIndex:i] floatValue]; // Scrolling speed depends on level
        int iDirection=[[_directions objectAtIndex:i] intValue]; // Scroll backgroundimage in another direction to enhance parallax effect
        
        parallaxPos.y+=cSpeedY*dStepSize*dMotionFactorY*iDirection; // Calculate new position
        
        // Check if bounds are reached
        if (dMotionFactorY*iDirection>0) {
            if (parallaxPos.y>=_containerSize.height/2+dDiffY) {
                parallaxPos.y=_containerSize.height/2+dDiffY;
            }
        } else {
            if (parallaxPos.y<_containerSize.height/2-dDiffY) {
                parallaxPos.y=_containerSize.height/2-dDiffY;
            }
        }
        
        // Set the new position
        node.position = parallaxPos;
    }
}

@end

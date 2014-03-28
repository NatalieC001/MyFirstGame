//
//  ParallaxHandlerNode.m
//  MyFirstGame
//
//  Created by STEFAN on 24.03.14.
//  Copyright (c) 2014 Stefan. All rights reserved.
//

#import "ParallaxHandlerNode.h"

@implementation ParallaxHandlerNode

CGSize _containerSize;

-(id)initWithSize:(CGSize)size {
    _containerSize=size;
    return [self init];
}


// Add a background layer.
-(void)addBackgroundLayer:(NSArray*)tiles {

    // Create static background
    if ([tiles count]==1 ) {
        SKSpriteNode *background=[SKSpriteNode spriteNodeWithImageNamed:(NSString*)[tiles objectAtIndex:0]];
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
                tile.position=CGPointMake(_containerSize.width/2+(i*_containerSize.width), 0);
            } else {
                tile=[[SKSpriteNode alloc] init];
                tile.size=_containerSize;
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
// - Speed depends on layer to simulare deepth
-(void)scroll:(float)speed {
    
    for (int i=0; i<self.children.count;i++) {
        SKNode *node = [self.children objectAtIndex:i];
        // If more than one screen => Scrolling
        if (node.children.count>0) {
            
            float parallaxPos=node.position.x;
            NSLog(@"x: %f", parallaxPos);
            if (speed>0) {
                parallaxPos+=speed*i;
                if (parallaxPos>=0) {
                    // switch between first and last screen
                    parallaxPos=-_containerSize.width*(node.children.count-1);
                }
            } else if (speed<0) {
                
                parallaxPos+=speed*i;
                if (parallaxPos<-_containerSize.width*(node.children.count-1)) {
                    // switch between last and first screen
                    parallaxPos=0;
                }
            }
            
            // Set new node position. Position can't be set directly, therefore tempPos is used.
            CGPoint tmpPos=node.position;
            tmpPos.x    = parallaxPos;
            node.position = tmpPos;
            
        }
    }
}
@end

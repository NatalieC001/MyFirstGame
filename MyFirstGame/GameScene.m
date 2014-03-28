//
//  GameScene.m
//  MyFirstGame
//
//  Created by STEFAN on 24.03.14.
//
//  Copyright (c) 2014 Stefan. All rights reserved.
//

#import "GameScene.h"
#import "ParallaxHandlerNode.h"

// Constants
#define cStartSpeed 5
#define cMaxSpeed 80

@implementation GameScene


// private properties
NSTimeInterval _lastUpdateTime;
NSTimeInterval _dt;
int _speed=cStartSpeed;


ParallaxHandlerNode *background;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        [self addBackgrounds];
        
    }
    return self;
}

// Increase speed after touch event up to 5 times.
// After maximum speed is reached the next touch changes the scroll direction
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_speed<cMaxSpeed && _speed>-cMaxSpeed) {
        _speed=_speed*2;
    } else {
        if (_speed<0) {
            _speed=cStartSpeed;
        } else {
            _speed=-cStartSpeed;
        }
    }
}

// Add the background elements for parallax scrolling
-(void)addBackgrounds {
    
    // Array contains the name of the background tiles. "" for adding an empty screen
    NSArray  *nameBackground = [NSArray arrayWithObjects: @"Background", nil];
    NSArray  *nameBush = [NSArray arrayWithObjects:@"BackgroundBushLeft", @"BackgroundBushRight", @"", @"BackgroundBushLeft", nil];
    NSArray  *nameTree = [NSArray arrayWithObjects:@"BackgroundTreeLeft", @"BackgroundTreeRight", @"BackgroundTreeLeft" ,nil];
    NSArray  *nameGrass = [NSArray arrayWithObjects:@"", @"BackgroundGrassCenter", @"", nil];
    
    // Root node which contains the tree of backgrounds/background tiles
    background = [[ParallaxHandlerNode alloc] initWithSize:self.size];
    [self addChild:background];
    
    [background addBackgroundLayer:nameBackground];
    [background addBackgroundLayer:nameBush];
    [background addBackgroundLayer:nameTree];
    [background addBackgroundLayer:nameGrass];
    
}

// The GameLoop
-(void)update:(NSTimeInterval)currentTime {
     
     // Needed for smooth scrolling. It's not guaranteed, that the update method is not called in fixed intervalls
     if (_lastUpdateTime) {
         _dt = currentTime - _lastUpdateTime;
     } else {
         _dt = 0;
     }
     _lastUpdateTime = currentTime;
    
    // Scroll
    [background scroll:_speed*_dt];

}

@end

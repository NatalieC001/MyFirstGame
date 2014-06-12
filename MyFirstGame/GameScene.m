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


#pragma mark - Private properties
@interface GameScene ()
    @property (nonatomic, retain) SKSpriteNode* LifeNode1;
    @property (nonatomic, retain) SKSpriteNode* LifeNode2;
    @property (nonatomic, retain) SKSpriteNode* LifeNode3;
    @property (nonatomic, retain) SKLabelNode* ScoreNode;
    @property (nonatomic, retain) SKLabelNode* LevelNode;
    @property (nonatomic) int Lifes;
@end


#pragma mark - Constants

// Constants
#define cStartSpeed 5
#define cMaxSpeed 80

@implementation GameScene

NSTimeInterval _lastUpdateTime;
NSTimeInterval _dt;
int _speed=cStartSpeed;
ParallaxHandlerNode *background;

#pragma mark - Init
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        [self addBackgrounds];
        [self createHUD];
        [self addMockUpButtons];
    }
    return self;
}


/// Add the background elements for parallax scrolling
-(void)addBackgrounds {
    
    // Array contains the name of the background tiles. "" for adding an empty screen
    NSArray  *nameBackground = [NSArray arrayWithObjects: @"Background", nil];
    NSArray  *nameBush = [NSArray arrayWithObjects:@"BackgroundBushLeft", @"BackgroundBushRight", @"", @"BackgroundBushLeft", nil];
    NSArray  *nameTree = [NSArray arrayWithObjects:@"BackgroundTreeLeft", @"BackgroundTreeRight", @"BackgroundTreeLeft" ,nil];
    NSArray  *nameGrass = [NSArray arrayWithObjects:@"", @"BackgroundGrassCenter", @"", nil];
    
    // Root node which contains the tree of backgrounds/background tiles
    background = [[ParallaxHandlerNode alloc] initWithSize:self.size];
    [self addChild:background];
    
    
    // Move background which is farest away fastest => Physically not correct, but enough to realize illusion of depths. Otherwise the player is distracted to much by the movements
    [background addBackgroundLayer:nameBackground DirectionY:-1 StepSize:0.9 ScaleFactorX:1.2 ScaleFactorY:1.09];
    [background addBackgroundLayer:nameBush DirectionY:1 StepSize:0.7 ScaleFactorX:1.0 ScaleFactorY:1.07];
    [background addBackgroundLayer:nameTree DirectionY:1 StepSize:0.5 ScaleFactorX:1.0 ScaleFactorY:1.05];
    [background addBackgroundLayer:nameGrass DirectionY:1 StepSize:0.3 ScaleFactorX:1.0 ScaleFactorY:1.03];
    
}

#pragma mark - HUD handling

/// Adds the HUD to the scene
-(void)createHUD {
    
    // root node with black background
    SKSpriteNode* hud = [[SKSpriteNode alloc] initWithColor:[UIColor blackColor] size:CGSizeMake(self.size.width, self.size.height*0.05)];
    hud.anchorPoint=CGPointMake(0, 0);
    hud.position = CGPointMake(0, self.size.height-hud.size.height);
    [self addChild:hud];
    
    // remaining/lost lifes
    self.Lifes=3;
    self.LifeNode1 = [[SKSpriteNode alloc] initWithImageNamed:@"HUD_Ball"];
    self.LifeNode1.position=CGPointMake(self.LifeNode1.size.width, hud.size.height/2);
    [hud addChild:self.LifeNode1];
    self.LifeNode2 = [[SKSpriteNode alloc] initWithImageNamed:@"HUD_Ball"];
    self.LifeNode2.position=CGPointMake(self.LifeNode2.size.width*2.5, hud.size.height/2);
    [hud addChild:self.LifeNode2];
    self.LifeNode3 = [[SKSpriteNode alloc] initWithImageNamed:@"HUD_Ball"];
    self.LifeNode3.position=CGPointMake(self.LifeNode3.size.width*4, hud.size.height/2);
    [hud addChild:self.LifeNode3];
    
    // current level
    self.Level=1;
    self.LevelNode = [[SKLabelNode alloc] init];
    self.LevelNode.position = CGPointMake(hud.size.width/2, 1);
    self.LevelNode.text=@"Level 1";
    self.LevelNode.fontSize=hud.size.height;
    [hud addChild:self.LevelNode];
    
    // pause button
    SKLabelNode* pauseButton = [[SKLabelNode alloc] init];
    pauseButton.position = CGPointMake(hud.size.width/1.5, 1);
    pauseButton.text=@"II";
    pauseButton.fontSize=hud.size.height;
    pauseButton.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    pauseButton.name=@"PauseButton";
    [hud addChild:pauseButton];
    
    // score
    self.Score=0;
    self.ScoreNode = [[SKLabelNode alloc] init];
    self.ScoreNode.position = CGPointMake(hud.size.width-hud.size.width*.1, 1);
    self.ScoreNode.text=@"0";
    self.ScoreNode.fontSize=hud.size.height;
    [hud addChild:self.ScoreNode];

}

/// Temporary added buttons to simulate player events like score or life lost
-(void)addMockUpButtons {

    SKSpriteNode* lifeLost = [[SKSpriteNode alloc] initWithColor:[UIColor redColor] size:CGSizeMake(self.size.width/3, self.size.height*0.1)];
    lifeLost.name=@"lifeLost";
    lifeLost.position=CGPointMake(self.size.width/2, lifeLost.size.height);
    [self addChild:lifeLost];
    
    SKSpriteNode* addScore = [[SKSpriteNode alloc] initWithColor:[UIColor greenColor] size:CGSizeMake(self.size.width/3, self.size.height*0.1)];
    addScore.name=@"addScore";
    addScore.position=CGPointMake(self.size.width/2, lifeLost.size.height*3);
    [self addChild:addScore];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // Get the element which is touched:
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    // Trigger actions
    if ([node.name isEqualToString:@"PauseButton"]) {
        [self showPausedDialog];
    } else if ([node.name isEqualToString:@"lifeLost"]) {
        [self lifeLost];
    } else if ([node.name isEqualToString:@"addScore"]) {
        [self addScore];
    }
}

-(void)addScore {
    self.Score+=100;
    self.ScoreNode.text=[NSString stringWithFormat:@"%d",self.Score];
}

-(void)lifeLost {
    if (_Lifes==1) {
        self.LifeNode3.texture = [SKTexture textureWithImageNamed:@"HUD_Ball_crossed"];
        [self showGameOverAlert];
    } else {
        if (self.Lifes==2) {
            self.LifeNode2.texture = [SKTexture textureWithImageNamed:@"HUD_Ball_crossed"];
        } else if (self.Lifes==3) {
            self.LifeNode1.texture = [SKTexture textureWithImageNamed:@"HUD_Ball_crossed"];
        }
    }
    self.Lifes--;
}

-(void)showPausedDialog {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Paused" message:@"" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:@"Finish!", nil, nil];
    alert.tag=1;
    [alert show];
}

// show GameOver Alert
-(void)showGameOverAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil, nil];
    alert.tag=2;
    [alert show];
}

// React on Alert
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1) {
        if (buttonIndex==1) {
            // Notify Delegate
            [self.delegateContainerViewController gameStop];
        }
    } else if (alertView.tag==2) {
        // Notify Delegate
        [self.delegateContainerViewController gameOver];
    }
}


#pragma mark - GameLoop

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

//
//  GameViewController.m
//  MyFirstGame
//
//  Created by STEFAN on 19.02.14.
//  Copyright (c) 2014 Stefan. All rights reserved.
//

#import "GameViewController.h"
#import "UITools.h"
#import "GameScene.h"

@interface GameViewController ()

@end

@implementation GameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [UITools assignBackgroundParallaxBehavior:self.backgroundView];
    [UITools assignForegroundParallaxBehavior:self.foregroundViews];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    SKView * skView = [[SKView alloc]initWithFrame:self.view.frame]; //(SKView *)self.view;
    [self.view addSubview:skView];
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    GameScene *gameScene = [GameScene sceneWithSize:skView.bounds.size];
    gameScene.scaleMode = SKSceneScaleModeResizeFill; //SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:gameScene];
    gameScene.delegateContainerViewController=self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) gameStop {
    [self performSegueWithIdentifier: @"BackToStart" sender: self];
}
-(void) gameOver {
    [self performSegueWithIdentifier: @"AddHighScore" sender: self];
}

@end

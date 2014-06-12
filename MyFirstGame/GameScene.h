//
//  GameScene.h
//  MyFirstGame
//
//  Created by STEFAN on 24.03.14.
//  Copyright (c) 2014 Stefan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GameSceneDelegate <NSObject>

@required
-(void) gameStop;
-(void) gameOver;

@end

@interface GameScene : SKScene

@property int Score;
@property int Level;


@property (nonatomic,strong)  id<GameSceneDelegate> delegateContainerViewController;

@end

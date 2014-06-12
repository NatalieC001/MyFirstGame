//
//  GameViewController.h
//  MyFirstGame
//
//  Created by STEFAN on 19.02.14.
//  Copyright (c) 2014 Stefan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameScene.h"



@interface GameViewController : UIViewController <GameSceneDelegate>

    @property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
    @property (strong, nonatomic) IBOutletCollection(UIView) NSArray *foregroundViews;

@end

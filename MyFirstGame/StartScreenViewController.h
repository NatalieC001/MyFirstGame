//
//  StartScreenViewController.h
//  MyFirstGame
//
//  Created by STEFAN JOSTEN on 10.02.14.
//  Copyright (c) 2014 Stefan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartScreenViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *foregroundViews;

@end

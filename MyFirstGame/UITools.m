//
//  UITools.m
//  MyFirstGame
//
//  Created by STEFAN on 18.02.14.
//  Copyright (c) 2014 Stefan. All rights reserved.
//

#import "UITools.h"

@implementation UITools

+(void)assignBackgroundParallaxBehavior:(UIView*) view {
    CGRect frameRect = view.frame;
    
    // increase size of screen for 20%
    frameRect.size.width = view.frame.size.width * 1.2;
    frameRect.size.height = view.frame.size.height * 1.2;
    
    // Set origin to the center of the resized frame
    frameRect.origin.x=(view.frame.size.width-frameRect.size.width)/2;
    frameRect.origin.y=(view.frame.size.height-frameRect.size.height)/2;
    view.frame = frameRect;
    
    // Create horizontal motion effect
    UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    
    // Limit movement of the motion effect
    horizontalMotionEffect.minimumRelativeValue = @(frameRect.origin.x);
    horizontalMotionEffect.maximumRelativeValue = @(-frameRect.origin.x);
    
    // Assign horizontal motion effect to view
    [view addMotionEffect:horizontalMotionEffect];
    
    // Create vertical motion effect
    UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    
    // Limit movement of the motion effect
    verticalMotionEffect.minimumRelativeValue = @(frameRect.origin.y);
    verticalMotionEffect.maximumRelativeValue = @(-frameRect.origin.y);
    
    // Assign vertical motion effect to view
    [view addMotionEffect:verticalMotionEffect];
    
}

+(void)assignForegroundParallaxBehavior:(NSArray*) view {
    int iMotionEffectSteps=20;
    
    // Create horizontal motion effect
    UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(iMotionEffectSteps);
    horizontalMotionEffect.maximumRelativeValue = @(-iMotionEffectSteps);
    
    // Create vertical motion effect
    UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(iMotionEffectSteps);
    verticalMotionEffect.maximumRelativeValue = @(-iMotionEffectSteps);
    
    // Assign motion effects to every view of the outlet collection
    for (int i=0; i<view.count; i++) {
        [view[i] addMotionEffect:horizontalMotionEffect];
        [view[i] addMotionEffect:verticalMotionEffect];
    }
    
}

@end

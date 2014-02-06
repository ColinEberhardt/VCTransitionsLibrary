//
//  UINavigationController+ABExtras.m
//  SquaresFlipNavigationExample
//
//  Created by Andrés Brun on 8/8/13.
//  Copyright (c) 2013 Andrés Brun. All rights reserved.
//

#import "UINavigationController+ABExtras.h"

@implementation UINavigationController (ABExtras)


- (float) calculateYPosition
{
    float yPosition=0;
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (!self.navigationBarHidden) {
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation)){
            yPosition += self.navigationBar.frame.size.height;
        }else{
            yPosition += self.navigationBar.frame.size.width;
        }
    }
    
    if (IS_EARLIER_IOS7 && ![UIApplication sharedApplication].statusBarHidden){
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation)){
            yPosition += [UIApplication sharedApplication].statusBarFrame.size.height;
        }else{
            yPosition += [UIApplication sharedApplication].statusBarFrame.size.width;
        }
    }
    
    return yPosition;
    
}

@end

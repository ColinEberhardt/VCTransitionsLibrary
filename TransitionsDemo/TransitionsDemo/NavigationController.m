//
//  MyNavigationControllerViewController.m
//  ViewControllerTransitions
//
//  Created by Colin Eberhardt on 09/09/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "NavigationController.h"
#import "AppDelegate.h"
#import "CEFlipAnimationController.h"
#import "CESwipeInteractionController.h"
#import "CEBaseInteractionController.h"

@interface NavigationController () <UINavigationControllerDelegate>

@end

@implementation NavigationController {
    CEBaseInteractionController* _swipeController;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
        AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.navigationController = self;
        
        // Custom initialization
        self.delegate = self;
        
        _swipeController = [CESwipeInteractionController new];
        
        self.animationController = [CEFlipAnimationController new];
        self.animationController.duration = 1.0f;
    }
    return self;
}


- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    if (operation == UINavigationControllerOperationPush) {
        [_swipeController wireToViewController:toVC];
    }
    
    if (self.animationController) {
        self.animationController.reverse = operation == UINavigationControllerOperationPop;
    }
    
    return self.animationController;
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    
    
    return _swipeController.interactionInProgress ? _swipeController : nil;
}

@end

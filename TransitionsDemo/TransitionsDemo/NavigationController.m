//
//  MyNavigationControllerViewController.m
//  ViewControllerTransitions
//
//  Created by Colin Eberhardt on 09/09/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "NavigationController.h"
#import "AppDelegate.h"
#import "CEBaseInteractionController.h"
#import "CEReversibleAnimationController.h"

@interface NavigationController () <UINavigationControllerDelegate>

@end

@implementation NavigationController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.delegate = self;
    }
    return self;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    [self wirePopInteractionControllerTo:viewController];
}

- (void)wirePopInteractionControllerTo:(UIViewController *)viewController
{
    // when a push occurs, wire the interaction controller to the to- view controller
    if (!AppDelegateAccessor.navigationControllerInteractionController) {
        return;
    }
    
    [AppDelegateAccessor.navigationControllerInteractionController wireToViewController:viewController forOperation:CEInteractionOperationPop];
}


- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    if (AppDelegateAccessor.navigationControllerAnimationController) {
        AppDelegateAccessor.navigationControllerAnimationController.reverse = operation == UINavigationControllerOperationPop;
    }
    
    return AppDelegateAccessor.navigationControllerAnimationController;
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    
    // if we have an interaction controller - and it is currently in progress, return it
    return AppDelegateAccessor.navigationControllerInteractionController && AppDelegateAccessor.navigationControllerInteractionController.interactionInProgress ? AppDelegateAccessor.navigationControllerInteractionController : nil;
}

@end

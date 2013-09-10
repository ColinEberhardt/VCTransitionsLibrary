//
//  MyNavigationControllerViewController.m
//  ViewControllerTransitions
//
//  Created by Colin Eberhardt on 09/09/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "NavigationController.h"
#import "CEReversibleAnimationController.h"
#import "CEFlipAnimationController.h"
#import "CESwipeInteractionController.h"
#import "CEBaseInteractionController.h"

@interface NavigationController () <UINavigationControllerDelegate>

@end

@implementation NavigationController {
    CEReversibleAnimationController* _animationController;
    CEBaseInteractionController* _swipeController;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        // Custom initialization
        self.delegate = self;
        
        _swipeController = [CESwipeInteractionController new];
        
        _animationController = [CEFlipAnimationController new];
        _animationController.duration = 1.0f;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    if (operation == UINavigationControllerOperationPush) {
        [_swipeController wireToViewController:toVC];
    }
    
    _animationController.reverse = operation == UINavigationControllerOperationPop;
    
    return _animationController;
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    
    
    return _swipeController.interactionInProgress ? _swipeController : nil;
}

@end

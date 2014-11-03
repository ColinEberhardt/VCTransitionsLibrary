//
//  CEPanAnimationController.m
//  TransitionsDemo
//
//  Created by Alvin Zeng on 01/08/2014.
//  Copyright (c) 2014 Alvin Zeng. All rights reserved.
//

#import "CEPanAnimationController.h"

@implementation CEPanAnimationController

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {
    
    self.duration = .3;
    // Add the toView to the container
    UIView* containerView = [transitionContext containerView];
    [containerView addSubview:toView];
    toView.frame = CGRectMake(self.reverse ? -160 : 320, toView.frame.origin.y, toView.frame.size.width, toView.frame.size.height);
    
    self.reverse ? [containerView sendSubviewToBack:toView] : [containerView bringSubviewToFront:toView];
    
    // animate
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        fromView.frame = CGRectMake(!self.reverse ? -160 : 320, fromView.frame.origin.y, fromView.frame.size.width, fromView.frame.size.height);
        toView.frame = CGRectMake(0, toView.frame.origin.y, toView.frame.size.width, toView.frame.size.height);
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            toView.frame = CGRectMake(0, toView.frame.origin.y, toView.frame.size.width, toView.frame.size.height);
            fromView.frame = CGRectMake(0, fromView.frame.origin.y, fromView.frame.size.width, fromView.frame.size.height);
        } else {
            // reset from- view to its original state
            [fromView removeFromSuperview];
            fromView.frame = CGRectMake(!self.reverse ? -160 : 320, fromView.frame.origin.y, fromView.frame.size.width, fromView.frame.size.height);
            toView.frame = CGRectMake(0, toView.frame.origin.y, toView.frame.size.width, toView.frame.size.height);
        }
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
}

@end

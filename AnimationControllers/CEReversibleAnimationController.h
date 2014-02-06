//
//  CEBaseAnimationController.h
//  ViewControllerTransitions
//
//  Created by Colin Eberhardt on 09/09/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 A base class for animation controllers which provide reversible animations. A reversible animation is often used with navigation controllers where the reverse property is set based on whether this is a push or pop operation, or for modal view controllers where the reverse property is set based o whether this is a show / dismiss.
 */
@interface CEReversibleAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

/**
 The direction of the animation.
 */
@property (nonatomic, assign) BOOL reverse;

/**
 The animation duration.
 */
@property (nonatomic, assign) NSTimeInterval duration;

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView;

@end

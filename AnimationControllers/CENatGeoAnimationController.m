//
//  CENatGeoAnimationController.m
//  TransitionsDemo
//
//  Created by Paweł Wrzosek on 22.10.2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "CENatGeoAnimationController.h"

static const CGFloat kAnimationFirstPartRatio = 0.8f;

@implementation CENatGeoAnimationController

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    // Grab the from and to view controllers from the context
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [transitionContext.containerView addSubview:fromViewController.view];
    [transitionContext.containerView addSubview:toViewController.view];
    
    CALayer *fromLayer;
    CALayer *toLayer;
    
    if (self.reverse) {
        toViewController.view.userInteractionEnabled = YES;
        
        fromLayer = toViewController.view.layer;
        toLayer = fromViewController.view.layer;
        
        // Reset to initial transform
        sourceLastTransform(fromLayer);
        destinationLastTransform(toLayer);
        
        
        //Perform animation
        [UIView animateWithDuration:kAnimationFirstPartRatio * self.duration
                              delay:(1.0f - kAnimationFirstPartRatio) * self.duration
                            options:UIViewAnimationOptionCurveLinear animations:^{
                                destinationFirstTransform(toLayer);
                            } completion:nil];
        
        [UIView animateWithDuration:self.duration
                              delay:0.0f
                            options:0
                         animations:^{
                             sourceFirstTransform(fromLayer);
                         } completion:^(BOOL finished) {
                             CGRect oldFrame = [fromLayer frame];
                             [fromLayer setAnchorPoint:CGPointMake(0.5f, 0.5f)];
                             [fromLayer setFrame:oldFrame];
                             
                             [transitionContext completeTransition:YES];
                         }];
        
    } else {
        fromViewController.view.userInteractionEnabled = NO;
        
        fromLayer = fromViewController.view.layer;
        toLayer = toViewController.view.layer;
        
        // Change anchor point and reposition it.
        CGRect oldFrame = fromLayer.frame;
        [fromLayer setAnchorPoint:CGPointMake(0.0f, 0.5f)];
        [fromLayer setFrame:oldFrame];
        
        // Reset to initial transform
        sourceFirstTransform(fromLayer);
        destinationFirstTransform(toLayer);
        
        //Perform animation
        [UIView animateWithDuration:self.duration
                              delay:0.0f
                            options:0
                         animations:^{
                             destinationLastTransform(toLayer);
                         } completion:nil];
        
        [UIView animateWithDuration:kAnimationFirstPartRatio * self.duration
                              delay:(1.0f - kAnimationFirstPartRatio) * self.duration
                            options:0
                         animations:^{
                             sourceLastTransform(fromLayer);
                         }
                         completion:^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                         }];
    }
    
}

#pragma mark -

#pragma mark - Required 3d Transform
static void sourceFirstTransform(CALayer *layer) {
    CATransform3D t = CATransform3DIdentity;
    t.m34 = 1.0 / -500;
    t = CATransform3DTranslate(t, 0.0f, 0.0f, 0.0f);
    layer.transform = t;
}

static void sourceLastTransform(CALayer *layer) {
    CATransform3D t = CATransform3DIdentity;
    t.m34 = 1.0 / -500.0f;
    t = CATransform3DRotate(t, radianFromDegree(80), 0.0f, 1.0f, 0.0f);
    t = CATransform3DTranslate(t, 0.0f, 0.0f, -30.0f);
    t = CATransform3DTranslate(t, 170.0f, 0.0f, 0.0f);
    layer.transform = t;
}

static void destinationFirstTransform(CALayer * layer) {
    CATransform3D t = CATransform3DIdentity;
    t.m34 = 1.0f / -500.0f;
    // Rotate 5 degrees within the axis of z axis
    t = CATransform3DRotate(t, radianFromDegree(5.0f), 0.0f, 0.0f, 1.0f);
    // Reposition toward to the left where it initialized
    t = CATransform3DTranslate(t, 320.0f, -40.0f, 150.0f);
    // Rotate it -45 degrees within the y axis
    t = CATransform3DRotate(t, radianFromDegree(-45), 0.0f, 1.0f, 0.0f);
    // Rotate it 10 degrees within thee x axis
    t = CATransform3DRotate(t, radianFromDegree(10), 1.0f, 0.0f, 0.0f);
    layer.transform = t;
}

static void destinationLastTransform(CALayer * layer) {
    CATransform3D t = CATransform3DIdentity;
    t.m34 = 1.0/ -500;
    // Rotate to 0 degrees within z axis
    t = CATransform3DRotate(t, radianFromDegree(0), 0.0f, 0.0f, 1.0f);
    // Bring back to the final position
    t = CATransform3DTranslate(t, 0.0f, 0.0f, 0.0f);
    // Rotate 0 degrees within y axis
    t = CATransform3DRotate(t, radianFromDegree(0), 0.0f, 1.0f, 0.0f);
    // Rotate 0 degrees within  x axis
    t = CATransform3DRotate(t, radianFromDegree(0), 1.0f, 0.0f, 0.0f);
    layer.transform = t;
}

#pragma mark - Convert Degrees to Radian
static double radianFromDegree(float degrees) {
    return (degrees / 180) * M_PI;
}

@end

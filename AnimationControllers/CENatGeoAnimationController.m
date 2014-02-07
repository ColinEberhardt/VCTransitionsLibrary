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
        [UIView animateKeyframesWithDuration:self.duration
                                       delay:0.0
                                     options:UIViewKeyframeAnimationOptionCalculationModeCubic
                                  animations:^{
            
            [UIView addKeyframeWithRelativeStartTime:0.0f
                                    relativeDuration:kAnimationFirstPartRatio
                                            animations:^{
                sourceFirstTransform(fromLayer);
            }];
            
            [UIView addKeyframeWithRelativeStartTime:0.0f
                                    relativeDuration:1.0f
                                          animations:^{
                destinationFirstTransform(toLayer);
            }];
            
        } completion:^(BOOL finished) {
            // Bring the from view back to the front and re-disable the user
            // interaction of the to view since the dismissal has been cancelled
            if ([transitionContext transitionWasCancelled])
            {
                [transitionContext.containerView bringSubviewToFront:fromViewController.view];
                toViewController.view.userInteractionEnabled = NO;
            }
			
            fromViewController.view.layer.transform = CATransform3DIdentity;
            toViewController.view.layer.transform = CATransform3DIdentity;
            transitionContext.containerView.layer.transform = CATransform3DIdentity;
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
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
        [UIView animateKeyframesWithDuration:self.duration
                                       delay:0.0
                                     options:UIViewKeyframeAnimationOptionCalculationModeCubic
                                  animations:^{
            
            [UIView addKeyframeWithRelativeStartTime:0.0f
                                    relativeDuration:1.0f
                                          animations:^{
                destinationLastTransform(toLayer);
            }];
            
            [UIView addKeyframeWithRelativeStartTime:(1.0f - kAnimationFirstPartRatio)
                                    relativeDuration:kAnimationFirstPartRatio
                                          animations:^{
                sourceLastTransform(fromLayer);
            }];

        } completion:^(BOOL finished) {
            // Bring the from view back to the front and re-enable its user
            // interaction since the presentation has been cancelled
            if ([transitionContext transitionWasCancelled])
            {
                [transitionContext.containerView bringSubviewToFront:fromViewController.view];
                fromViewController.view.userInteractionEnabled = YES;
            }
			
            fromViewController.view.layer.transform = CATransform3DIdentity;
            toViewController.view.layer.transform = CATransform3DIdentity;
            transitionContext.containerView.layer.transform = CATransform3DIdentity;
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
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

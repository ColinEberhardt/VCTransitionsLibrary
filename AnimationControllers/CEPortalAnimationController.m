//
//  ZENPortalAnimationController.m
//  ZEN BabyBook
//
//  Created by Frédéric ADDA on 07/12/2013.
//  Copyright (c) 2013 Frédéric ADDA. All rights reserved.
//

#import "CEPortalAnimationController.h"

@implementation CEPortalAnimationController

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {
    
    if(self.reverse){
        [self executeReverseAnimation:transitionContext fromVC:fromVC toVC:toVC fromView:fromView toView:toView];
    } else {
        [self executeForwardsAnimation:transitionContext fromVC:fromVC toVC:toVC fromView:fromView toView:toView];
    }
    
}

#define ZOOM_SCALE 0.8
- (void)executeForwardsAnimation:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {
    
    UIView *containerView = [transitionContext containerView];

    // Add a reduced snapshot of the toView to the container
    UIView *toViewSnapshot = [toView resizableSnapshotViewFromRect:toView.frame afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
    CATransform3D scale = CATransform3DIdentity;
    toViewSnapshot.layer.transform = CATransform3DScale(scale, ZOOM_SCALE, ZOOM_SCALE, 1);
    [containerView addSubview:toViewSnapshot];
    [containerView sendSubviewToBack:toViewSnapshot];
    
    
    // Create two-part snapshots of the from- view
    
    // snapshot the left-hand side of the from- view
    CGRect leftSnapshotRegion = CGRectMake(0, 0, fromView.frame.size.width / 2, fromView.frame.size.height);
    UIView *leftHandView = [fromView resizableSnapshotViewFromRect:leftSnapshotRegion  afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
    leftHandView.frame = leftSnapshotRegion;
    [containerView addSubview:leftHandView];
    
    // snapshot the right-hand side of the from- view
    CGRect rightSnapshotRegion = CGRectMake(fromView.frame.size.width / 2, 0, fromView.frame.size.width / 2, fromView.frame.size.height);
    UIView *rightHandView = [fromView resizableSnapshotViewFromRect:rightSnapshotRegion  afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
    rightHandView.frame = rightSnapshotRegion;
    [containerView addSubview:rightHandView];
    
    // remove the view that was snapshotted
    [fromView removeFromSuperview];
    
    // animate
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         // Open the portal doors of the from-view
                         leftHandView.frame = CGRectOffset(leftHandView.frame, - leftHandView.frame.size.width, 0);
                         rightHandView.frame = CGRectOffset(rightHandView.frame, rightHandView.frame.size.width, 0);
                         
                         // zoom in the to-view
                         toViewSnapshot.center = toView.center;
                         toViewSnapshot.frame = toView.frame;
                         
                     } completion:^(BOOL finished) {
                         
                         // remove all the temporary views
                         if ([transitionContext transitionWasCancelled]) {
                             [containerView addSubview:fromView];
                             [self removeOtherViews:fromView];
                         } else {
                             // add the real to- view and remove the snapshots
                             [containerView addSubview:toView];
                             [self removeOtherViews:toView];
                         }
                         
                         // inform the context of completion
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
    
}



- (void)executeReverseAnimation:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {
    
    UIView *containerView = [transitionContext containerView];

    // Add the from-view to the container
    [containerView addSubview:fromView];
    
    // add the to- view and send offscreen (we need to do this in order to allow snapshotting)
    toView.frame = CGRectOffset(toView.frame, toView.frame.size.width, 0);
    [containerView addSubview:toView];
    
    
    // Create two-part snapshots of the to- view
    
    // snapshot the left-hand side of the to- view
    CGRect leftSnapshotRegion = CGRectMake(0, 0, toView.frame.size.width / 2, toView.frame.size.height);
    UIView *leftHandView = [toView resizableSnapshotViewFromRect:leftSnapshotRegion  afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
    leftHandView.frame = leftSnapshotRegion;
    // reverse animation : start from beyond the edges of the screen
    leftHandView.frame = CGRectOffset(leftHandView.frame, - leftHandView.frame.size.width, 0);
    [containerView addSubview:leftHandView];
    
    // snapshot the right-hand side of the to- view
    CGRect rightSnapshotRegion = CGRectMake(toView.frame.size.width / 2, 0, toView.frame.size.width / 2, toView.frame.size.height);
    UIView *rightHandView = [toView resizableSnapshotViewFromRect:rightSnapshotRegion  afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
    rightHandView.frame = rightSnapshotRegion;
    // reverse animation : start from beyond the edges of the screen
    rightHandView.frame = CGRectOffset(rightHandView.frame, rightHandView.frame.size.width, 0);
    [containerView addSubview:rightHandView];
    
    // animate
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         // Close the portal doors of the to-view
                         leftHandView.frame = CGRectOffset(leftHandView.frame, leftHandView.frame.size.width, 0);
                         rightHandView.frame = CGRectOffset(rightHandView.frame, - rightHandView.frame.size.width, 0);
                         
                         // Zoom out the from-view
                         CATransform3D scale = CATransform3DIdentity;
                         fromView.layer.transform = CATransform3DScale(scale, ZOOM_SCALE, ZOOM_SCALE, 1);

                         
                     } completion:^(BOOL finished) {
                         
                         // remove all the temporary views
                         if ([transitionContext transitionWasCancelled]) {
                             [self removeOtherViews:fromView];
                         } else {
                             [self removeOtherViews:toView];
                             toView.frame = containerView.bounds;
                         }
                         
                         // inform the context of completion
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
}


// removes all the views other than the given view from the superview
- (void)removeOtherViews:(UIView*)viewToKeep {
    UIView *containerView = viewToKeep.superview;
    for (UIView *view in containerView.subviews) {
        if (view != viewToKeep) {
            [view removeFromSuperview];
        }
    }
}

@end

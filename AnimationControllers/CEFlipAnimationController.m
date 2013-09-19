//
//  CEFlipAnimationController.m
//  ViewControllerTransitions
//
//  Created by Colin Eberhardt on 09/09/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "CEFlipAnimationController.h"

@implementation CEFlipAnimationController


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {
    
    // Add the toView to the container
    UIView* containerView = [transitionContext containerView];
    [containerView addSubview:toView];
    [containerView sendSubviewToBack:toView];
    
    // Add a perspective transform
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -0.002;
    [containerView.layer setSublayerTransform:transform];
    
    // Give both VCs the same start frame
    CGRect initialFrame = [transitionContext initialFrameForViewController:fromVC];
    fromView.frame =  initialFrame;
    toView.frame = initialFrame;
    
    // create two-part snapshots of both the from- and to- views
    NSArray* toViewSnapshots = [self createSnapshots:toView afterScreenUpdates:YES];
    UIView* flippedSectionOfToView = toViewSnapshots[self.reverse ? 0 : 1];
    
    NSArray* fromViewSnapshots = [self createSnapshots:fromView afterScreenUpdates:NO];
    UIView* flippedSectionOfFromView = fromViewSnapshots[self.reverse ? 1 : 0];
    
    // replace the from- and to- views with container views that include gradients
    flippedSectionOfFromView = [self addShadowToView:flippedSectionOfFromView reverse:!self.reverse];
    UIView* flippedSectionOfFromViewShadow = flippedSectionOfFromView.subviews[1];
    flippedSectionOfFromViewShadow.alpha = 0.0;
    
    flippedSectionOfToView = [self addShadowToView:flippedSectionOfToView reverse:self.reverse];
    UIView* flippedSectionOfToViewShadow = flippedSectionOfToView.subviews[1];
    flippedSectionOfToViewShadow.alpha = 1.0;
    
    // change the anchor point so that the view rotate around the correct edge
    [self updateAnchorPointAndOffset:CGPointMake(self.reverse ? 0.0 : 1.0, 0.5) view:flippedSectionOfFromView];
    [self updateAnchorPointAndOffset:CGPointMake(self.reverse ? 1.0 : 0.0, 0.5) view:flippedSectionOfToView];
    
    // rotate the to- view by 90 degrees, hiding it
    flippedSectionOfToView.layer.transform = [self rotate:self.reverse ? M_PI_2 : -M_PI_2];
    
    // animate
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [UIView animateKeyframesWithDuration:duration
                                   delay:0.0
                                 options:0
                              animations:^{
                                  [UIView addKeyframeWithRelativeStartTime:0.0
                                                          relativeDuration:0.5
                                                                animations:^{
                                                                    // rotate the from- view to 90 degrees
                                                                    flippedSectionOfFromView.layer.transform = [self rotate:self.reverse ? -M_PI_2 : M_PI_2];
                                                                    flippedSectionOfFromViewShadow.alpha = 1.0;
                                                                }];
                                  [UIView addKeyframeWithRelativeStartTime:0.5
                                                          relativeDuration:0.5
                                                                animations:^{
                                                                    // rotate the to- view to 0 degrees
                                                                    flippedSectionOfToView.layer.transform = [self rotate:self.reverse ? 0.001 : -0.001];
                                                                    flippedSectionOfToViewShadow.alpha = 0.0;
                                                                }];
                              } completion:^(BOOL finished) {
                                  
                                  // remove all the temporary views
                                  if ([transitionContext transitionWasCancelled]) {
                                      [self removeOtherViews:fromView];
                                  } else {
                                      [self removeOtherViews:toView];
                                  }
                                  
                                  // inform the context of completion
                                  [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                              }];
    
}

// removes all the views other than the given view from the superview
- (void)removeOtherViews:(UIView*)viewToKeep {
    UIView* containerView = viewToKeep.superview;
    for (UIView* view in containerView.subviews) {
        if (view != viewToKeep) {
            [view removeFromSuperview];
        }
    }
}

// adds a gradient to an image by creating a containing UIView with both the given view
// and the gradient as subviews
- (UIView*)addShadowToView:(UIView*)view reverse:(BOOL)reverse {
    
    UIView* containerView = view.superview;
    
    // create a view with the same frame
    UIView* viewWithShadow = [[UIView alloc] initWithFrame:view.frame];
    
    // replace the view that we are adding a shadow to
    [containerView insertSubview:viewWithShadow aboveSubview:view];
    [view removeFromSuperview];
    
    // create a shadow
    UIView* shadowView = [[UIView alloc] initWithFrame:viewWithShadow.bounds];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = shadowView.bounds;
    gradient.colors = @[(id)[UIColor colorWithWhite:0.0 alpha:0.0].CGColor,
                        (id)[UIColor colorWithWhite:0.0 alpha:0.5].CGColor];
    gradient.startPoint = CGPointMake(reverse ? 0.0 : 1.0, 0.0);
    gradient.endPoint = CGPointMake(reverse ? 1.0 : 0.0, 0.0);
    [shadowView.layer insertSublayer:gradient atIndex:1];
    
    // add the original view into our new view
    view.frame = view.bounds;
    [viewWithShadow addSubview:view];
    
    // place the shadow on top
    [viewWithShadow addSubview:shadowView];
    
    return viewWithShadow;
}

// creates a pair of snapshots from the given view
- (NSArray*)createSnapshots:(UIView*)view afterScreenUpdates:(BOOL) afterUpdates{
    UIView* containerView = view.superview;
    
    // snapshot the left-hand side of the view
    CGRect snapshotRegion = CGRectMake(0, 0, view.frame.size.width / 2, view.frame.size.height);
    UIView *leftHandView = [view resizableSnapshotViewFromRect:snapshotRegion  afterScreenUpdates:afterUpdates withCapInsets:UIEdgeInsetsZero];
    leftHandView.frame = snapshotRegion;
    [containerView addSubview:leftHandView];
    
    // snapshot the right-hand side of the view
    snapshotRegion = CGRectMake(view.frame.size.width / 2, 0, view.frame.size.width / 2, view.frame.size.height);
    UIView *rightHandView = [view resizableSnapshotViewFromRect:snapshotRegion  afterScreenUpdates:afterUpdates withCapInsets:UIEdgeInsetsZero];
    rightHandView.frame = snapshotRegion;
    [containerView addSubview:rightHandView];
    
    // send the view that was snapshotted to the back
    [containerView sendSubviewToBack:view];
    
    return @[leftHandView, rightHandView];
}

// updates the anchor point for the given view, offseting the frame to compensate for the resulting movement
- (void)updateAnchorPointAndOffset:(CGPoint)anchorPoint view:(UIView*)view {
    view.layer.anchorPoint = anchorPoint;
    float xOffset =  anchorPoint.x - 0.5;
    view.frame = CGRectOffset(view.frame, xOffset * view.frame.size.width, 0);
}


- (CATransform3D) rotate:(CGFloat) angle {
    return  CATransform3DMakeRotation(angle, 0.0, 1.0, 0.0);
}

@end

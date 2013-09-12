//
//  CEAccordionAnimationController.m
//  TransitionsDemo
//
//  Created by Colin Eberhardt on 12/09/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "CEAccordionAnimationController.h"

@implementation CEAccordionAnimationController

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView {
    
    // Add the toView to the container
    UIView* containerView = [transitionContext containerView];
    [containerView addSubview:toView];
    [containerView sendSubviewToBack:toView];
    
    // Add a perspective transform
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -0.005;
  //  [containerView.layer setSublayerTransform:transform];
    
    CGSize size = toView.frame.size;
    
    NSMutableArray *snapshots = [NSMutableArray new];
    
    CGFloat sections = 6.0f;
    CGFloat sectionWidth = size.width / sections;
    
    UIView *firstContainer = [[UIView alloc] initWithFrame:containerView.bounds];
    [firstContainer.layer setSublayerTransform:transform];
    [containerView addSubview:firstContainer];
    
    UIView *previousContainer = firstContainer;
    
    for (CGFloat x=0; x < size.width; x+= sectionWidth) {
        CGRect snapshotRegion = CGRectMake(x, 0, sectionWidth, size.height);
        UIView *snapshot = [fromView resizableSnapshotViewFromRect:snapshotRegion  afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
        snapshot.frame = CGRectMake(0, 0, sectionWidth, size.height);
        
        UIView *snapshotContainer = [[UIView alloc] initWithFrame:containerView.bounds];
        snapshotContainer.backgroundColor = [UIColor grayColor];
        [snapshotContainer addSubview:snapshot];
        snapshotContainer.frame = CGRectOffset(snapshotContainer.frame, x==0.0 ? 0 : sectionWidth, 0);
        
        [snapshotContainer.layer setSublayerTransform:transform];

        [previousContainer addSubview:snapshotContainer];
        previousContainer = snapshotContainer;
        
        [self updateAnchorPointAndOffset:CGPointMake(0.0, 0.5) view:snapshotContainer];
        
        [snapshots addObject:snapshotContainer];
        
        snapshot.layer.borderWidth = 2.0;
        snapshot.layer.borderColor = [ UIColor blackColor].CGColor;
        
       // break;
    }
    
    ((UIView*)snapshots[0]).layer.transform = CATransform3DMakeRotation(M_PI_2 / 4.0, 0.0, 1.0, 0.0);
    ((UIView*)snapshots[1]).layer.transform = CATransform3DMakeRotation(-M_PI_2 / 2.0, 0.0, 1.0, 0.0);
    ((UIView*)snapshots[2]).layer.transform = CATransform3DMakeRotation(M_PI_2 / 4.0, 0.0, 1.0, 0.0);
    //((UIView*)snapshots[3]).layer.transform = CATransform3DMakeRotation(-M_PI_2 / 2.0, 0.0, 1.0, 0.0);
    //((UIView*)snapshots[4]).layer.transform = CATransform3DMakeRotation(M_PI_2 / 2.0, 0.0, 1.0, 0.0);
    //((UIView*)snapshots[5]).layer.transform = CATransform3DMakeRotation(-M_PI_2 / 2.0, 0.0, 1.0, 0.0);

    
   // containerView.layer.transform= CATransform3DMakeRotation(M_PI_2 / 2.0, 0.0, 1.0, 0.0);
    
   // [containerView sendSubviewToBack:fromView];
    [fromView removeFromSuperview];
    [toView removeFromSuperview];
    
    // animate
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        containerView.frame = CGRectOffset(containerView.frame, 0.01, 0.01);
    
        
        
        /*for(int i=0; i<snapshots.count;i++) {
            UIView *snapshot = snapshots[i];
            CGFloat maxAngle = M_PI_2 / 4.0;
            CGFloat angle = i == 0 ? maxAngle : (i%2==0 ? maxAngle * 2 : -maxAngle * 2);
            snapshot.layer.transform = CATransform3DMakeRotation(angle, 0.0, 1.0, 0.0);
        }*/
    } completion:^(BOOL finished) {
        for (UIView *view in snapshots) {
            [view removeFromSuperview];
        }
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
}

// updates the anchor point for the given view, offseting the frame to compensate for the resulting movement
- (void)updateAnchorPointAndOffset:(CGPoint)anchorPoint view:(UIView*)view {
    view.layer.anchorPoint = anchorPoint;
    float xOffset =  anchorPoint.x - 0.5;
    view.frame = CGRectOffset(view.frame, xOffset * view.frame.size.width, 0);
}


@end

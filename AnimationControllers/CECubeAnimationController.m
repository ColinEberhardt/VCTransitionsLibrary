//
//  CubeNavigationAnimator.m
//  MovieQuiz
//
//  Created by Andrés Brun on 27/10/13.
//  Copyright (c) 2013 Andrés Brun. All rights reserved.
//

#import "CECubeAnimationController.h"

#import "UIView+ABExtras.h"
#import "UIImageView+ABExtras.h"
#import "UINavigationController+ABExtras.h"

#define PERSPECTIVE -1.0 / 200.0
#define ROTATION_ANGLE M_PI_2

#define TIME_ANIMATION 0.7

@implementation CECubeAnimationController

- (id)init
{
    self = [super init];
    if (self) {
        self.cubeAnimationWay = CubeAnimationWayHorizontal;
        self.cubeAnimationType = CubeAnimationTypeNormal;
        
    }
    
    return self;
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return TIME_ANIMATION;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView
{

    //Calculate the direction
    int dir=0;
    switch (self.cubeAnimationType) {
        case CubeAnimationTypeNormal:
            dir=self.reverse?-1:1;
            break;
        case CubeAnimationTypeInverse:
            dir=self.reverse?1:-1;
            break;
            
        default:
            break;
    }

    //Crete the differents 3D animations
    CATransform3D viewFromTransform;
    CATransform3D viewToTransform;

    //We create a content view for do the translate animation
    UIView *generalContentView = [transitionContext containerView];
                                  
    switch (self.cubeAnimationWay) {
        case CubeAnimationWayHorizontal:
            viewFromTransform = CATransform3DMakeRotation(dir*ROTATION_ANGLE, 0.0, 1.0, 0.0);
            viewToTransform = CATransform3DMakeRotation(-dir*ROTATION_ANGLE, 0.0, 1.0, 0.0);
            [toView.layer setAnchorPoint:CGPointMake(dir==1?0:1, 0.5)];
            [fromView.layer setAnchorPoint:CGPointMake(dir==1?1:0, 0.5)];
            
            [generalContentView setTransform:CGAffineTransformMakeTranslation(dir*(generalContentView.frame.size.width)/2.0, 0)];
            break;
            
        case CubeAnimationWayVertical:
            viewFromTransform = CATransform3DMakeRotation(-dir*ROTATION_ANGLE, 1.0, 0.0, 0.0);
            viewToTransform = CATransform3DMakeRotation(dir*ROTATION_ANGLE, 1.0, 0.0, 0.0);
            [toView.layer setAnchorPoint:CGPointMake(0.5, dir==1?0:1)];
            [fromView.layer setAnchorPoint:CGPointMake(0.5, dir==1?1:0)];
            
            [generalContentView setTransform:CGAffineTransformMakeTranslation(0, dir*(generalContentView.frame.size.height)/2.0)];
            break;
            
        default:
            break;
    }

    viewFromTransform.m34 = PERSPECTIVE;
    viewToTransform.m34 = PERSPECTIVE;

    toView.layer.transform = viewToTransform;
    
    //Create the shadow
    UIView *fromShadow = [fromView addOpacityWithColor:[UIColor blackColor]];
    UIView *toShadow = [toView addOpacityWithColor:[UIColor blackColor]];
    [fromShadow setAlpha:0.0];
    [toShadow setAlpha:1.0];
    
    //Add the to- view
    [generalContentView addSubview:toView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        switch (self.cubeAnimationWay) {
            case CubeAnimationWayHorizontal:
                [generalContentView setTransform:CGAffineTransformMakeTranslation(-dir*generalContentView.frame.size.width/2.0, 0)];
                break;
                
            case CubeAnimationWayVertical:
                [generalContentView setTransform:CGAffineTransformMakeTranslation(0, -dir*(generalContentView.frame.size.height)/2.0)];
                break;
                
            default:
                break;
        }
        
        fromView.layer.transform = viewFromTransform;
        toView.layer.transform = CATransform3DIdentity;
        
        [fromShadow setAlpha:1.0];
        [toShadow setAlpha:0.0];
        
    }completion:^(BOOL finished) {
        
        //Set the final position of every elements transformed
        [generalContentView setTransform:CGAffineTransformIdentity];
        fromView.layer.transform = CATransform3DIdentity;
        toView.layer.transform = CATransform3DIdentity;
        [fromView.layer setAnchorPoint:CGPointMake(0.5f, 0.5f)];
        [toView.layer setAnchorPoint:CGPointMake(0.5f, 0.5f)];
        
        [fromShadow removeFromSuperview];
        [toShadow removeFromSuperview];
        
        if ([transitionContext transitionWasCancelled]) {
            [toView removeFromSuperview];
        } else {
            [fromView removeFromSuperview];
        }
        
        // inform the context of completion
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
    }];
}

@end

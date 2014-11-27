//
//  CEPinchInteractionController.m
//  TransitionsDemo
//
//  Created by Colin Eberhardt on 16/09/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "CEPinchInteractionController.h"
#import <objc/runtime.h>

const NSString *kCEPinchGestureKey = @"kCEPinchGestureKey";

@implementation CEPinchInteractionController{
    BOOL _shouldCompleteTransition;
    UIViewController *_viewController;
    CEInteractionOperation _operation;
    CGFloat _startScale;
}

- (void)wireToViewController:(UIViewController *)viewController forOperation:(CEInteractionOperation)operation{
    _operation = operation;
    _viewController = viewController;
    [self prepareGestureRecognizerInView:viewController.view];
}


- (void)prepareGestureRecognizerInView:(UIView*)view {
    
    UIPinchGestureRecognizer *gesture = objc_getAssociatedObject(view, (__bridge const void *)(kCEPinchGestureKey));
    
    if (gesture) {
        [view removeGestureRecognizer:gesture];
    }
    
    gesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [view addGestureRecognizer:gesture];
    
    objc_setAssociatedObject(view, (__bridge const void *)(kCEPinchGestureKey), gesture,OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

- (CGFloat)completionSpeed
{
    return 1 - self.percentComplete;
}

- (void)handleGesture:(UIPinchGestureRecognizer*)gestureRecognizer {
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            _startScale = gestureRecognizer.scale;
            
            // start an interactive transition!
            self.interactionInProgress = YES;
            
            // perform the required operation
            if (_operation == CEInteractionOperationPop) {
                [_viewController.navigationController popViewControllerAnimated:YES];
            } else {
                [_viewController dismissViewControllerAnimated:YES completion:nil];
            }
            break;
        case UIGestureRecognizerStateChanged: {
            // compute the current pinch fraction
            CGFloat fraction = 1.0 - gestureRecognizer.scale / _startScale;
            _shouldCompleteTransition = (fraction > 0.5);
            [self updateInteractiveTransition:fraction];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            self.interactionInProgress = NO;
            if (!_shouldCompleteTransition || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
                [self cancelInteractiveTransition];
            }
            else {
                [self finishInteractiveTransition];
            }
            break;
        default:
            break;
    }
}

@end

//
//  CEVerticalSwipeInteactionController.m
//  TransitionsDemo
//
//  Created by Colin Eberhardt on 22/09/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "CEVerticalSwipeInteractionController.h"
#import <objc/runtime.h>

const NSString *kCEVerticalSwipeGestureKey = @"kCEVerticalSwipeGestureKey";

@implementation CEVerticalSwipeInteractionController {
    BOOL _shouldCompleteTransition;
    UIViewController *_viewController;
    CEInteractionOperation _operation;
}


- (void)wireToViewController:(UIViewController *)viewController forOperation:(CEInteractionOperation)operation{
    
    if (operation == CEInteractionOperationTab) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"You cannot use a vertical swipe interaction with a tabbar controller - that would be silly!"
                                     userInfo:nil];
    }
    _operation = operation;
    _viewController = viewController;
    [self prepareGestureRecognizerInView:viewController.view];
}


- (void)prepareGestureRecognizerInView:(UIView*)view {
    UIPanGestureRecognizer *gesture = objc_getAssociatedObject(view, (__bridge const void *)(kCEVerticalSwipeGestureKey));
    
    if (gesture) {
        [view removeGestureRecognizer:gesture];
    }
 
    gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [view addGestureRecognizer:gesture];
    
    objc_setAssociatedObject(view, (__bridge const void *)(kCEVerticalSwipeGestureKey), gesture,OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

- (CGFloat)completionSpeed
{
    return 1 - self.percentComplete;
}

- (void)handleGesture:(UIPanGestureRecognizer*)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view.superview];
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            
            BOOL topToBottomSwipe = translation.y > 0;
            
            // perform the required navigation operation ...
            
            if (_operation == CEInteractionOperationPop) {
                // for pop operation, fire on top-to-bottom
                if (topToBottomSwipe) {
                    self.interactionInProgress = YES;
                    [_viewController.navigationController popViewControllerAnimated:YES];
                }
            } else {
                // for dismiss, fire regardless of the translation direction
                self.interactionInProgress = YES;
                [_viewController dismissViewControllerAnimated:YES completion:nil];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            if (self.interactionInProgress) {
                // compute the current position
                CGFloat fraction = fabs(translation.y / 200.0);
                fraction = fminf(fmaxf(fraction, 0.0), 1.0);
                _shouldCompleteTransition = (fraction > 0.5);
                
                // if an interactive transitions is 100% completed via the user interaction, for some reason
                // the animation completion block is not called, and hence the transition is not completed.
                // This glorious hack makes sure that this doesn't happen.
                // see: https://github.com/ColinEberhardt/VCTransitionsLibrary/issues/4
                if (fraction >= 1.0)
                    fraction = 0.99;
                
                [self updateInteractiveTransition:fraction];
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            if (self.interactionInProgress) {
                self.interactionInProgress = NO;
                if (!_shouldCompleteTransition || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
                    [self cancelInteractiveTransition];
                }
                else {
                    [self finishInteractiveTransition];
                }
            }
            break;
        default:
            break;
    }
}

@end

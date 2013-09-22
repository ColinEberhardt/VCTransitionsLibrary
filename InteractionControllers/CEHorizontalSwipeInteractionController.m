//
//  SwipeINteractionController.m
//  ILoveCatz
//
//  Created by Colin Eberhardt on 22/08/2013.
//  Copyright (c) 2013 com.razeware. All rights reserved.
//

#import "CEHorizontalSwipeInteractionController.h"

@implementation CEHorizontalSwipeInteractionController {
    BOOL _shouldCompleteTransition;
    UIViewController *_viewController;
    UIPanGestureRecognizer *_gesture;
    CEInteractionOperation _operation;
}

-(void)dealloc {
    [_gesture.view removeGestureRecognizer:_gesture];
}

- (void)wireToViewController:(UIViewController *)viewController forOperation:(CEInteractionOperation)operation{
    _operation = operation;
    _viewController = viewController;
    [self prepareGestureRecognizerInView:viewController.view];
}


- (void)prepareGestureRecognizerInView:(UIView*)view {
    _gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [view addGestureRecognizer:_gesture];
}

- (CGFloat)completionSpeed
{
    return 1 - self.percentComplete;
}

- (void)handleGesture:(UIPanGestureRecognizer*)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view.superview];
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            
            BOOL rightToLeftSwipe = translation.x < 0;
            
            // perform the required navigation operation ...
            
            if (_operation == CEInteractionOperationPop) {
                // for pop operation, fire on right-to-left
                if (rightToLeftSwipe) {
                    self.interactionInProgress = YES;
                    [_viewController.navigationController popViewControllerAnimated:YES];
                }
            } else if (_operation == CEInteractionOperationTab) {
                // for tab controllers, we need to determine which direction to transition
                if (rightToLeftSwipe) {
                    if (_viewController.tabBarController.selectedIndex < _viewController.tabBarController.viewControllers.count - 1) {
                        self.interactionInProgress = YES;
                        _viewController.tabBarController.selectedIndex++;
                    }
                    
                } else {
                    if (_viewController.tabBarController.selectedIndex > 0) {
                        self.interactionInProgress = YES;
                        _viewController.tabBarController.selectedIndex--;
                    }
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
                CGFloat fraction = fabsf(translation.x / 200.0);
                fraction = fminf(fmaxf(fraction, 0.0), 1.0);
                _shouldCompleteTransition = (fraction > 0.5);
                
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

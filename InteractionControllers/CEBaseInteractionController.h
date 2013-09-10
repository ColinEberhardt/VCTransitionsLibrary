//
//  CEBaseInteractionController.h
//  ViewControllerTransitions
//
//  Created by Colin Eberhardt on 10/09/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 A base class for interaction controllers that can be used with navigation controllers to perform pop operations, or with view controllers that have been presented modally to perform dismissal.

 */
@interface CEBaseInteractionController : UIPercentDrivenInteractiveTransition

/**
 Connects this interaction controller to the given view controller.
 @param viewController An accumulator function to be invoked on each element.
*/
- (void)wireToViewController:(UIViewController*)viewController;

/**
 This property indicates whether an interactive transition is in progress.
 */
@property (nonatomic, assign) BOOL interactionInProgress;

@end

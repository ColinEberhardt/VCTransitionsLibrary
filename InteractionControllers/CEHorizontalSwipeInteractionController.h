//
//  SwipeInteractionController.h
//  ILoveCatz
//
//  Created by Colin Eberhardt on 22/08/2013.
//  Copyright (c) 2013 com.razeware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CEBaseInteractionController.h"

/**
 A horizontal swipe interaction controller. When used with a navigation controller, a right-to-left, or left-to-right swipe
 will cause a 'pop' navigation. When used wth a tabbar controller, right-to-left and left-to-right cause navigation
 between neighbouring tabs.
 */
@interface CEHorizontalSwipeInteractionController : CEBaseInteractionController

/**
 Indicates whether a navigation controller 'pop' should occur on a right-to-left, or a left-to-right
 swipe. This property does not affect tab controller or modal interactions.
 */
@property (nonatomic) BOOL popOnRightToLeft;

@end

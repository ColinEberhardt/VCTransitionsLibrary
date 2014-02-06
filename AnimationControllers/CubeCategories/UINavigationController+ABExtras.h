//
//  UINavigationController+ABExtras.h
//  SquaresFlipNavigationExample
//
//  Created by Andrés Brun on 8/8/13.
//  Copyright (c) 2013 Andrés Brun. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CURRENT_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define IS_EARLIER_IOS7 ( CURRENT_VERSION < 7.0)

@interface UINavigationController (ABExtras)

/**
 Method that calculate the origin.y of the contain view
 */
- (float) calculateYPosition;

@end

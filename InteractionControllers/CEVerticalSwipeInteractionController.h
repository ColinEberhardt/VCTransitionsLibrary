//
//  CEVerticalSwipeInteactionController.h
//  TransitionsDemo
//
//  Created by Colin Eberhardt on 22/09/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "CEBaseInteractionController.h"

/**
 A horizontal swipe interaction controller. When used with a navigation controller, a top-to-bottom swipe
 will cause a 'pop' navigation. This interaction controller cannot be used with a tabbar controller. That would be silly.
 */
@interface CEVerticalSwipeInteractionController : CEBaseInteractionController

@end

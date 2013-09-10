//
//  CEFlipAnimationController.h
//  ViewControllerTransitions
//
//  Created by Colin Eberhardt on 08/09/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CEReversibleAnimationController.h"

typedef NS_ENUM(NSInteger, CEDirection) {
    CEDirectionHorizontal,
    CEDirectionVertical
};

@interface CETurnAnimationController : CEReversibleAnimationController

@property (nonatomic, assign) CEDirection flipDirection;

@end

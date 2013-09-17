//
//  CEAccordionAnimationController.h
//  TransitionsDemo
//
//  Created by Colin Eberhardt on 12/09/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "CEReversibleAnimationController.h"

/**
 Animates between the two view controllers using a paper-fold style transition. You can configure the number of folds via the `folds` property.
 */
@interface CEFoldAnimationController : CEReversibleAnimationController

@property (nonatomic) NSUInteger folds;

@end

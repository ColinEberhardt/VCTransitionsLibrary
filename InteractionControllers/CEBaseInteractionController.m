//
//  CEBaseInteractionController.m
//  ViewControllerTransitions
//
//  Created by Colin Eberhardt on 10/09/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "CEBaseInteractionController.h"

@implementation CEBaseInteractionController

- (void)wireToViewController:(UIViewController *)viewController forOperation:(CEInteractionOperation)operation {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
    
}

@end

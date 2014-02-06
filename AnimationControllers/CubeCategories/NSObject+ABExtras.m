//
//  NSObject+ABExtras.m
//  uSpeak
//
//  Created by uSpeak on 28/05/13.
//  Copyright (c) 2013 uSpeak Ltd. All rights reserved.
//

#import "NSObject+ABExtras.h"

@implementation NSObject (ABExtras)

- (void)performBlock:(void (^)(void))block
          afterDelay:(NSTimeInterval)delay
{
    block = [block copy];
    [self performSelector:@selector(fireBlockAfterDelay:)
               withObject:block
               afterDelay:delay];
}

- (void)fireBlockAfterDelay:(void (^)(void))block {
    block();
}

- (void)performAfterDelay:(float)delay thisBlock:(void (^)(BOOL finished))completion{
    
    [UIView animateWithDuration:delay
                     animations: ^{
                         
                     }completion:^(BOOL finished) {
                         
                         if (completion) {
                             completion(finished);
                         }
                     }];
}


- (void)performBlockInBackground:(NSObjectPerformBlock)performBlock completion:(NSObjectPerformBlock)completionBlock userObject:(id)userObject
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        performBlock(userObject);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionBlock) {
                completionBlock(userObject);
            }
        });
    });
}
@end

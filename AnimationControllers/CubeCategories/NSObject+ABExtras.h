//
//  NSObject+ABExtras.h
//  uSpeak
//
//  Created by uSpeak on 28/05/13.
//  Copyright (c) 2013 uSpeak Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^NSObjectPerformBlock)(id userObject);

@interface NSObject (ABExtras)
- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;
- (void)performAfterDelay:(float)delay thisBlock:(void (^)(BOOL finished))completion;
- (void)performBlockInBackground:(NSObjectPerformBlock)performBlock completion:(NSObjectPerformBlock)completionBlock userObject:(id)userObject;

@end

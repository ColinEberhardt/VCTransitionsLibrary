//
//  AppDelegate.h
//  TransitionsDemo
//
//  Created by Colin Eberhardt on 10/09/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import <UIKit/UIKit.h>

// a macro for easy access to the singleton app-delegate. Yes, I know some people
// consider the an anti-pattern, but this is just a simple test app, so let's
// not stress about it? ;-)
#define AppDelegateAccessor ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@class CEReversibleAnimationController, CEBaseInteractionController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CEReversibleAnimationController *settingsAnimationController;
@property (strong, nonatomic) CEReversibleAnimationController *navigationControllerAnimationController;
@property (strong, nonatomic) CEBaseInteractionController *navigationControllerInteractionController;
@property (strong, nonatomic) CEBaseInteractionController *settingsInteractionController;

@end

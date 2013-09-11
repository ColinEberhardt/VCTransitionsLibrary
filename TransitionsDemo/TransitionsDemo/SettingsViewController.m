//
//  SettingsViewController.m
//  TransitionsDemo
//
//  Created by Colin Eberhardt on 10/09/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "SettingsViewController.h"
#import "NavigationController.h"
#import "CEBaseInteractionController.h"
#import "AppDelegate.h"
#import "CEReversibleAnimationController.h"

@interface SettingsViewController () <UIViewControllerTransitioningDelegate>

@end

@implementation SettingsViewController {
    NSArray *_animationControllers;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _animationControllers = @[@"None", @"Flip", @"Turn"];
    }
    return self;
}

- (IBAction)doneButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)classToTransitionName:(NSObject *)instance {
    
    if (!instance)
        return @"None";
    
    NSString *animationClass = NSStringFromClass(instance.class);
    
    // convert 'CEFlipAnimationController' to 'Flip'
    NSMutableString *transitionName = [[NSMutableString alloc] initWithString:[animationClass substringWithRange:NSMakeRange(2, 1)]];
    for(int i = 3; i < animationClass.length; i++) {
        NSString *ch = [animationClass substringWithRange:NSMakeRange(i, 1)];
        if ([ch rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]].location != NSNotFound)
            break;
        [transitionName appendString:ch];
    }
    
    return transitionName;
}

- (id)transitionNameToInstance:(NSString *)transitionName {
    NSString *className = [NSString stringWithFormat:@"CE%@AnimationController", transitionName];
    return [[NSClassFromString(className) alloc] init];
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* transitionName = _animationControllers[indexPath.row];
   
    // update the animation controller used by the navigation controller
    if (indexPath.section == 0) {
        AppDelegateAccessor.navigationControllerAnimationController = [self transitionNameToInstance:transitionName];
    }
    
    // update the animation controller used by the settings view controller
    if (indexPath.section == 1) {
        AppDelegateAccessor.settingsAnimationController = [self transitionNameToInstance:transitionName];
    }
    
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    // get the cell text
    NSString *transitionName = cell.textLabel.text;
    
    // get the current transition for the navigation controller or settings
    CEReversibleAnimationController *currentTransition = indexPath.section == 0 ?
        AppDelegateAccessor.navigationControllerAnimationController :
        AppDelegateAccessor.settingsAnimationController;
    
    // if they match - render a tick
    NSString *transitionClassName = [self classToTransitionName:currentTransition];
    cell.accessoryType = [transitionName isEqualToString:transitionClassName] ?   UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}

#pragma mark - UITableViewDatasource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = _animationControllers[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _animationControllers.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return @"Navigation push / pop animation controller";

    return @"Settings present / dismiss aniation controller";
}

@end

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
    NSArray *_interactionControllers;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _animationControllers = @[@"None", @"Fold", @"Explode", @"Flip", @"Turn", @"Crossfade"];
        _interactionControllers = @[@"None", @"Swipe", @"Pinch"];
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
    if (indexPath.section < 2) {
        NSString* transitionName = _animationControllers[indexPath.row];
        NSString *className = [NSString stringWithFormat:@"CE%@AnimationController", transitionName];
        id transitionInstance = [[NSClassFromString(className) alloc] init];
       
        if (indexPath.section == 0) {
            AppDelegateAccessor.navigationControllerAnimationController = transitionInstance;
        }
        if (indexPath.section == 1) {
            AppDelegateAccessor.settingsAnimationController = transitionInstance;
        }
    } else {
        NSString* transitionName = _interactionControllers[indexPath.row];
        NSString *className = [NSString stringWithFormat:@"CE%@InteractionController", transitionName];
        id transitionInstance = [[NSClassFromString(className) alloc] init];
        
        if (indexPath.section == 2) {
            AppDelegateAccessor.navigationControllerInteractionController = transitionInstance;
        }
        if (indexPath.section == 3) {
            AppDelegateAccessor.settingsInteractionController = transitionInstance;
        }
    }
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    // get the cell text
    NSString *transitionName = cell.textLabel.text;
    NSObject *currentTransition;
    
    // get the current animation / interaction controller
    if (indexPath.section < 2) {
        currentTransition = indexPath.section == 0 ?
            AppDelegateAccessor.navigationControllerAnimationController :
            AppDelegateAccessor.settingsAnimationController;
    } else {
        currentTransition = indexPath.section == 2 ?
            AppDelegateAccessor.navigationControllerInteractionController :
            AppDelegateAccessor.settingsInteractionController;
    }
    
    // if they match - render a tick
    NSString *transitionClassName = [self classToTransitionName:currentTransition];
    cell.accessoryType = [transitionName isEqualToString:transitionClassName] ?   UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
   
}

#pragma mark - UITableViewDatasource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (indexPath.section < 2) {
        cell.textLabel.text = _animationControllers[indexPath.row];
    } else {
        cell.textLabel.text = _interactionControllers[indexPath.row];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section < 2 ? _animationControllers.count : _interactionControllers.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return @"Navigation push / pop animation controller";

    if (section == 1)
        return @"Settings present / dismiss animation controller";
    
    if (section == 2)
        return @"Navigation push / pop interaction controller";
    
    if (section == 3)
        return @"Settings present / dismiss interaction controller";

    return @"";
}

@end

//
//  SettingsViewController.m
//  TransitionsDemo
//
//  Created by Colin Eberhardt on 10/09/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "SettingsViewController.h"
#import "NavigationController.h"
#import "AppDelegate.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController {
    NSArray *_navigationControllerTransitions;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _navigationControllerTransitions = @[@"None", @"Flip", @"Turn"];    }
    return self;
}

- (IBAction)doneButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)getRootNavigationControllerTransition {
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NavigationController *navigationController = appDelegate.navigationController;
    return [self classToTransitionName:navigationController.animationController];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* transitionName = _navigationControllerTransitions[indexPath.row];
    
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NavigationController *navigationController = appDelegate.navigationController;
    
    navigationController.animationController = [self transitionNameToInstance:transitionName];
    
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *transitionName = cell.textLabel.text;
    
    NSString *navigationControllerTransition = [self getRootNavigationControllerTransition];
    cell.accessoryType = [transitionName isEqualToString:navigationControllerTransition] ?   UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = _navigationControllerTransitions[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _navigationControllerTransitions.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end

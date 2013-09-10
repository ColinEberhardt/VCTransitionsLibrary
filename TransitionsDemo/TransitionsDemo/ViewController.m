//
//  ViewController.m
//  ViewControllerTransitions
//
//  Created by Colin Eberhardt on 08/09/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

static int colorIndex = 0;

@implementation ViewController {
    NSArray* _colors;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    _colors = @[[UIColor redColor],
                [UIColor orangeColor],
                [UIColor yellowColor],
                [UIColor greenColor],
                [UIColor blueColor],
                [UIColor purpleColor]];
	
    self.view.backgroundColor = _colors[colorIndex];
    
    colorIndex  = (colorIndex + 1) % _colors.count;
}

@end

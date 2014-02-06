//
//  UIView+ABExtras.m
//  SquaresFlipNavigationExample
//
//  Created by Andrés Brun on 8/8/13.
//  Copyright (c) 2013 Andrés Brun. All rights reserved.
//

#import "UIView+ABExtras.h"
#import "UINavigationController+ABExtras.h"
//#import "UIImage+ImageEffects.h"

@implementation UIView (ABExtras)

- (CAGradientLayer *)addLinearGradientWithColor:(UIColor *)theColor transparentToOpaque:(BOOL)transparentToOpaque
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    //the gradient layer must be positioned at the origin of the view
    CGRect gradientFrame = self.frame;
    gradientFrame.origin.x = 0;
    gradientFrame.origin.y = 0;
    gradient.frame = gradientFrame;
    
    //build the colors array for the gradient
    NSArray *colors = [NSArray arrayWithObjects:
                       (id)[theColor CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.9f] CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.6f] CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.4f] CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.3f] CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.1f] CGColor],
                       (id)[[UIColor clearColor] CGColor],
                       nil];
    
    //reverse the color array if needed
    if(transparentToOpaque) {
        colors = [[colors reverseObjectEnumerator] allObjects];
    }
    
    //apply the colors and the gradient to the view
    gradient.colors = colors;
    
    [self.layer insertSublayer:gradient atIndex:[self.layer.sublayers count]];
    
    return gradient;
}

- (UIView *)addOpacityWithColor:(UIColor *)theColor
{
    UIView *shadowView = [[UIView alloc] initWithFrame:self.bounds];
    
    [shadowView setBackgroundColor:[theColor colorWithAlphaComponent:0.8]];
    
    [self addSubview:shadowView];
    
    return shadowView;
}

- (UIImageView *) imageInNavController: (UINavigationController *) navController
{
    [self.layer setContentsScale:[[UIScreen mainScreen] scale]];
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 1.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext(), kCGInterpolationHigh);
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *currentView = [[UIImageView alloc] initWithImage: img];
    
    //Fix the position to handle status bar and navigation bar
    float yPosition = [navController calculateYPosition];
    [currentView setFrame:CGRectMake(0, yPosition, currentView.frame.size.width, currentView.frame.size.height)];
    
    return currentView;
}

- (UIView *) createSnapshotViewForInView: (BOOL) inView
{
    UIView *currentView = [self snapshotViewAfterScreenUpdates:inView];
    
    return currentView;
}

- (void) addMotionSlideEffectWithRange: (float) range
{
    UIInterpolatingMotionEffect *xAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    UIInterpolatingMotionEffect *yAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    
    xAxis.minimumRelativeValue = @(-range);
    xAxis.maximumRelativeValue = @(range);
    
    yAxis.minimumRelativeValue = @(-range);
    yAxis.maximumRelativeValue = @(range);
    
    UIMotionEffectGroup *group = [[UIMotionEffectGroup alloc] init];
    group.motionEffects=@[xAxis, yAxis];
    [self addMotionEffect:group];
}

//- (UIImage *) captureBlur
//{
//    //Get a UIImage from the UIView
//    NSLog(@"blur capture");
//    UIGraphicsBeginImageContext(self.bounds.size);
//    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return [viewImage applyLightEffect];
//}

@end

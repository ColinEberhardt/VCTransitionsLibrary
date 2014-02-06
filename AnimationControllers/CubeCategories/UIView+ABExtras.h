//
//  UIView+ABExtras.h
//  SquaresFlipNavigationExample
//
//  Created by Andrés Brun on 8/8/13.
//  Copyright (c) 2013 Andrés Brun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIView (ABExtras)

/**
 Method that adds a gradient sublayer inthat view
 */
- (CAGradientLayer *)addLinearGradientWithColor:(UIColor *)theColor transparentToOpaque:(BOOL)transparentToOpaque;
/**
 Methot that capture a image from that view
 */
- (UIImageView *) imageInNavController: (UINavigationController *) navController;
/**
 Method that adds a view with color in that view
 */
- (UIView *)addOpacityWithColor:(UIColor *)theColor;

- (UIView *) createSnapshotViewForInView: (BOOL) inView;

- (void) addMotionSlideEffectWithRange: (float) range;

//- (UIImage *) captureBlur;

@end

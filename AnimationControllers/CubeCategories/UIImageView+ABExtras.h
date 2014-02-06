//
//  UIImageView+ABExtras.h
//  SquaresFlipNavigationExample
//
//  Created by Andrés Brun on 8/8/13.
//  Copyright (c) 2013 Andrés Brun. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TAG_IMAGE_VIEW 999

@interface UIImageView (ABExtras)

/**
 Methot that create a crop image from that imageView
 */
- (UIImageView *) createCrop: (CGRect) crop;
/**
 Method that crates a view that contains that ImageView
 */
- (UIView *)createView;

@end

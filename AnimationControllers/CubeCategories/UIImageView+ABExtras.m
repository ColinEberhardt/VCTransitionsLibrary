//
//  UIImageView+ABExtras.m
//  SquaresFlipNavigationExample
//
//  Created by Andrés Brun on 8/8/13.
//  Copyright (c) 2013 Andrés Brun. All rights reserved.
//

#import "UIImageView+ABExtras.h"
#import <QuartzCore/QuartzCore.h>
#import "UINavigationController+ABExtras.h"

@implementation UIImageView (ABExtras)

- (UIImageView *) createCrop: (CGRect) crop
{
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.image.CGImage, crop);
    UIImageView *imageViewCropped = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:imageRef]];
    [imageViewCropped setFrame:crop];
    
    [imageViewCropped setFrame:CGRectMake(imageViewCropped.frame.origin.x,
                                          imageViewCropped.frame.origin.y+self.frame.origin.y,
                                          imageViewCropped.frame.size.width,
                                          imageViewCropped.frame.size.height)];
    CGImageRelease(imageRef);
    return imageViewCropped;
}

- (UIView *)createView
{
    UIView *newView = [[UIView alloc] initWithFrame:self.frame];
    [self setTag:TAG_IMAGE_VIEW];
    [self setFrame:self.bounds];
    [newView addSubview:self];
    
    return newView;
}

@end

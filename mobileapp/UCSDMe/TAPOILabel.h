//
//  TAPOILabel.h
//  UCSDMe
//
//  Created by Sean Hamilton on 1/26/14.
//  Copyright (c) 2014 Sean Hamilton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAFirstPersonView.h"

@interface TAPOILabel : UIView <TAFirstPersonViewLabel>

- (void)setTextColor:(UIColor *)textColor;
- (UIColor *)textColor;
- (void)setText:(NSString *)text;
- (NSString *)text;
- (void)setImage:(UIImage *)image;
- (UIImage *)image;
- (void)setFont:(UIFont *)font;
- (UIFont *)font;
- (void)setDistance:(double)dist;
- (double)distance;

@end

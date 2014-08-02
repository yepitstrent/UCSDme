//
//  TAPOILabel.m
//  UCSDMe
//
//  Created by Sean Hamilton on 1/26/14.
//  Copyright (c) 2014 Sean Hamilton. All rights reserved.
//

#import "TAPOILabel.h"
#import "UIColor+TAColor.h"

@interface TAPOILabel ()

@property (nonatomic, strong) UIImageView* poiImg;
@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) UILabel* distLabel;

@end

@implementation TAPOILabel

-(void)setup
{
  _poiImg = [[UIImageView alloc] init];
  
  _nameLabel = [[UILabel alloc] init];
  _distLabel = [[UILabel alloc] init];
  [self addSubview:_poiImg];
  [self addSubview:_nameLabel];
  [self addSubview:_distLabel];
  
  [_nameLabel setTextAlignment:NSTextAlignmentLeft];
  [_distLabel setTextAlignment:NSTextAlignmentLeft];
  [_distLabel setFont:[[_nameLabel font] fontWithSize:[[_nameLabel font] pointSize]*0.6]];
  
  CALayer *layer = self.layer;
  layer.shadowOffset = CGSizeMake(1, 1);
  layer.shadowColor = [[UIColor blackColor] CGColor];
  layer.shadowRadius = 4.0f;
  layer.shadowOpacity = 0.80f;
  layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
  [layer setCornerRadius:5];
}

- (id)init
{
  self = [super init];
  if (self)
  {
    [self setup];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
      [self setup];
      [self setBounds:frame];
    }
    return self;
}

// used to init from NIB or Storyboard
- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self)
  {
    [self setup];
  }
  return self;
}

- (void)setTextColor:(UIColor *)textColor
{
  [_nameLabel setTextColor:textColor];
  [_distLabel setTextColor:textColor];
}

-(UIColor *)textColor
{
  return [_nameLabel textColor];
}

- (void)setText:(NSString *)text
{
  [_nameLabel setText:text];
}

-(NSString *)text
{
  return [_nameLabel text];
}

- (void)setImage:(UIImage *)image;
{
  [_poiImg setImage:image];
}

- (UIImage *)image
{
  return [_poiImg image];
}

- (void)setFont:(UIFont *)font
{
  [_nameLabel setFont:font];
}

- (UIFont *)font
{
  return [_nameLabel font];
}

- (void)setBounds:(CGRect)bounds
{
  [super setBounds:bounds];
  
  CALayer *layer = self.layer;
  layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
  layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
  
  [_poiImg setFrame:CGRectMake(5, 5, bounds.size.height-10, bounds.size.height-10)];
  [_nameLabel setFrame:CGRectMake(bounds.size.height, 0 , bounds.size.width - bounds.size.height, bounds.size.height*0.6)];
  [_distLabel setFrame:CGRectMake(bounds.size.height, bounds.size.height*0.6, bounds.size.width - bounds.size.height, bounds.size.height*0.4)];
}

- (void)setDistance:(double)dist
{
  if (dist > 1000)
    [_distLabel setText:[NSString stringWithFormat:@"%.2fkm",dist/1000]];
  else if (dist < 1)
    [_distLabel setText:[NSString stringWithFormat:@"%.0fcm",dist*100]];
  else
    [_distLabel setText:[NSString stringWithFormat:@"%.0fm",dist]];
}

- (double)distance
{
  return [[_distLabel text] doubleValue];
}

@end

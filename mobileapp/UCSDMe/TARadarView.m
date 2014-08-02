//
//  TARadarView.m
//  UCSDMe
//
//  Created by Sean Hamilton on 3/8/14.
//  Copyright (c) 2014 Sean Hamilton. All rights reserved.
//

#import "TARadarView.h"
#import "UIColor+TAColor.h"

@interface TARadarView ()

@property (nonatomic) float radius;

@end

@implementation TARadarView

- (id)initWithFrame:(CGRect)frame radius:(float)radius
{
    self = [super initWithFrame:frame];
    if (self)
    {
      _radius = radius;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGRect rectangle = self.bounds;
  CGContextAddEllipseInRect(context, rectangle);
  CGContextSetFillColorWithColor(context, [UIColor tritonBlue].CGColor);
  CGContextFillEllipseInRect (context, rectangle);
  NSString* text = @"N";
  NSDictionary *attr = [NSDictionary dictionaryWithObjects:@[[UIColor tritonYellow]]
                                                  forKeys:@[NSForegroundColorAttributeName]];
  
  CGPoint point = CGPointMake(rectangle.size.width/2 - [text sizeWithAttributes:attr].width/2, 0);
  [text drawAtPoint:point withAttributes:attr];
}
@end

//
//  UIColor+TAColor.m
//  UCSDMe
//
//  Created by Brad Collins on 1/26/14.
//  Copyright (c) 2014 Sean Hamilton. All rights reserved.
//

#import "UIColor+TAColor.h"

@implementation UIColor (TAColor)

+(UIColor *) tritonYellow
{
  return [UIColor colorWithRed:254.0/255.0 green:190.0/255.0 blue:14.0/255.0 alpha:255.0/255.0];
}

+(UIColor *) tritonYellowHighLight
{
  return [UIColor colorWithRed:255.0/255.0 green:212.0/255.0 blue:123.0/255.0 alpha:255.0/255.0];
}

+(UIColor *) tritonYellowMid
{
  return [UIColor colorWithRed:254.0/255.0 green:190.0/255.0 blue:14.0/255.0 alpha:180/255.0];
}

+(UIColor *) tritonBlue
{
  return [UIColor colorWithRed:0/255.0 green:42.0/255.0 blue:96.0/255.0 alpha:255.0/255.0];
}

+(UIColor *) tritonBlueHighlight
{
  return [UIColor colorWithRed:76.0/255.0 green:81.0/255.0 blue:120.0/255.0 alpha:255.0/255.0];
}

@end

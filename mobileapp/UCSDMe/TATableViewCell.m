//
//  TATableViewCell.m
//  UCSDMe
//
//  Created by Sean Hamilton on 1/27/14.
//  Copyright (c) 2014 Sean Hamilton. All rights reserved.
//

#import "TATableViewCell.h"

@interface TATableViewCell ()

@end

@implementation TATableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
      [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self)
  {
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
  }
  return self;
}

@end

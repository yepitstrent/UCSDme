//
//  TATableViewCell.h
//  UCSDMe
//
//  Created by Sean Hamilton on 1/27/14.
//  Copyright (c) 2014 Sean Hamilton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TATableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *enSwitch;

@end

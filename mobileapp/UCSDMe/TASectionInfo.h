#import <Foundation/Foundation.h>

@class TASectionHeaderView;

@interface TASectionInfo : NSObject 

@property (getter = isOpen) BOOL open;
@property NSString *title;
@property TASectionHeaderView *headerView;
@property (nonatomic, getter = isOn) BOOL on;

@end
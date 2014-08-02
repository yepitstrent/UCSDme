#import <Foundation/Foundation.h>

@protocol TASectionHeaderViewDelegate;

@interface TASectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIButton *disclosureButton;
@property (nonatomic, weak) IBOutlet UISwitch *enableSwitch;

@property (nonatomic, weak) IBOutlet id <TASectionHeaderViewDelegate> delegate;

@property (nonatomic) NSInteger section;

- (void)toggleOpenWithUserAction:(BOOL)userAction;

@end

#pragma mark -

/*
 Protocol to be adopted by the section header's delegate; the section header tells its delegate when the section should be opened and closed.
 */
@protocol TASectionHeaderViewDelegate <NSObject>

@optional
- (void)sectionHeaderView:(TASectionHeaderView *)sectionHeaderView sectionOpened:(NSInteger)section;
- (void)sectionHeaderView:(TASectionHeaderView *)sectionHeaderView sectionClosed:(NSInteger)section;

@end


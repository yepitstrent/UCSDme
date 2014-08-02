#import "TASectionHeaderView.h"
#import "UIColor+TAColor.h"

@implementation TASectionHeaderView

- (void)awakeFromNib
{
  // set the selected image for the disclosure button
  [self.disclosureButton setImage:[UIImage imageNamed:@"carat-open.png"] forState:UIControlStateSelected];
  
  // set up the tap gesture recognizer
  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(toggleOpen:)];
  [[[self subviews] objectAtIndex:0] setOpaque:YES];
  [[[self subviews] objectAtIndex:0] setBackgroundColor:[UIColor whiteColor]];

  self.titleLabel.textColor = [UIColor tritonBlue];

  [self addGestureRecognizer:tapGesture];
}

- (IBAction)toggleOpen:(id)sender
{
  [self toggleOpenWithUserAction:YES];
}

- (void)toggleOpenWithUserAction:(BOOL)userAction
{
  // toggle the disclosure button state
  self.disclosureButton.selected = !self.disclosureButton.selected;
  
  // if this was a user action, send the delegate the appropriate message
  if (userAction)
  {
    if (self.disclosureButton.selected)
    {
      if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionOpened:)])
      {
        [self.delegate sectionHeaderView:self sectionOpened:self.section];
      }
    }
    else
    {
      if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionClosed:)])
      {
        [self.delegate sectionHeaderView:self sectionClosed:self.section];
      }
    }
  }
}

@end

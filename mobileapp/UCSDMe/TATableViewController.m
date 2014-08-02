//
//  TAPOIViewController.m
//  UCSDMe
//
//  Created by Sean Hamilton on 1/22/14.
//  Copyright (c) 2014 Sean Hamilton. All rights reserved.
//

#import "TATableViewController.h"
#import "TAPlaceOfInterest.h"
#import "TAAppDelegate.h"
#import "UIColor+TAColor.h"
#import "TAPOILabel.h"
#import "TATableViewCell.h"
#import "TASectionInfo.h"
#import "TASectionHeaderView.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

#define DEFAULT_ROW_HEIGHT 88
#define HEADER_HEIGHT 48

@interface TATableViewController ()

@property (nonatomic) IBOutlet UITabBarItem *locationTableViewButton;
@property (nonatomic) NSMutableArray *sectionInfoArray;
@property (nonatomic) NSInteger openSectionIndex;
@property (nonatomic, weak) TAPOIList *poiList;
@property (nonatomic) NSArray *searchResults;

@end

static NSString *CellIdentifier = @"TableViewCellIdentifier";
static NSString *SectionHeaderViewIdentifier = @"SectionHeaderViewIdentifier";

@implementation TATableViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  _poiList = [(TAAppDelegate *)[[UIApplication sharedApplication] delegate] poiList];
  
  // Set up default values.
  [self.tableView setBackgroundColor:[UIColor tritonBlueHighlight]];
  
	/*
   The section info array is thrown away in viewWillUnload, so it's OK to set 
   the default values here. If you keep the section information etc. then set 
   the default values in the designated initializer.
   */
  self.openSectionIndex = NSNotFound;
}

-(void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  // May return nil if a tracker has not already been initialized with a
  // property ID.
  id tracker = [[GAI sharedInstance] defaultTracker];
  
  // This screen name value will remain set on the tracker and sent with
  // hits until it is set to a new value or to nil.
  [tracker set:kGAIScreenName
         value:@"Table View"];
  
  [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)viewWillAppear:(BOOL)animated
{  
	[super viewWillAppear:animated];
  
  /*
   Check whether the section info array has been created, and if so whether the
   section count still matches the current section count. In general, you need
   to keep the section info synchronized with the rows and section. If you
   support editing in the table view, you need to appropriately update the
   section info during editing operations.
   */
	if ((self.sectionInfoArray == nil) ||
      ([self.sectionInfoArray count] != [self numberOfSectionsInTableView:self.tableView]))
  {
		NSMutableArray *infoArray = [[NSMutableArray alloc] init];
    
		NSArray *categories = [_poiList categories];
    for (NSString *category in categories)
    {
			TASectionInfo *sectionInfo = [[TASectionInfo alloc] init];
			sectionInfo.title = category;
			sectionInfo.open = NO;
      
      [infoArray addObject:sectionInfo];
		}
    
		self.sectionInfoArray = infoArray;
	}
}

- (BOOL)prefersStatusBarHidden
{
  return YES;
}

#pragma mark - TableView Data Source and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  if (tableView == self.tableView)
  {
    return [_poiList numberOfCategories];
  }
  else //searchController.searchResultsTableView
  {
    return 1;
  }
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
  if (tableView == self.tableView)
  {
    TASectionInfo *sectionInfo = (self.sectionInfoArray)[section];
    NSInteger numPOISInCategory = [_poiList numberOfPOIsInCategory:sectionInfo.title];
    
    return sectionInfo.open ? numPOISInCategory : 0;
  }
  else //searchController.searchResultsTableView
  {
    return [_searchResults count];
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  TATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

  if (cell == nil)
  {
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"TATableViewCell" bundle:nil];
    [tableView registerNib:sectionHeaderNib forCellReuseIdentifier:CellIdentifier];
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  }
  
  if (tableView == self.tableView)
  {
    NSString *category = [(self.sectionInfoArray)[indexPath.section] title];
    NSString *name = [_poiList poisByCategory:category][indexPath.row];
    [cell.nameLabel setText:name];
  }
  else //searchController.searchResultsTableView
  {
    [cell.nameLabel setText:[_searchResults objectAtIndex:indexPath.row]];
  }
  
  [cell.enSwitch addTarget:self
                    action:@selector(poiSwitchChanged:)
          forControlEvents:UIControlEventValueChanged];
  
  if ([_poiList selectedPOIsContains:cell.nameLabel.text])
  {
    [cell.nameLabel setTextColor:[UIColor tritonBlue]];
    [cell.enSwitch setOn:YES];
  }
  else
  {
    [cell.nameLabel setTextColor:[UIColor tritonBlue]];
    [cell.enSwitch setOn:NO];
  }
  
  [cell.enSwitch setThumbTintColor:[UIColor tritonBlue]];
  [cell.enSwitch setOnTintColor:[UIColor tritonYellow]];
  [cell.enSwitch setOpaque:YES];
  [cell.enSwitch setBackgroundColor:[UIColor whiteColor]];
  
  return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  if (tableView == self.searchDisplayController.searchResultsTableView)
  {
    return nil;
  }
  
  TASectionHeaderView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
  
  if (sectionHeaderView == nil)
  {
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"TASectionHeaderView" bundle:nil];
    [tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
    sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
    
  }
  
  TASectionInfo *sectionInfo = (self.sectionInfoArray)[section];
  sectionInfo.headerView = sectionHeaderView;
  
  sectionHeaderView.titleLabel.text = sectionInfo.title;
  sectionHeaderView.delegate = self;
  sectionHeaderView.section = section;
  [sectionHeaderView.enableSwitch addTarget:self
                                     action:@selector(categorySwitchChanged:)
                           forControlEvents:UIControlEventValueChanged];
  [sectionHeaderView.enableSwitch setThumbTintColor:[UIColor tritonBlue]];
  [sectionHeaderView.enableSwitch setOnTintColor:[UIColor tritonYellow]];
  
  if ([[self.sectionInfoArray objectAtIndex:section] isOn]) {
    [sectionHeaderView.enableSwitch setOn:YES animated:NO];
  }
  else
  {
    [sectionHeaderView.enableSwitch setOn:NO animated:NO];
  }
  
  sectionHeaderView.disclosureButton.selected = sectionInfo.isOpen;
  
  return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  if (tableView == self.tableView)
  {
    return 50;
  }
  else
  {
    return 1;
  }
}


#pragma mark - SectionHeaderViewDelegate
- (void)sectionHeaderView:(TASectionHeaderView *)sectionHeaderView sectionOpened:(NSInteger)sectionOpened
{
	TASectionInfo *sectionInfo = (self.sectionInfoArray)[sectionOpened];
  
	sectionInfo.open = YES;
  
  /*
   Create an array containing the index paths of the rows to insert: These correspond to the rows for each quotation in the current section.
   */
  NSInteger countOfRowsToInsert = [[_poiList poisByCategory:sectionInfo.title] count];
  NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
  for (NSInteger i = 0; i < countOfRowsToInsert; i++)
  {
    [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
  }
  
  /*
   Create an array containing the index paths of the rows to delete: These correspond to the rows for each quotation in the previously-open section, if there was one.
   */
  NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
  
  NSInteger previousOpenSectionIndex = self.openSectionIndex;
  if (previousOpenSectionIndex != NSNotFound)
  {
		TASectionInfo *previousOpenSection = (self.sectionInfoArray)[previousOpenSectionIndex];
    previousOpenSection.open = NO;
    [previousOpenSection.headerView toggleOpenWithUserAction:NO];
    NSInteger countOfRowsToDelete = [[_poiList poisByCategory:previousOpenSection.title] count];
    for (NSInteger i = 0; i < countOfRowsToDelete; i++)
    {
      [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
    }
  }
  
  // style the animation so that there's a smooth flow in either direction
  UITableViewRowAnimation insertAnimation;
  UITableViewRowAnimation deleteAnimation;
  if (previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex)
  {
    insertAnimation = UITableViewRowAnimationTop;
    deleteAnimation = UITableViewRowAnimationBottom;
  }
  else
  {
    insertAnimation = UITableViewRowAnimationBottom;
    deleteAnimation = UITableViewRowAnimationTop;
  }
  
  // apply the updates
  [self.tableView beginUpdates];
  [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
  [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
  [self.tableView endUpdates];
  
  self.openSectionIndex = sectionOpened;
}

- (void)sectionHeaderView:(TASectionHeaderView *)sectionHeaderView sectionClosed:(NSInteger)sectionClosed
{
  /*
   Create an array of the index paths of the rows in the section that was closed, then delete those rows from the table view.
   */
	TASectionInfo *sectionInfo = (self.sectionInfoArray)[sectionClosed];
  
  sectionInfo.open = NO;
  NSInteger countOfRowsToDelete = [self.tableView numberOfRowsInSection:sectionClosed];
  
  if (countOfRowsToDelete > 0) {
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToDelete; i++)
    {
      [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
    }
    [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
  }
  self.openSectionIndex = NSNotFound;
}

#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
  // start with all pois
  NSMutableArray *pois = [[_poiList allPois] mutableCopy];
  
  // strip out all the leading and trailing spaces
  NSString *strippedStr = [searchString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  
  // break up the search terms (separated by spaces)
  NSArray *searchItems = nil;
  if (strippedStr.length > 0)
  {
    searchItems = [strippedStr componentsSeparatedByString:@" "];
  }
  
  // build all the "AND" expressions for each value in the searchString
  //
  NSMutableArray *andMatchPredicates = [NSMutableArray array];

  for (NSDictionary *item in searchItems)
  {
    // name field matching
    NSString *expr = [NSString stringWithFormat:@"SELF contains[c] '%@'", item];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:expr];
    // add this OR predicate
    [andMatchPredicates addObject:predicate];
  }
  
  // form complete Predicate
  NSPredicate *finalCompoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:andMatchPredicates];
  
  // assign filtered array to searchResults
  _searchResults = [pois filteredArrayUsingPredicate:finalCompoundPredicate];
  
  // Return YES to cause the search result table view to be reloaded.
  return YES;
}

#pragma mark - IBAction Callbacks

- (void)updateCategoriesOnSwitchToOn
{
  // for each category
  for (NSString *key in [_poiList categories])
  {
    NSArray *poisInCategory = [_poiList poisByCategory:key];
    TASectionInfo *categorySectionInfo;
    // find sectionInfo for this category
    for (TASectionInfo *sectionInfo in [self sectionInfoArray])
    {
      if ([[sectionInfo title] isEqualToString:key])
      {
        categorySectionInfo = sectionInfo;
        break;
      }
    }
    // for each poi in category
    int numberOfPoiSwitchesTurnedOn = 0;
    for (NSString *poiName in poisInCategory)
    {
      // check of poi is turned on
      for (TAPlaceOfInterest *poi in [_poiList selectedPOIs])
      {
        // if poi is on, increment numberOfPoiSwitchesTurnedOn
        if ([poiName isEqualToString:[[((TATableViewCell *) [poi view]) nameLabel] text]])
        {
          numberOfPoiSwitchesTurnedOn++;
        }
      }
    }
    if (numberOfPoiSwitchesTurnedOn == [poisInCategory count] && numberOfPoiSwitchesTurnedOn != 0)
    {
      [categorySectionInfo setOn:YES];
    }
    else
    {
      [categorySectionInfo setOn:NO];
    }
  }
}

- (void)updateCategoriesOnSwitchToOff:(NSString *)poiName
{
  for (NSString *key in [_poiList categories])
  {
    NSArray *poisInCategory = [_poiList poisByCategory:key];
    // for each poi in category
    for (NSString *poi in poisInCategory)
    {
      // if poi name is equal to this cell's name
      if ([poi isEqualToString:poiName]) {
        // find sectionInfo for this category in sectionInfoArray
        for (TASectionInfo *sectionInfo in [self sectionInfoArray])
        {
          // if found turn off that category's switch using it's [sectionInfo setOn:] method
          if ([[sectionInfo title] isEqualToString:key])
          {
            [sectionInfo setOn:NO];
          }
        }
      }
    }
  }
}

- (IBAction)poiSwitchChanged:(UISwitch *)sender
{
  TATableViewCell* cell = (TATableViewCell*)[[[sender superview] superview] superview];
  
  if (sender.on)
  {
    [_poiList addSelectedPOI:[_poiList poiByName:cell.nameLabel.text]];
    [self updateCategoriesOnSwitchToOn];
  }
  else
  {
    [_poiList removeSelectedPOIByName:cell.nameLabel.text];
    NSString *poiName = [[cell nameLabel] text];
    [self updateCategoriesOnSwitchToOff:poiName];
  }
  [[self tableView] reloadData];
}

- (IBAction)categorySwitchChanged:(UISwitch *)sender
{
  TASectionHeaderView *sectionHeaderView = (TASectionHeaderView*)[[sender superview] superview];
  
  if (sender.on)
  {
    NSArray *pois = [_poiList poisByCategory:sectionHeaderView.titleLabel.text];
    [[self.sectionInfoArray objectAtIndex:[sectionHeaderView section]] setOn:YES];

    for (NSString *poi in pois)
    {
      [_poiList addSelectedPOI:[_poiList poiByName:poi]];
    }
    [self updateCategoriesOnSwitchToOn];
  }
  else
  {
    NSArray *pois = [_poiList poisByCategory:sectionHeaderView.titleLabel.text];
    [[self.sectionInfoArray objectAtIndex:[sectionHeaderView section]] setOn:NO];
    
    for (NSString *poi in pois)
    {
      [_poiList removeSelectedPOIByName:poi];
      [self updateCategoriesOnSwitchToOff:poi];
    }
  }
  [self.tableView reloadData];
}

@end

//
//  FITPrettyIconsController.m
//  tableturner
//
//  Created by Anowar on 2/8/15.
//  Copyright (c) 2015 FIGInfotech. All rights reserved.
//

#import "FITPrettyIconsController.h"
#import "Icon.h"
#import "IconSet.h"
#import "FITIconCell.h"
#import "FITDetailViewController.h"
#import "FITEditControllerTableViewController.h"

@interface FITPrettyIconsController () <UISearchDisplayDelegate>

@property (strong, nonatomic) NSMutableArray *iconSets;
@property (strong, nonatomic) NSMutableArray *filteredIcons;

@end

@implementation FITPrettyIconsController

#pragma mark View Delegate

- (void)viewDidLoad {
  [super viewDidLoad];
  
//  //Create Sections for each letter
//  NSInteger sectionTitlesCount = [[[UILocalizedIndexedCollation currentCollation] sectionTitles] count];
//  NSMutableArray *allSections = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
//  for (NSInteger i=0; i<sectionTitlesCount; i++) {
//    [allSections addObject:[NSMutableArray array]];
//  }
//  
//  //Loop through the icons and add to appropriate sections
//  NSMutableArray *iconSets = [IconSet iconSets];
//  for (IconSet* iconSet in iconSets) {
//    for (Icon *icon in iconSet.icons) {
//      NSInteger sectionNumber = [[UILocalizedIndexedCollation  currentCollation] sectionForObject:iconSet collationStringSelector:@selector(title)];
//      [allSections[sectionNumber] addObject:icon];
//    }
//  }
//  
//  
////  self.iconSets = [IconSet iconSets];
//  
//  self.iconSets = [NSMutableArray array];
//  for (NSInteger i=0; i<sectionTitlesCount; i++) {
//    NSArray *curIcons = allSections[i];
//    [self.iconSets addObject:[curIcons sortedArrayUsingSelector:@selector(compare:)]];
//  }
  
  
  self.iconSets = [IconSet iconSets];
  
  self.navigationItem.rightBarButtonItem = self.editButtonItem;
  self.tableView.allowsSelectionDuringEditing = YES;
  
  UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
  [self.tableView addGestureRecognizer:longPress];
  
  self.filteredIcons = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark UITableViewDataSource

//Base Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (tableView == self.searchDisplayController.searchResultsTableView) {
    return self.filteredIcons.count;
  } else {
    int adjustment = [self isEditing] ? 1:0;
    IconSet *set = self.iconSets[section];
    return set.icons.count + adjustment;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (tableView == self.searchDisplayController.searchResultsTableView) {
    FITIconCell *iconCell = (FITIconCell *)[self.tableView dequeueReusableCellWithIdentifier:@"IconCell" forIndexPath:indexPath];
    Icon *icon = self.filteredIcons[indexPath.row];
    iconCell.titleLabel.text = icon.title;
    iconCell.subtitleLabel.text = icon.subtitle;
    iconCell.iconImageView.image = icon.image;
    if (icon.rating == RatingTypeAwesome) {
      iconCell.favoriteImageView.image = [UIImage imageNamed:@"star_sel.png"];
    } else {
      iconCell.favoriteImageView.image = [UIImage imageNamed:@"star_uns.png"];
    }
    return iconCell;
  } else {
    //Create a cell
    UITableViewCell *cell = nil;
    //Configure the cell
    IconSet *set = self.iconSets[indexPath.section];
    if (indexPath.row >= set.icons.count && [self isEditing]) {
      cell = [tableView dequeueReusableCellWithIdentifier:@"NewRowCell" forIndexPath:indexPath];
      cell.textLabel.text = @"Add Icon";
      cell.detailTextLabel.text = nil;
      cell.imageView.image = nil;
    } else {
      cell = [tableView dequeueReusableCellWithIdentifier:@"IconCell" forIndexPath:indexPath];
      FITIconCell *iconCell = (FITIconCell *) cell;
      Icon *icon = set.icons[indexPath.row];
      iconCell.titleLabel.text = icon.title;
      iconCell.subtitleLabel.text = icon.subtitle;
      iconCell.iconImageView.image = icon.image;
      if (icon.rating == RatingTypeAwesome) {
        iconCell.favoriteImageView.image = [UIImage imageNamed:@"star_sel.png"];
      } else {
        iconCell.favoriteImageView.image = [UIImage imageNamed:@"star_uns.png"];
      }
    }
    return cell;
  }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (tableView == self.searchDisplayController.searchResultsTableView) {
    return 80;
  } else {
    IconSet *set = self.iconSets[indexPath.section];
    if (indexPath.row >= set.icons.count && [self isEditing]) {
      return 40;
    } else {
      return 80;
    }
  }
}

//Sections Added
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  if (tableView == self.searchDisplayController.searchResultsTableView) {
    return 1;
  } else {
    return self.iconSets.count;
  }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  if (tableView == self.searchDisplayController.searchResultsTableView) {
    return nil;
  } else {
    IconSet *set = self.iconSets[section];
    return set.name;
  }
}


//Adding Delete, Edit
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (tableView != self.searchDisplayController.searchResultsTableView) {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
      IconSet *set = self.iconSets[indexPath.section];
      [set.icons removeObjectAtIndex:indexPath.row];
      //    [self.tableView reloadData];
      //have a better perspective of deletion
      [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
      IconSet *set = self.iconSets[indexPath.section];
      Icon *newIcon = [[Icon alloc] initWithTitle:@"New Icon" subtitle:@"" imageName:nil];
      [set.icons addObject:newIcon];
      //have a better perspective of insertion
      [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
  }
  
}

//Editing
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
  [super setEditing:editing animated:animated];
  if (editing) {
    [self.tableView beginUpdates];
    for (int i=0; i<self.iconSets.count; i++) {
      IconSet *set = self.iconSets[i];
      [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:set.icons.count inSection:i]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [self.tableView endUpdates];
  } else {
    [self.tableView beginUpdates];
    for (int i=0; i<self.iconSets.count; i++) {
      IconSet *set = self.iconSets[i];
      [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:set.icons.count inSection:i]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [self.tableView endUpdates];
  }
}

// add a proper icon
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
  IconSet *set = self.iconSets[indexPath.section];
  if (indexPath.row >= set.icons.count) {
    return UITableViewCellEditingStyleInsert;
  } else {
    return UITableViewCellEditingStyleDelete;
  }
}


//Inserting a row
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  IconSet *set = self.iconSets[indexPath.section];
  if (indexPath.row < set.icons.count && [self isEditing]) {
    return nil;
  }
  return indexPath;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
  IconSet *set = self.iconSets[indexPath.section];
  if (indexPath.row >= set.icons.count && [self isEditing]) {
    [self tableView:tableView commitEditingStyle:UITableViewCellEditingStyleInsert forRowAtIndexPath:indexPath];
  }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
  if ([identifier isEqualToString:@"GoToDetail"] && [self isEditing]) {
    return NO;
  }
  return YES;
}

// Move Rows
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
  IconSet *set = self.iconSets[indexPath.section];
  if (indexPath.row >= set.icons.count && [self isEditing]) {
    return NO;
  }
  return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
  IconSet *sourceSet = self.iconSets[sourceIndexPath.section];
  IconSet *destSet = self.iconSets[destinationIndexPath.section];
  
  Icon *iconToMove = sourceSet.icons[sourceIndexPath.row];
  
  if (sourceSet == destSet) {
    [destSet.icons exchangeObjectAtIndex:destinationIndexPath.row withObjectAtIndex:sourceIndexPath.row];
  } else {
    [destSet.icons insertObject:iconToMove atIndex:destinationIndexPath.row];
    [sourceSet.icons removeObjectAtIndex:sourceIndexPath.row];
  }
  
}

//check if proposed move is allowed
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
  IconSet *set = self.iconSets[proposedDestinationIndexPath.section];
  if (proposedDestinationIndexPath.row >= set.icons.count && [self isEditing]) {
    return [NSIndexPath indexPathForRow:set.icons.count-1 inSection:proposedDestinationIndexPath.section];
  } else {
    return proposedDestinationIndexPath;
  }
}

//Long press
- (IBAction) longPressGestureRecognized:(UILongPressGestureRecognizer *)longPress
{
  CGPoint location = [longPress locationInView:self.tableView];
  NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
  UIGestureRecognizerState state = longPress.state;
  static UIView *snapshot = nil;
  static NSIndexPath *sourceIndexPath = nil;
  
  switch (state) {
    case UIGestureRecognizerStateBegan:{
      if (indexPath) {
        sourceIndexPath = indexPath;
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        snapshot = [self customSnapshotFromView:cell];
        __block CGPoint center = cell.center;
        snapshot.center = cell.center;
        snapshot.alpha = 0;
        [self.tableView addSubview:snapshot];
        
        [UIView animateWithDuration:0.25 animations:^{
          center.y = location.y;
          snapshot.center = center;
          snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
          snapshot.alpha= 0.98;
          
          cell.backgroundColor = [UIColor whiteColor];
          cell.textLabel.alpha = 0;
          cell.detailTextLabel.alpha = 0;
          cell.imageView.alpha = 0;
        }];
      }
      }
      break;
      
    case UIGestureRecognizerStateChanged: {
      CGPoint center = snapshot.center;
      center.y = location.y;
      snapshot.center = center;
      
      IconSet *destSet = [self.iconSets objectAtIndex:indexPath.section];
      if (indexPath && ![indexPath isEqual:sourceIndexPath] && indexPath.row < destSet.icons.count) {
        IconSet *sourceSet = self.iconSets[sourceIndexPath.section];
        IconSet *destSet = self.iconSets[indexPath.section];
        
        Icon *iconToMove = sourceSet.icons[sourceIndexPath.row];
        
        if (sourceSet == destSet) {
          [destSet.icons exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
        } else {
          [destSet.icons insertObject:iconToMove atIndex:indexPath.row];
          [sourceSet.icons removeObjectAtIndex:sourceIndexPath.row];
        }
        
        [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
        
        sourceIndexPath = indexPath;

      }
      
      }
      break;
      
    default: {
      UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
      [UIView animateWithDuration:0.25 animations:^{
        snapshot.center = cell.center;
        snapshot.transform = CGAffineTransformMakeScale(1.0, 1.0);
        snapshot.alpha= 0.0;
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.alpha = 1;
        cell.detailTextLabel.alpha = 1;
        cell.imageView.alpha = 1;
      } completion:^(BOOL finished) {
        [snapshot removeFromSuperview];
        snapshot = nil;
      }];
      sourceIndexPath = nil;
    }
      break;
  }
  
}

- (UIView *)customSnapshotFromView:(UIView *)inputView {
  UIView *snapshot = [inputView snapshotViewAfterScreenUpdates:YES];
  snapshot.layer.masksToBounds = NO;
  snapshot.layer.cornerRadius = 0.0;
  snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0);
  snapshot.layer.shadowRadius = 5.0;
  snapshot.layer.shadowOpacity = 0.4;
  return snapshot;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"GoToDetail"]) {
    FITDetailViewController *vc = (FITDetailViewController *) segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    IconSet *set = self.iconSets[indexPath.section];
    Icon *icon = set.icons[indexPath.row];
    vc.icon = icon;
  } else if ([segue.identifier isEqualToString:@"GoToEdit"]) {
    FITEditControllerTableViewController *vc = (FITEditControllerTableViewController *) segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    IconSet *set = self.iconSets[indexPath.section];
    Icon *icon = set.icons[indexPath.row];
    vc.icon = icon;
  }
}

#pragma mark - Filtering

- (void)filterIcons:(NSArray *)icons forSearchText:(NSString *)searchText {
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.title contains[c] %@", searchText];
  [self.filteredIcons addObjectsFromArray:[icons filteredArrayUsingPredicate:predicate]];
}

- (void) filterContentForSearchText:(NSString *)searchText scopeIndex:(NSInteger)scopeIndex {
  [self.filteredIcons removeAllObjects];
  
  if (scopeIndex==0 || scopeIndex==1) {
    IconSet *winterSet = (IconSet *)self.iconSets[0];
    [self filterIcons:winterSet.icons forSearchText:searchText];
  }
  
  if (scopeIndex==0 || scopeIndex==2) {
    IconSet *summerSet = (IconSet *)self.iconSets[1];
    [self filterIcons:summerSet.icons forSearchText:searchText];
  }
}

#pragma mark - Search Display Delegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
  [self filterContentForSearchText:searchString scopeIndex:self.searchDisplayController.searchBar.selectedScopeButtonIndex];
  return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
  [self filterContentForSearchText:self.searchDisplayController.searchBar.text scopeIndex:searchOption];
  return YES;
}




@end











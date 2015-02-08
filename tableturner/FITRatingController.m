//
//  FITRatingController.m
//  tableturner
//
//  Created by Anowar on 2/9/15.
//  Copyright (c) 2015 FIGInfotech. All rights reserved.
//

#import "FITRatingController.h"
#import "Icon.h"

@interface FITRatingController ()

@end

@implementation FITRatingController

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self refresh];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  self.icon.rating = indexPath.row;
  [self refresh];
}

- (void) refresh {
  for (int i=0; i<NumRatingTypes; i++) {
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    cell.accessoryType = (int) self.icon.rating == i ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
  }
}



@end

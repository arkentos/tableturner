//
//  FITEditControllerTableViewController.m
//  tableturner
//
//  Created by Anowar on 2/9/15.
//  Copyright (c) 2015 FIGInfotech. All rights reserved.
//

#import "FITEditControllerTableViewController.h"
#import "FITDetailViewController.h"
#import "FITRatingController.h"
#import "Icon.h"

@interface FITEditControllerTableViewController () <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *subtitleTextField;
@property (weak, nonatomic) IBOutlet UILabel *ratingTextField;

@end

@implementation FITEditControllerTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.iconImageView.image = self.icon.image;
    self.titleTextField.text = self.icon.title;
    self.subtitleTextField.text = self.icon.subtitle;
    self.ratingTextField.text = [Icon ratingToString:self.icon.rating];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  self.icon.image = self.iconImageView.image;
  self.icon.title = self.titleTextField.text;
  self.icon.subtitle = self.subtitleTextField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if ((indexPath.row==0 && indexPath.section==0) || (indexPath.row==2 && indexPath.section==1)) {
    return indexPath;
  }
  return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  if (indexPath.row==0 && indexPath.section==0) {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = NO;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
  }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  UIImage *image = info[UIImagePickerControllerOriginalImage];
  self.iconImageView.image = image;
  self.icon.image = image;
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"GoToDetail"]) {
    FITDetailViewController *vc = (FITDetailViewController *) segue.destinationViewController;
    vc.icon = self.icon;
  } else if ([segue.identifier isEqualToString:@"GoToRating"]) {
    FITRatingController *vc = (FITRatingController *) segue.destinationViewController;
    vc.icon = self.icon;
  }
}


@end

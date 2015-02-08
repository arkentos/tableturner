//
//  FITDetailViewController.m
//  tableturner
//
//  Created by Anowar on 2/8/15.
//  Copyright (c) 2015 FIGInfotech. All rights reserved.
//

#import "FITDetailViewController.h"
#import "Icon.h"

@interface FITDetailViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation FITDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.imageView.image = self.icon.image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

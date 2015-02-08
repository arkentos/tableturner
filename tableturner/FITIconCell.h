//
//  FITIconCell.h
//  tableturner
//
//  Created by Anowar on 2/8/15.
//  Copyright (c) 2015 FIGInfotech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FITIconCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteImageView;

@end

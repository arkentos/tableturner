//
//  Icon.h
//  WinterIcons
//
//  Created by Main Account on 2/10/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RatingType) {
  RatingTypeUnrated = 0,
  RatingTypeUgly,
  RatingTypeOK,
  RatingTypeNice,
  RatingTypeAwesome,
  NumRatingTypes
};

@interface Icon : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *subtitle;
@property (strong, nonatomic) UIImage *image;
@property (assign) RatingType rating;

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle imageName:(NSString *)imageName;
+ (NSString *)ratingToString:(RatingType)rating;

@end

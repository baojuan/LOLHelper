//
//  HeroPlayTableViewCell.h
//  LOL
//
//  Created by baojuan on 14-9-22.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeroPlayTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *skillLabel;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *clothesImageViews;
@property (weak, nonatomic) IBOutlet UIView *runeView;
@property (weak, nonatomic) IBOutlet UIView *talentView;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *talentArray;
- (void)insertIntoData:(NSDictionary *)dict;

@end

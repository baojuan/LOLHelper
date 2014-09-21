//
//  AttributeTableViewCell.h
//  LOL
//
//  Created by baojuan on 14-9-21.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttributeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *hpLabel;
@property (weak, nonatomic) IBOutlet UILabel *mpLabel;
@property (weak, nonatomic) IBOutlet UILabel *atkLabel;
@property (weak, nonatomic) IBOutlet UILabel *atkSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *defLabel;
@property (weak, nonatomic) IBOutlet UILabel *srLabel;
@property (weak, nonatomic) IBOutlet UILabel *rehpLabel;
@property (weak, nonatomic) IBOutlet UILabel *rempLabel;
@property (weak, nonatomic) IBOutlet UILabel *rofLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UILabel *mpTitleLabel;
- (void)insertIntoData:(NSDictionary *)dict;

@end

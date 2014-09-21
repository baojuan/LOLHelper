//
//  HeroFirstTableViewCell.h
//  LOL
//
//  Created by baojuan on 14-9-21.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorNumberView.h"
@interface HeroFirstTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet ColorNumberView *wlView;
@property (weak, nonatomic) IBOutlet ColorNumberView *mfView;
@property (weak, nonatomic) IBOutlet ColorNumberView *fyView;
@property (weak, nonatomic) IBOutlet UILabel *wlLabel;
@property (weak, nonatomic) IBOutlet UILabel *mfLabel;
@property (weak, nonatomic) IBOutlet UILabel *fyLabel;
@property (weak, nonatomic) IBOutlet ColorNumberView *xsView;
@property (weak, nonatomic) IBOutlet ColorNumberView *tzView;
@property (weak, nonatomic) IBOutlet ColorNumberView *czView;
@property (weak, nonatomic) IBOutlet UILabel *xsLabel;
@property (weak, nonatomic) IBOutlet UILabel *tzLabel;
@property (weak, nonatomic) IBOutlet UILabel *czLabel;
@property (weak, nonatomic) IBOutlet ColorNumberView *gankView;
@property (weak, nonatomic) IBOutlet UILabel *gankLabel;
@property (weak, nonatomic) IBOutlet UILabel *qyLabel;
@property (weak, nonatomic) IBOutlet ColorNumberView *qyView;


- (void)insertIntoData:(NSDictionary *)dict;



@end

//
//  HeroSecondTableViewCell.h
//  LOL
//
//  Created by baojuan on 14-9-21.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TechButton.h"

@protocol HeroSecondTableViewCellDelegate <NSObject>

- (void)techButtonClick:(NSInteger)number;

@end

@interface HeroSecondTableViewCell : UITableViewCell
@property (weak, nonatomic) id <HeroSecondTableViewCellDelegate> delegate;
@property (strong, nonatomic) IBOutletCollection(TechButton) NSArray *techButton;
- (IBAction)techButtonClick:(UIButton *)sender;
- (void)insertIntoData:(NSDictionary *)dict selected:(NSInteger)number;
@property (weak, nonatomic) IBOutlet UILabel *techTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *wasteLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *contentBackgroundView;

- (CGFloat)cellHeight;

@end

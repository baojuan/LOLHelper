//
//  HeroSecondTableViewCell.m
//  LOL
//
//  Created by baojuan on 14-9-21.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "HeroSecondTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation HeroSecondTableViewCell
{
    NSArray *array;
    NSString *string;
    NSInteger selectedNumber;
}

- (void)awakeFromNib {
    // Initialization code
    selectedNumber = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)insertIntoData:(NSDictionary *)dict selected:(NSInteger)number
{
    array = dict[@"skill"];
    for (int i = 0; i < [array count]; i ++) {
        NSDictionary *dict = array[i];
        TechButton *button = self.techButton[i];
        [button.techImageView setImageWithURL:[NSURL URLWithString:dict[@"icon"]] placeholderImage:[UIImage imageNamed:@"hero_icon_loading"]];
    }
    for (UIButton *button in self.techButton) {
        button.selected = NO;
    }
    UIButton *button = self.techButton[number];
    button.selected = YES;
    
    [self setTextForLabelsWithNumber:number];
}


- (IBAction)techButtonClick:(UIButton *)sender
{
    for (UIButton *button in self.techButton) {
        button.selected = NO;
    }
    sender.selected = YES;
    
    NSInteger number = sender.tag - 100 - 1;
//    selectedNumber = number;
//    [self setTextForLabelsWithNumber:number];
    [self.delegate techButtonClick:number];
//    [self layoutSubviews];
}

- (void)setTextForLabelsWithNumber:(NSInteger)number
{
    NSDictionary *dict = array[number];
    self.techTitleLabel.text = dict[@"name"];
    
    self.detailLabel.text = dict[@"text"];
    string = dict[@"text"];
    if ([dict[@"mp"] length] > 0) {
        self.wasteLabel.text = [NSString stringWithFormat:@"技能消耗：%@",dict[@"mp"]];
    }
    else {
        self.wasteLabel.text = @"";
    }
    
    if ([dict[@"cd"] length] > 0) {
        self.timeLabel.text = [NSString stringWithFormat:@"冷却时间：%@",dict[@"cd"]];
    }
    else {
        self.timeLabel.text = @"";
    }

}


- (void)layoutSubviews
{
    CGRect detailFrame = self.detailLabel.frame;
//    CGSize size = [string sizeWithFont:self.detailLabel.font constrainedToSize:CGSizeMake(284, 5000)];
    
    
    CGFloat heightString = 0;
    NSArray *array = [string componentsSeparatedByString:@"\n"];
    for (NSString *ss in array) {
        CGSize size = [ss sizeWithFont:self.detailLabel.font constrainedToSize:CGSizeMake(284, 500)];
        heightString += size.height;
    }

    
    detailFrame.size.height = heightString;
    self.detailLabel.frame = detailFrame;
    self.detailLabel.text = string;
    
    CGRect wasteFrame = self.wasteLabel.frame;
    wasteFrame.origin.y = self.detailLabel.frame.origin.y + self.detailLabel.frame.size.height + 5;
    if ([self.wasteLabel.text length] > 0) {
        wasteFrame.size.height = 21;
    }
    else {
        wasteFrame.size.height = 0;
    }
    self.wasteLabel.frame = wasteFrame;
    
    CGRect timeFrame = self.timeLabel.frame;
    timeFrame.origin.y = self.wasteLabel.frame.origin.y + self.wasteLabel.frame.size.height;
    if ([self.timeLabel.text length] > 0) {
        timeFrame.size.height = 21;
    }
    else {
        timeFrame.size.height = 0;
    }

    self.timeLabel.frame = timeFrame;
    
    CGRect contentBackgroundFrame = self.contentBackgroundView.frame;
    contentBackgroundFrame.size.height = timeFrame.size.height + timeFrame.origin.y + 7;
    self.contentBackgroundView.frame = contentBackgroundFrame;
    
}

- (CGFloat)cellHeight
{
//    CGSize size = [string sizeWithFont:self.detailLabel.font constrainedToSize:CGSizeMake(284, 500)];
    
    CGFloat heightString = 0;
    NSArray *array = [string componentsSeparatedByString:@"\n"];
    
    
    for (NSString *ss in array) {
        CGSize size = [ss sizeWithFont:self.detailLabel.font constrainedToSize:CGSizeMake(284, 500)];
        heightString += size.height;
    }
    
    CGFloat height = 182 - 18 + heightString;
    if ([self.timeLabel.text length] == 0) {
        height -= 21;
    }
    if ([self.wasteLabel.text length] == 0) {
        height -= 21;
    }
    return height;
}

@end

//
//  HeroPlayTableViewCell.m
//  LOL
//
//  Created by baojuan on 14-9-22.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "HeroPlayTableViewCell.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"


@implementation HeroPlayTableViewCell
{
    AppDelegate *appdelegate;
}

- (void)awakeFromNib {
    // Initialization code
    appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.clipsToBounds = YES;
}

- (void)insertIntoData:(NSDictionary *)dict
{
    self.titleLabel.text = dict[@"name"];
    self.skillLabel.text = dict[@"skill"];
    NSString *equipString = dict[@"equip"];
    NSArray *clothesArray = [equipString componentsSeparatedByString:@","];
    for (int i = 0; i < MIN([self.clothesImageViews count], [clothesArray count]); i ++) {
        NSDictionary *dd = [appdelegate getDataItem:@"Item" ID:clothesArray[i]];
        UIImageView *image =  self.clothesImageViews[i];
        [image setImageWithURL:[NSURL URLWithString:dd[@"icon"]] placeholderImage:[UIImage imageNamed:@"hero_icon_loading"]];
    }
    NSString *runeString = dict[@"rune"];
    NSArray *runeArray = [equipString componentsSeparatedByString:@";"];

//    for (int i = 0; i < [runeArray count]; i ++) {
//        NSString *runeContent = runeArray[i];
//        NSArray *runeIdAndNumber = [runeContent componentsSeparatedByString:@"*"];
//        NSDictionary *dd = [appdelegate getDataItem:@"Rune" ID:runeIdAndNumber[0]];
//        NSString *number = runeIdAndNumber[1];
//        
//    }
    
    NSString *talentString = dict[@"talent"];
    NSArray *talentArray = [talentString componentsSeparatedByString:@","];
    for (int i = 0; i < MIN([talentArray count], [self.talentArray count]); i ++) {
        UILabel *label = self.talentArray[i];
        label.text = talentArray[i];
    }

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

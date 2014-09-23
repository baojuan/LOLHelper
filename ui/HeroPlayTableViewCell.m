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
    RuneLabel *runeLabelView;
}

- (void)awakeFromNib {
    // Initialization code
    appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.clipsToBounds = YES;
    runeLabelView = [[RuneLabel alloc] init];
    runeLabelView.frame = CGRectMake(65, 120, 239, 72);
    [self addSubview:runeLabelView];
}

- (void)insertIntoData:(NSDictionary *)dict
{
    self.titleLabel.text = dict[@"name"];
    self.skillLabel.text = dict[@"skill"];
    NSString *equipString = dict[@"item_3"];
    NSArray *clothesArray = [equipString componentsSeparatedByString:@","];
    for (int i = 0; i < MIN([self.clothesImageViews count], [clothesArray count]); i ++) {
        NSDictionary *dd = [appdelegate getDataItem:@"Item" ID:clothesArray[i]];
        UIImageView *image =  self.clothesImageViews[i];
        [image setImageWithURL:[NSURL URLWithString:dd[@"icon"]] placeholderImage:[UIImage imageNamed:@"hero_icon_loading"]];
    }
    NSString *runeString = [NSString stringWithFormat:@"%@;%@;%@;%@",dict[@"rune_1"],dict[@"rune_2"],dict[@"rune_3"],dict[@"rune_4"]];
    runeLabelView.runeString = runeString;
    
    CGRect talentFrame = self.talentView.frame;
    talentFrame.origin.y = runeLabelView.frame.size.height + runeLabelView.frame.origin.y - 5;
    self.talentView.frame = talentFrame;
    
    CGRect backgroundFrame = self.contentBackgroundView.frame;
    backgroundFrame.size.height = self.talentView.frame.size.height + self.talentView.frame.origin.y;
    self.contentBackgroundView.frame = backgroundFrame;
    
    
    for (int i = 0; i < [self.talentArray count]; i ++) {
        UILabel *label = self.talentArray[i];
        NSString *textContent;
        switch (i) {
            case 0:
                textContent = dict[@"telent_atk"];
                break;
            case 1:
                textContent = dict[@"telent_def"];
                break;
            case 2:
                textContent = dict[@"telent_normal"];
                break;
            default:
                break;
        }
        label.text = textContent;
    }

    
}
- (CGFloat)cellHeight
{
    return self.contentBackgroundView.frame.origin.y + self.contentBackgroundView.frame.size.height + 3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

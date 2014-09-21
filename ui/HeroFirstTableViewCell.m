//
//  HeroFirstTableViewCell.m
//  LOL
//
//  Created by baojuan on 14-9-21.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "HeroFirstTableViewCell.h"
#import "Default.h"
@implementation HeroFirstTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)insertIntoData:(NSDictionary *)dict
{
    self.locationLabel.text = [dict objectForKey:@"location"];
    self.coinLabel.text = [dict objectForKey:@"coin"];
    self.moneyLabel.text = [dict objectForKey:@"ticket"];
    NSArray *array = [dict objectForKey:@"evaluation"];
    
    
    
    self.wlView.color = [Default colorWithR:223 withG:71 withB:6];

    self.mfView.color = [Default colorWithR:0 withG:160 withB:233];
    self.fyView.color = [Default colorWithR:0 withG:153 withB:68];
    self.xsView.color = [Default colorWithR:174 withG:93 withB:161];

    self.tzView.color = [Default colorWithR:243 withG:152 withB:0];
    self.qyView.color = [Default colorWithR:102 withG:204 withB:0];
    self.gankView.color = [Default colorWithR:6 withG:215 withB:253];
    self.czView.color = [Default colorWithR:242 withG:197 withB:0];
    
    
    
    self.wlView.number = [array[0] floatValue] / 10.0;
    self.mfView.number = [array[1] floatValue] / 10.0;
    self.fyView.number = [array[2] floatValue] / 10.0;
    self.xsView.number = [array[3] floatValue] / 10.0;
    self.tzView.number = [array[4] floatValue] / 10.0;
    self.qyView.number = [array[5] floatValue] / 10.0;
    self.gankView.number = [array[6] floatValue] / 10.0;
    self.czView.number = [array[7] floatValue] / 10.0;
    
    self.wlLabel.text = [self evaluationForStyle:@"wl" number:[array[0] floatValue]];
    self.mfLabel.text = [self evaluationForStyle:@"mf" number:[array[1] floatValue]];
    self.fyLabel.text = [self evaluationForStyle:@"fy" number:[array[2] floatValue]];
    self.xsLabel.text = [self evaluationForStyle:@"xs" number:[array[3] floatValue]];
    self.tzLabel.text = [self evaluationForStyle:@"tz" number:[array[4] floatValue]];
    self.qyLabel.text = [self evaluationForStyle:@"qy" number:[array[5] floatValue]];
    self.gankLabel.text = [self evaluationForStyle:@"gank" number:[array[6] floatValue]];
    self.czLabel.text = [self evaluationForStyle:@"cz" number:[array[7] floatValue]];
}

- (NSString *)evaluationForStyle:(NSString *)style number:(NSInteger)number
{
    if ([style isEqualToString:@"wl"]) {
        if (number < 3) {
            return @"极弱";
        }
        else if (number < 5) {
            return @"很弱";
        }
        else if (number < 7) {
            return @"一般";
        }
        else if (number < 9) {
            return @"较强";
        }
        else if (number < 10) {
            return @"很强";
        }
        else {
            return @"极强";
        }
    }
    else if ([style isEqualToString:@"mf"]) {
        if (number < 3) {
            return @"极弱";
        }
        else if (number < 5) {
            return @"很弱";
        }
        else if (number < 7) {
            return @"一般";
        }
        else if (number < 9) {
            return @"较强";
        }
        else if (number < 10) {
            return @"很强";
        }
        else {
            return @"极强";
        }
    }
    else if ([style isEqualToString:@"fy"]) {
        if (number < 3) {
            return @"极脆";
        }
        else if (number < 5) {
            return @"很脆";
        }
        else if (number < 7) {
            return @"一般";
        }
        else if (number < 9) {
            return @"较肉";
        }
        else if (number < 10) {
            return @"很肉";
        }
        else {
            return @"极肉";
        }
    }
    else if ([style isEqualToString:@"xs"]) {
        if (number < 3) {
            return @"极弱";
        }
        else if (number < 5) {
            return @"很弱";
        }
        else if (number < 7) {
            return @"一般";
        }
        else if (number < 9) {
            return @"较强";
        }
        else if (number < 10) {
            return @"很强";
        }
        else {
            return @"线霸";
        }
    }
    else if ([style isEqualToString:@"tz"]) {
        if (number < 3) {
            return @"极弱";
        }
        else if (number < 5) {
            return @"很弱";
        }
        else if (number < 7) {
            return @"一般";
        }
        else if (number < 9) {
            return @"较强";
        }
        else if (number < 10) {
            return @"很强";
        }
        else {
            return @"极强";
        }
    }
    else if ([style isEqualToString:@"qy"]) {
        if (number < 3) {
            return @"极慢";
        }
        else if (number < 5) {
            return @"很慢";
        }
        else if (number < 7) {
            return @"一般";
        }
        else if (number < 9) {
            return @"较快";
        }
        else if (number < 10) {
            return @"很快";
        }
        else {
            return @"极快";
        }
    }
    else if ([style isEqualToString:@"gank"]) {
        if (number < 3) {
            return @"极差";
        }
        else if (number < 5) {
            return @"很差";
        }
        else if (number < 7) {
            return @"一般";
        }
        else if (number < 9) {
            return @"较强";
        }
        else if (number < 10) {
            return @"很强";
        }
        else {
            return @"极强";
        }
    }
    else if ([style isEqualToString:@"cz"]) {
        if (number < 3) {
            return @"极易";
        }
        else if (number < 5) {
            return @"简单";
        }
        else if (number < 7) {
            return @"普通";
        }
        else if (number < 9) {
            return @"较难";
        }
        else if (number < 10) {
            return @"很难";
        }
        else {
            return @"极难";
        }
    }

    return @"";
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

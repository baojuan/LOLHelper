//
//  AttributeTableViewCell.m
//  LOL
//
//  Created by baojuan on 14-9-21.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "AttributeTableViewCell.h"

@implementation AttributeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)insertIntoData:(NSDictionary *)dict
{
    NSDictionary *dd = dict[@"atrributy"];
    self.hpLabel.text = [NSString stringWithFormat:@"%@ (+%@/级)",dd[@"hp"],dd[@"hp_grow"]];
    self.mpLabel.text = [NSString stringWithFormat:@"%@ (+%@/级)",dd[@"mp"],dd[@"mp_grow"]];
    self.mpTitleLabel.text = dd[@"mp_name"];
    self.atkLabel.text = [NSString stringWithFormat:@"%@ (+%@/级)",dd[@"atk"],dd[@"atk_grow"]];
    self.atkSpeedLabel.text = [NSString stringWithFormat:@"%@ (+%@/级)",dd[@"atk_speed"],dd[@"atk_speed_grow"]];
    self.defLabel.text = [NSString stringWithFormat:@"%@ (+%@/级)",dd[@"def"],dd[@"def_grow"]];
    self.srLabel.text = [NSString stringWithFormat:@"%@ (+%@/级)",dd[@"sr"],dd[@"sr_grow"]];
    self.rehpLabel.text = [NSString stringWithFormat:@"%@ (+%@/级)",dd[@"re_hp"],dd[@"re_hp_grow"]];
    self.rempLabel.text = [NSString stringWithFormat:@"%@ (+%@/级)",dd[@"re_mp"],dd[@"re_mp_grow"]];
    self.rofLabel.text = [NSString stringWithFormat:@"%@",dd[@"rof"]];
    self.speedLabel.text = [NSString stringWithFormat:@"%@",dd[@"speed"]];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

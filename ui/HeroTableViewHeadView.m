//
//  HeroTableViewHeadView.m
//  LOL
//
//  Created by baojuan on 14-9-22.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "HeroTableViewHeadView.h"
#import "UIImageView+WebCache.h"
@implementation HeroTableViewHeadView

- (void)awakeFromNib
{
    self.titleLabel.frame = CGRectMake(10, 96, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
    self.nameLabel.frame = CGRectMake(10, 100 + self.titleLabel.frame.size.height, self.nameLabel.frame.size.width, self.nameLabel.frame.size.height);
}

- (void)insertIntoData:(NSDictionary *)dict
{
    self.titleLabel.text = dict[@"title"];
    self.nameLabel.text = dict[@"name"];
    [self.imageView setImageWithURL:[NSURL URLWithString:dict[@"banner"]] placeholderImage:[UIImage imageNamed:@"banner_loading"]];
}


@end

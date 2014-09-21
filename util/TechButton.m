//
//  TechButton.m
//  LOL
//
//  Created by baojuan on 14-9-21.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "TechButton.h"

@implementation TechButton
{
    UIImageView *backgroundImageView;
}

- (void)awakeFromNib
{
//    self.frame = CGRectMake(0, 0, 60, 60);
    self.backgroundColor = [UIColor clearColor];
    backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    backgroundImageView.hidden = YES;
    backgroundImageView.userInteractionEnabled = NO;
    backgroundImageView.image = [UIImage imageNamed:@"techBackground"];
    [self addSubview:backgroundImageView];
    
    self.techImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 7, 60 - 14, 60 - 14)];
    self.techImageView.userInteractionEnabled = NO;
    [self addSubview:self.techImageView];

    
}

- (void)setSelected:(BOOL)selected
{
    if (selected) {
        backgroundImageView.hidden = NO;
    }
    else {
        backgroundImageView.hidden = YES;
    }
}


@end

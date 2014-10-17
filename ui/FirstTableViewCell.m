//
//  FirstTableViewCell.m
//  LOL
//
//  Created by baojuan on 14-9-21.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "FirstTableViewCell.h"
#import "Default.h"
@implementation FirstTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)haveImage:(BOOL)haveImage
{
    if (haveImage) {
        CGRect smallImageViewRect = self.smallImageView.frame;
        smallImageViewRect.origin.x = 10;
        smallImageViewRect.size.width = 70;
        self.smallImageView.frame = smallImageViewRect;
        
        
    }
    else {
        CGRect smallImageViewRect = self.smallImageView.frame;
        smallImageViewRect.origin.x = 10;
        smallImageViewRect.size.width = 0;
        self.smallImageView.frame = smallImageViewRect;
    }
    
    CGRect titleRect = self.titleLabel.frame;
    titleRect.origin.x = self.smallImageView.frame.size.width + self.smallImageView.frame.origin.x + 10;
    titleRect.size.width = [Default screenSize].width - titleRect.origin.x - 10;
    self.titleLabel.frame = titleRect;
    CGRect excerptFrame = self.excerptLabel.frame;
    excerptFrame.origin.x = self.smallImageView.frame.size.width + self.smallImageView.frame.origin.x + 10;
    excerptFrame.size.width = [Default screenSize].width - 10 - excerptFrame.origin.x;
    self.excerptLabel.frame = excerptFrame;

}


@end

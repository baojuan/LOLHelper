//
//  ContentTableViewCell.h
//  LOL
//
//  Created by baojuan on 14-9-22.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineSpaceLabel.h"

@protocol ContentTableViewCellDelegate <NSObject>

- (void)cellHeightCalculatedToRefreshCell;

@end


@interface ContentTableViewCell : UITableViewCell<LineSpaceLabelDelegate>
@property (nonatomic, weak) id <ContentTableViewCellDelegate> delegate;
@property (nonatomic, strong) IBOutlet LineSpaceLabel *label;

- (void)insertIntoData:(NSString *)string;
- (CGFloat)cellHeight;

@end

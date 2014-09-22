//
//  LineSpaceLabel.h
//  LOL
//
//  Created by baojuan on 14-9-22.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LineSpaceLabelDelegate <NSObject>

- (void)calculateCellHeight:(CGFloat)height;

@end

@interface LineSpaceLabel : UILabel
{
    CGFloat charSpace_;
    CGFloat lineSpace_;
}
@property (nonatomic, weak) id <LineSpaceLabelDelegate> delegate;
@property(nonatomic, assign) CGFloat charSpace;
@property(nonatomic, assign) CGFloat lineSpace;
@property(nonatomic, assign) CGSize size;
- (CGFloat)insertIntoContentWithContent:(NSString *)string;
- (CGFloat)height;

@end

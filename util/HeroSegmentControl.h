//
//  HeroSegmentControl.h
//  LOL
//
//  Created by baojuan on 14-9-22.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HeroSegmentControlDelegate <NSObject>

- (void)segmentControlSelectAtIndex:(NSInteger)index;

@end

@interface HeroSegmentControl : UIView

@property (nonatomic, strong) NSMutableArray *buttonArray;

- (id)initWithTitleArray:(NSArray *)titleArray;
@property (nonatomic, weak) id <HeroSegmentControlDelegate> delegate;
@end

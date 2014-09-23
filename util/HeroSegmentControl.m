//
//  HeroSegmentControl.m
//  LOL
//
//  Created by baojuan on 14-9-22.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "HeroSegmentControl.h"
#import "Default.h"
#import "SelectButton.h"
@implementation HeroSegmentControl

- (id)initWithTitleArray:(NSArray *)titleArray
{
    if (self = [super init]) {
        self.autoresizingMask = UIViewAutoresizingNone;
        self.frame = CGRectMake(0, 0, [Default screenSize].width, 45);
        self.backgroundColor = [UIColor whiteColor];
        _buttonArray = [[NSMutableArray alloc] init];
        CGFloat width = self.frame.size.width / [titleArray count];
        for (int i = 0; i < [titleArray count]; i++) {
            NSString *title = titleArray[i];
            SelectButton *button = [self selectButtonCreate:title Width:width];
            button.tag = 1000 + i;
            button.frame = CGRectMake(width * i, button.frame.origin.y, button.frame.size.width, button.frame.size.height);
            [self addSubview:button];
            if (i == 0) {
                button.selected = YES;
            }
            else {
                button.selected = NO;
            }
            [_buttonArray addObject:button];
        }
        
    }
    return self;
}

- (SelectButton *)selectButtonCreate:(NSString *)title Width:(CGFloat)width
{
    SelectButton *button = [[SelectButton alloc] initWithFrame:CGRectMake(0, 0, width, self.frame.size.height) Title:title];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)buttonClick:(UIButton *)button
{
    if (button.selected) {
        return;
    }
    for (UIButton *bb in _buttonArray) {
        bb.selected = NO;
//        bb.frame = CGRectMake(bb.frame.origin.x, 0, bb.frame.size.width, self.frame.size.height);
    }
    button.selected = YES;
    [self.delegate segmentControlSelectAtIndex:(button.tag - 1000)];
    
}

@end

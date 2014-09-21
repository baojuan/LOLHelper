//
//  SelectButton.m
//  LOL
//
//  Created by 南 篤良 on 14-6-25.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "SelectButton.h"
#import "Default.h"

@implementation SelectButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame Title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        self.title = title;
        [self setImage:[UIImage imageNamed:@"underLine"] forState:UIControlStateSelected];
        [self setImage:nil forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:[Default colorWithR:95 withG:95 withB:95] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self setTitle:title forState:UIControlStateNormal];
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 0, contentRect.size.width,contentRect.size.height);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGSize size = [self.title sizeWithFont:self.titleLabel.font constrainedToSize:contentRect.size];
    return CGRectMake((contentRect.size.width - size.width) / 2.0,contentRect.size.height - 5, size.width, 2);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

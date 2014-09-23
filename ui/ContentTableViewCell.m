//
//  ContentTableViewCell.m
//  LOL
//
//  Created by baojuan on 14-9-22.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "ContentTableViewCell.h"
#import "Default.h"
@implementation ContentTableViewCell
{
    CGFloat cellHeight;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        if (!_label) {
            _label = [[LineSpaceLabel alloc] initWithFrame:CGRectMake(10, 10, [Default screenSize].width - 20, 10)];
            _label.delegate = self;
            _label.lineSpace = 10;
            _label.charSpace = 2;
            _label.backgroundColor = [UIColor clearColor];
            self.backgroundColor = [Default colorWithR:245 withG:245 withB:245];
            _label.font = [UIFont systemFontOfSize:13];
            _label.numberOfLines = 0;
            [self addSubview:_label];
            
        }
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        _label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;

    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    if (_label) {
        return;
    }
    _label = [[LineSpaceLabel alloc] initWithFrame:CGRectMake(10, 10, [Default screenSize].width - 20, 10)];
    _label.delegate = self;

    _label.lineSpace = 5;
    _label.charSpace = 2;
    _label.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [Default colorWithR:245 withG:245 withB:245];
    _label.font = [UIFont systemFontOfSize:13];
    _label.numberOfLines = 0;
    [self addSubview:_label];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    _label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
}

- (void)insertIntoData:(NSString *)string
{
    _label.backgroundColor = [UIColor redColor];
    CGRect rect = _label.frame;
    rect.size.height = [_label insertIntoContentWithContent:string] + 5;//加5因为行间距
    rect.origin.y += rect.size.height / 2.0; //除2应该是因为画得时候center不对
    _label.frame = rect;

}

- (CGFloat)cellHeight
{
//    return _label.height;
//    return [_label height];
    return 0;
}

- (void)calculateCellHeight:(CGFloat)height
{
    CGRect rect = _label.frame;
    rect.size.height = height;
    _label.frame = rect;
    cellHeight = height;
//    [self.delegate cellHeightCalculatedToRefreshCell];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

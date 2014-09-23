//
//  RuneLabel.m
//  LOL
//
//  Created by baojuan on 14-9-22.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "RuneLabel.h"
#import "AppDelegate.h"

@implementation RuneLabel
{
    NSMutableArray *_runeArray;
    AppDelegate *appdelegate;
}

- (id)init {
    if (self = [super init]) {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"RuneLabel" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UIView class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];

        appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        _runeArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _runeArray = [[NSMutableArray alloc] init];
}

- (void)setRuneString:(NSString *)runeString
{
    _runeString = runeString;
    NSArray *array = [runeString componentsSeparatedByString:@";"];
    for (NSString *string in array) {
        NSArray *aa = [string componentsSeparatedByString:@","];
        if ([aa count] > 1) {
            [_runeArray addObject:aa];
        }
        else {
            [_runeArray addObject:@[string]];
        }
    }
    [self insertIntoData:_runeArray];
}

- (void)insertIntoData:(NSArray *)array
{
    for (int i = 0; i < [array count]; i ++) {
        NSArray *aa = array[i];
        UILabel *label = self.contentLabel[i];
        CGRect rect = label.frame;

        if ([aa count] == 1) {
            //调整contentLabel的位置
            rect.size.height = 19;
            NSString *str = aa[0];
            NSArray *typeArray = [str componentsSeparatedByString:@"*"];
            label.text = [NSString stringWithFormat:@"%@x%@",[self contentStringWithId:typeArray[0]],typeArray[1]];
        }
        else {
            rect.size.height = 32;
            NSMutableString *textString = [[NSMutableString alloc] init];
            for (NSString *tempString in aa) {
                NSArray *typeArray = [tempString componentsSeparatedByString:@"*"];
                [textString appendString:[NSString stringWithFormat:@"%@x%@",[self contentStringWithId:typeArray[0]],typeArray[1]]];
                [textString appendString:@"\n"];
            }
            [textString deleteCharactersInRange:NSMakeRange([textString length] - 1, 1)];
            label.text = textString;

        }
        
        if (i == 0) {
            rect.origin.y = 0;
        }
        else {
            UILabel *beforeLabel = self.contentLabel[i-1];
            rect.origin.y = beforeLabel.frame.origin.y + beforeLabel.frame.size.height;
        }
        label.frame = rect;
        
        UILabel *titleAtIndexLable = self.titleLabel[i];
        CGRect titleRect = titleAtIndexLable.frame;
        titleRect.origin.y = label.frame.origin.y;
        titleAtIndexLable.frame = titleRect;

        
        
    }
    
    UILabel *lastContentLabel = [self.contentLabel lastObject];
    
    CGRect viewFrame = self.frame;
    viewFrame.size.height = lastContentLabel.frame.size.height + lastContentLabel.frame.origin.y;
    self.frame = viewFrame;

    
}

- (NSString *)contentStringWithId:(NSString *)typeId
{
    NSDictionary *dict = [appdelegate getDataItem:@"Rune" ID:typeId];
    return dict[@"name"];
}


@end

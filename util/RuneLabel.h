//
//  RuneLabel.h
//  LOL
//
//  Created by baojuan on 14-9-22.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RuneLabel : UIView
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *titleLabel;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *contentLabel;
@property (nonatomic, copy)NSString *runeString;
@end

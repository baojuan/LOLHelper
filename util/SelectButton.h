//
//  SelectButton.h
//  LOL
//
//  Created by 南 篤良 on 14-6-25.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectButton : UIButton

- (id)initWithFrame:(CGRect)frame Title:(NSString *)title;
@property (strong, nonatomic)UIImageView *underLine;
@property (strong, nonatomic)NSString *title;
@end

//
//  HeroDetailViewController.m
//  LOL
//
//  Created by baojuan on 14-9-21.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "HeroDetailViewController.h"
#import "AppDelegate.h"
#import "HeroFirstTableViewCell.h"
#import "HeroSecondTableViewCell.h"
#import "Default.h"
#import "AttributeTableViewCell.h"
#import "ContentTableViewCell.h"

@interface HeroDetailViewController ()<UITableViewDataSource, UITableViewDelegate,HeroSecondTableViewCellDelegate,ContentTableViewCellDelegate>
@property (nonatomic, copy) NSDictionary *dataDict;
@end

@implementation HeroDetailViewController
{
    AppDelegate *appdelegate;
    NSInteger techNumber;
}

- (void)setHeroId:(NSString *)heroId
{
    _heroId = heroId;
    if (!appdelegate) {
        appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    }
    self.dataDict = [appdelegate getDataItem:@"Hero" ID:_heroId];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    techNumber = 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (true) {
        return [self firstTableViewCellForRowAtIndexPath:indexPath];
    }
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    return cell;
}

- (UITableViewCell *)firstTableViewCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        HeroFirstTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"HeroFirstTableViewCell" owner:self options:nil] lastObject];
        [cell insertIntoData:_dataDict];
        return cell;
    }
    if (indexPath.row == 1) {
        UITableViewCell *cell = [self titleCell];
        cell.textLabel.text = @"技能";
        return cell;
    }
    if (indexPath.row == 2) {
        HeroSecondTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"HeroSecondTableViewCell" owner:self options:nil] lastObject];
        cell.delegate = self;
        [cell insertIntoData:_dataDict selected:techNumber];
        return cell;
    }
    if (indexPath.row == 3) {
        UITableViewCell *cell = [self titleCell];
        cell.textLabel.text = @"使用技巧";
        return cell;
    }
    if (indexPath.row == 4) {
//        UITableViewCell *cell = [self contentCell];
        NSString *string = _dataDict[@"exp_use"];
//        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        [paragraphStyle setLineSpacing:8];
//        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
//        
//        
//        cell.textLabel.attributedText = attributedString;
//        [cell.textLabel sizeToFit];
//        cell.textLabel.text = string;
        ContentTableViewCell *cell = [[ContentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"exp_use"];
        cell.delegate = self;
        [cell insertIntoData:string];
        
        return cell;
    }
    
    if (indexPath.row == 5) {
        UITableViewCell *cell = [self titleCell];
        cell.textLabel.text = @"对抗技巧";
        return cell;
    }
    if (indexPath.row == 6) {
//        UITableViewCell *cell = [self contentCell];
        NSString *string = _dataDict[@"exp_vs"];

        ContentTableViewCell *cell = [[ContentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"exp_vs"];
        cell.delegate = self;
        [cell insertIntoData:string];
//        cell.textLabel.text = _dataDict[@"exp_vs"];
        return cell;
    }
    if (indexPath.row == 7) {
        UITableViewCell *cell = [self titleCell];
        cell.textLabel.text = @"英雄属性";
        return cell;
    }
    if (indexPath.row == 8) {
        AttributeTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"AttributeTableViewCell" owner:self options:nil] lastObject];
        [cell insertIntoData:_dataDict];
        return cell;
    }
    if (indexPath.row == 9) {
        UITableViewCell *cell = [self titleCell];
        cell.textLabel.text = @"背景故事";
        return cell;
    }
    if (indexPath.row == 10) {
//        UITableViewCell *cell = [self contentCell];
//        cell.textLabel.text = _dataDict[@"story"];
        
        NSString *string = _dataDict[@"story"];
        
        ContentTableViewCell *cell = [[ContentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"story"];
        cell.delegate = self;
        [cell insertIntoData:string];
        return cell;
    }


    
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    return cell;
}

- (UITableViewCell *)titleCell
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [Default colorWithR:210 withG:210 withB:210];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [Default colorWithR:102 withG:102 withB:102];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}


- (UITableViewCell *)contentCell
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    cell.backgroundColor = [Default colorWithR:245 withG:245 withB:245];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.numberOfLines = 0;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (true) {
        return [self firstTableViewHeightForRowAtIndexPath:indexPath];
    }
    return 0;
}

- (CGFloat)firstTableViewHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 166;
    }
    if (indexPath.row == 1) {
        return 28;
    }
    if (indexPath.row == 2) {
        HeroSecondTableViewCell *cell = (HeroSecondTableViewCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
        return [cell cellHeight];
    }
    if (indexPath.row == 3) {
        return 28;
    }
    if (indexPath.row == 4) {
        NSString *string = _dataDict[@"exp_use"];
        ContentTableViewCell *cell = [[ContentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        ;
        return [cell.label insertIntoContentWithContent:string] + 20;
//        return [self contentCellHeight:string];
    }
    if (indexPath.row == 5) {
        return 28;
    }
    if (indexPath.row == 6) {
        NSString *string = _dataDict[@"exp_vs"];
        ContentTableViewCell *cell = [[ContentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        ;
        return [cell.label insertIntoContentWithContent:string] + 20;
//        return [self contentCellHeight:string];
    }
    
    if (indexPath.row == 7) {
        return 28;
    }
    if (indexPath.row == 8) {
        return 297;
    }
    if (indexPath.row == 9) {
        return 28;
    }
    if (indexPath.row == 10) {
        NSString *string = _dataDict[@"story"];
        ContentTableViewCell *cell = [[ContentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        ;
        return [cell.label insertIntoContentWithContent:string] + 20;
//        return [self contentCellHeight:string];
    }
    return 0;
}

- (void)cellHeightCalculatedToRefreshCell
{
//    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (CGFloat)contentCellHeight:(NSString *)string
{
    CGFloat heightString = 0;
    NSArray *array = [string componentsSeparatedByString:@"\r\n"];

    
    for (NSString *ss in array) {
        CGSize size = [ss sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(295, 5000)];
//        CGSize size = [ss sizeWithAttributes:@{NSParagraphStyleAttributeName:paragraphStyle}];

        heightString += size.height;
    }

    return heightString;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (void)techButtonClick:(NSInteger)number
{
    techNumber = number;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

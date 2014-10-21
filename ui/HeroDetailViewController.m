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
#import "HeroSegmentControl.h"
#import "HeroTableViewHeadView.h"

#import "AFNetworking.h"
#import "HeroPlayTableViewCell.h"
#import "FirstTableViewCell.h"
#import "UIImageView+WebCache.h"
#import <MediaPlayer/MediaPlayer.h>
#import "WebViewController.h"


@interface HeroDetailViewController ()<UITableViewDataSource, UITableViewDelegate,HeroSecondTableViewCellDelegate,ContentTableViewCellDelegate,HeroSegmentControlDelegate>
@property (nonatomic, copy) NSDictionary *dataDict;
@property (nonatomic, copy) NSArray *playArray;
@property (nonatomic, copy) NSArray *newsArray;

@end

@implementation HeroDetailViewController
{
    AppDelegate *appdelegate;
    NSInteger techNumber;
    NSInteger selectedNumber;
    HeroSegmentControl *control;
    HeroTableViewHeadView *headView;
    UIButton *loadMoreButton;
    BOOL isNeedLoadMore;
    NSDictionary *_selectedDict;
    UILabel *noMoreLabel;
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
    
    isNeedLoadMore = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    [self requestDataDict];
    [self requestNewsData:@""];
    headView = [[[NSBundle mainBundle] loadNibNamed:@"HeroTableViewHeadView" owner:self options:nil] lastObject];
    
    
    selectedNumber = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = [self tableViewHeadView];
    techNumber = 0;
    //    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Default screenSize].width, 1)];
    //    footView.backgroundColor = [Default colorWithR:228 withG:228 withB:228];
    //    self.tableView.tableFooterView = footView;
    //    self.tableView.backgroundColor = [Default colorWithR:228 withG:228 withB:228];
    
    
    loadMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loadMoreButton setTitle:@"加载中..." forState:UIControlStateSelected];
    loadMoreButton.frame = CGRectMake(0, 0, 320, 44);
    [loadMoreButton setTitle:@"点击加载更多" forState:UIControlStateNormal];
    loadMoreButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [loadMoreButton setTitleColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [loadMoreButton setTitleColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0] forState:UIControlStateSelected];

    [loadMoreButton addTarget:self action:@selector(addMore) forControlEvents:UIControlEventTouchUpInside];
    
    noMoreLabel = [[UILabel alloc] initWithFrame:loadMoreButton.frame];
    noMoreLabel.text = @"木有了...";
    noMoreLabel.textAlignment = NSTextAlignmentCenter;
    noMoreLabel.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
    noMoreLabel.font = [UIFont systemFontOfSize:13];
    noMoreLabel.userInteractionEnabled = NO;
    
    self.tableView.tableFooterView = noMoreLabel;

    
    
    control = [[HeroSegmentControl alloc] initWithTitleArray:@[@"介绍",@"玩法",@"攻略"]];
    control.delegate = self;
}

- (void)addMore
{
    NSString *lastId = self.newsArray[([self.newsArray count] -1)][@"id"];
    [self requestNewsData:lastId];
}

- (void)requestDataDict
{
    NSString *url = [NSString stringWithFormat:@"%@?method=getHeroPlay&heroid=%@",[Default server],self.heroId];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: url]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"getHeroplay success");
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if (dict[@"data"]) {
                self.playArray = dict[@"data"];
            }
            else {
                self.playArray = @[];
            }
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure: %@", error);
        [Default showHubMessage:@"服务器错误"];
    }];
    [operation start];
    
}



- (void)requestNewsData:(NSString *)lastId
{
    loadMoreButton.selected = YES;
    NSString *url = [NSString stringWithFormat:@"%@?method=getHeroNews&heroid=%@&lastid=%@",[Default server],self.heroId,lastId];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: url]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"getHeroplay success");
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if (dict[@"data"]) {
                self.newsArray = dict[@"data"][@"list"];
            }
            else {
                self.newsArray = @[];
            }
            if ([self.newsArray count] < 20) {
                isNeedLoadMore = NO;
            }
            else {
                isNeedLoadMore = YES;
            }
        });
        loadMoreButton.selected = NO;
        [self judgeTableViewFooterView];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure: %@", error);
        [Default showHubMessage:@"服务器错误"];
        loadMoreButton.selected = NO;

    }];
    [operation start];
    
}


- (UIView *)tableViewHeadView
{
    [headView insertIntoData:_dataDict];
    return headView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (selectedNumber == 0) {
        return 11;
    }
    if (selectedNumber == 1) {
        return [self.playArray count];
        
    }
    if (selectedNumber == 2) {
        return [self.newsArray count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedNumber == 0) {
        return [self firstTableViewCellForRowAtIndexPath:indexPath];
    }
    if (selectedNumber == 1) {
        return [self secondTableViewCellForRowAtIndexPath:indexPath];
        
    }
    if (selectedNumber == 2) {
        return [self thirdTableViewCellForRowAtIndexPath:indexPath];
        
    }
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    return cell;
}
#pragma mark - firstTableViewCell
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

#pragma mark - secondTableViewCell

- (UITableViewCell *)secondTableViewCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *playCellName = @"playCellName";
    HeroPlayTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:playCellName];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HeroPlayTableViewCell" owner:self options:nil] lastObject];
        
    }
    [cell insertIntoData:self.playArray[indexPath.row]];
    return cell;
}


#pragma mark - thirdTableViewCell

- (UITableViewCell *)thirdTableViewCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *playCellName = @"newsCellName";
    FirstTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:playCellName];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FirstTableViewCell" owner:self options:nil] lastObject];
        
    }
    cell.videoImageView.hidden = YES;

    NSDictionary *dict = [self.newsArray objectAtIndex:indexPath.row];
    if ([[dict objectForKey:@"image"] length] > 0) {
        [cell haveImage:YES];
        if ([dict[@"videoID"] length] > 0) {
            cell.videoImageView.hidden = NO;
        }
        
        NSString *string = [dict objectForKey:@"image"];
        [cell.smallImageView setImageWithURL:[NSURL URLWithString:[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"small_image_loading"]];
    }
    else
    {
        [cell haveImage:NO];
        cell.smallImageView.image = nil;
    }
    
    cell.titleLabel.text = [dict objectForKey:@"title"];
    cell.excerptLabel.text = [dict objectForKey:@"excerpt"];
    
    
    return cell;
}

#pragma mark - tableViewHeight

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedNumber == 0) {
        return [self firstTableViewHeightForRowAtIndexPath:indexPath];
    }
    if (selectedNumber == 1) {
        return [self secondTableViewHeightForRowAtIndexPath:indexPath];
    }
    if (selectedNumber == 2) {
        return [self thirdTableViewHeightForRowAtIndexPath:indexPath];
    }
    return 0;
}
#pragma mark - firstTableViewHeight

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
#pragma mark - secondTableViewHeight

- (CGFloat)secondTableViewHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HeroPlayTableViewCell *cell = (HeroPlayTableViewCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return [cell cellHeight] + 5;
}

#pragma mark - secondTableViewHeight

- (CGFloat)thirdTableViewHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedNumber == 2) {
        NSDictionary *dict = [self.newsArray objectAtIndex:indexPath.row];
        if ([dict[@"videoID"] length] > 0) {
            [self requestVideoUrl:dict[@"videoID"]];
        }
        else {
            _selectedDict = [self.newsArray objectAtIndex:indexPath.row];
            [self performSegueWithIdentifier:@"NewWebViewController" sender:self];

        }
    }
}

- (void)requestVideoUrl:(NSString *)videoId
{
    MBProgressHUD *hub = [Default showHubMessageManualHidden:@"视频准备中"];
 
    NSString *url = [NSString stringWithFormat:@"http://app.dianjingshijie.com/flashinterface/getmovieurl.ashx?url=http://v.youku.com/v_show/id_%@.html&typeid=2",videoId];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: url]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"getNews success");
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        MPMoviePlayerViewController *controller = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:string]];
        [self presentMoviePlayerViewControllerAnimated:controller];
        [hub hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure: %@", error);
        [hub hide:YES];
        [Default showHubMessage:@"获取视频url失败"];
    }];
    [operation start];
    
}



#pragma mark -

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return control;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (void)segmentControlSelectAtIndex:(NSInteger)index
{
    selectedNumber = index;
    [self judgeTableViewFooterView];
    [self.tableView reloadData];
}

- (void)judgeTableViewFooterView
{
    if (selectedNumber == 2 ) {
        if (isNeedLoadMore) {
            self.tableView.tableFooterView = loadMoreButton;

        }
        if ([self.newsArray count] == 0) {
            self.tableView.tableFooterView = noMoreLabel;
            
        }
        else {
            self.tableView.tableFooterView = nil;
            
        }

    }
    else {
        self.tableView.tableFooterView = nil;
        
    }

}

- (void)techButtonClick:(NSInteger)number
{
    techNumber = number;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *controller = segue.destinationViewController;
    if ([controller isKindOfClass:[WebViewController class]]) {
        ((WebViewController *) controller).webUrl = _selectedDict[@"url"];
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

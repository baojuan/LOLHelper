//
//  FirstViewController.m
//  LOL
//
//  Created by baojuan on 14-9-21.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "FirstViewController.h"
#import "AFNetworking.h"
#import "Default.h"
#import "FirstTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "WebViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "LoadMoreTableFooterView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MobClick.h"


@interface FirstViewController()<EGORefreshTableHeaderDelegate,LoadMoreTableFooterDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSString *bannerImageUrl;
@property (nonatomic, strong) NSString *bannerUrl;
@property (nonatomic, strong) NSString *lastId;

@end

@implementation FirstViewController
{
    NSDictionary *_selectedDict;
    EGORefreshTableHeaderView *_refreshHeaderView;
    LoadMoreTableFooterView *_loadMoreView;
    BOOL _reloading;

}

- (void)viewDidLoad
{
    self.lastId = @"";
    self.dataArray = [[NSMutableArray alloc] init];
    self.navigationItem.title = @"新闻资讯";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, -5, 0, 5);
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.tableView.frame.size.height)];
    _refreshHeaderView.backgroundColor = [UIColor clearColor];
    _refreshHeaderView.delegate = self;
    [self.view insertSubview:_refreshHeaderView belowSubview:self.tableView];
    _loadMoreView = [[LoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 64 - 49, self.view.frame.size.width, 20)];
    _loadMoreView.delegate = self;
    [self.view insertSubview:_loadMoreView belowSubview:self.tableView];

    [self getNews:self.lastId];
    [_refreshHeaderView refreshLastUpdatedDate];
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
}

- (UIView *)tableViewHeadView
{
    [self doneLoadingTableViewData];

    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [Default screenSize].width, 152)];
    view.backgroundColor = [UIColor grayColor];
    view.userInteractionEnabled = YES;
    view.contentMode = UIViewContentModeScaleAspectFill;
    view.clipsToBounds = YES;
    [view setImageWithURL:[NSURL URLWithString:_bannerImageUrl] placeholderImage:[UIImage imageNamed:@"banner_loading"]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bannerClick)];
    [view addGestureRecognizer:tap];
    return view;
}

- (void)bannerClick
{
    _selectedDict = @{@"url":_bannerUrl};
    [self performSegueWithIdentifier:@"WebViewController" sender:self];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"newsCellName";
    FirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FirstTableViewCell" owner:self options:nil] lastObject];
        cell.separatorInset = UIEdgeInsetsMake(0, 5, 0, 5);
    }
    cell.videoImageView.hidden = YES;
    
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [MobClick event:@"newsClick" label:[NSString stringWithFormat:@"新闻id：%@，新闻title：%@",_selectedDict[@"id"],_selectedDict[@"title"]]];

    _selectedDict = [_dataArray objectAtIndex:indexPath.row];
    if ([_selectedDict[@"videoID"] length] > 0) {
        [self requestVideoUrl:_selectedDict[@"videoID"]];
    }
    else {
        [self performSegueWithIdentifier:@"WebViewController" sender:self];
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
        [Default showHubMessage:@"服务器错误"];
    }];
    [operation start];

}

- (void)getNews:(NSString *)lastID
{
    NSString *url = [NSString stringWithFormat:@"%@?method=getNews&lastid=%@",[Default server],lastID];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: url]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"getNews success");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *aa = [[dict objectForKey:@"data"] objectForKey:@"list"];
        if ([aa count] > 0) {
            if ([lastID isEqualToString:@""]) {
                [_dataArray removeAllObjects];
            }
            [_dataArray addObjectsFromArray:aa];
            self.bannerImageUrl = [[dict objectForKey:@"data"] objectForKey:@"banner"];
            self.bannerUrl = [[dict objectForKey:@"data"] objectForKey:@"banner_url"];
            self.tableView.tableHeaderView = [self tableViewHeadView];
            [self.tableView reloadData];
            self.lastId = _dataArray[([_dataArray count] - 1)][@"id"];
        }
        [self doneLoadingTableViewData];

        [_loadMoreView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure: %@", error);
        [Default showHubMessage:@"加载失败"];
        [self doneLoadingTableViewData];

        [_loadMoreView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];

    }];
    [operation start];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *controller = segue.destinationViewController;
    if ([controller isKindOfClass:[WebViewController class]]) {
        ((WebViewController *) controller).webUrl = _selectedDict[@"url"];
    }

}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
    
    //  should be calling your tableviews data source model to reload
    //  put here just for demo
    _reloading = YES;
    [self getNews:@""];
    
}

- (void)doneLoadingTableViewData{
    
    //  model should call this when its done loading
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 0) {
    [_refreshHeaderView egoRefreshScrollViewWillBeginScroll:scrollView];
    }
    

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y < 0) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];

    }
    else {
        [_loadMoreView egoRefreshScrollViewDidScroll:scrollView];

    }

    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.contentOffset.y < 0) {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];

    }
    else {
        [_loadMoreView egoRefreshScrollViewDidEndDragging:scrollView];

    }

    
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
    [self reloadTableViewDataSource];
//    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return _reloading; // should return if data source model is reloading
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
    
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)loadMoreTableFooterDidTriggerLoadMore:(LoadMoreTableFooterView *)view
{
    [self getNews:_dataArray[([_dataArray count] - 1)][@"id"]];
}

#pragma mark -

- (BOOL)shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}


@end

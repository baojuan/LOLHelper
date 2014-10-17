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



#define BASIC_YOUKU @"<html><head><div id=\"youkuplayer\"></div><script type=\"text/javascript\" src=\"http://player.youku.com/jsapi\">player= new YKU.Player('youkuplayer',{client_id:'04a4fa40c0634318',vid:'%@'});</script></head></html>"

#define BASIC_YOUKU_INNER @"<html><head><div id=\"youkuplayer\"></div><script type=\"text/javascript\" src=\"http://player.youku.com/jsapi\">player= new YKU.Player('youkuplayer',{client_id:'04a4fa40c0634318',vid:'%@',embsig:'%@'});</script></head></html>"


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
    _loadMoreView = [[LoadMoreTableFooterView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    _loadMoreView.delegate = self;
    self.tableView.tableFooterView = _loadMoreView;
    [self getNews:self.lastId];
    [_refreshHeaderView refreshLastUpdatedDate];


}

- (UIView *)tableViewHeadView
{
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
    _selectedDict = @{@"url":_bannerImageUrl};
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
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    if ([[dict objectForKey:@"image"] length] > 0) {
        [cell haveImage:YES];
        [cell.smallImageView setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"small_image_loading"]];
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
    _selectedDict = [_dataArray objectAtIndex:indexPath.row];
    if ([_selectedDict[@"videoID"] length] > 0) {
        NSString *url = @"";//[NSString stringWithFormat:@"%@",BASIC_YOUKU,_selectedDict[@"videoID"]];
        MPMoviePlayerViewController *controller = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:url]];
        [self presentMoviePlayerViewControllerAnimated:controller];
    }
    else {
        [self performSegueWithIdentifier:@"WebViewController" sender:self];

    }

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
            [self doneLoadingTableViewData];
        }
        [_loadMoreView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure: %@", error);
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


@end

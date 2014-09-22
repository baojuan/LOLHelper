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

@interface FirstViewController()

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSString *bannerImageUrl;
@property (nonatomic, strong) NSString *bannerUrl;

@end

@implementation FirstViewController
{
    NSDictionary *_selectedDict;
}

- (void)viewDidLoad
{
    self.dataArray = [[NSMutableArray alloc] init];
    self.navigationItem.title = @"新闻资讯";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, -5, 0, 5);
    [self getNews:0];

}

- (UIView *)tableViewHeadView
{
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [Default screenSize].width, 152)];
    view.backgroundColor = [UIColor grayColor];
    view.userInteractionEnabled = YES;
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
    [self performSegueWithIdentifier:@"WebViewController" sender:self];

}

- (void)getNews:(NSString *)lastID
{
    NSString *url = [NSString stringWithFormat:@"%@?method=getNews",[Default server]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: url]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"getNews success");
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [_dataArray addObjectsFromArray:[[dict objectForKey:@"data"] objectForKey:@"list"]];
        self.bannerImageUrl = [[dict objectForKey:@"data"] objectForKey:@"banner"];
        self.bannerUrl = [[dict objectForKey:@"data"] objectForKey:@"banner_url"];
        self.tableView.tableHeaderView = [self tableViewHeadView];
        [self.tableView reloadData];
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

@end

//
//  SecondViewController.m
//  LOL
//
//  Created by baojuan on 14-9-21.
//  Copyright (c) 2014年 baojuan. All rights reserved.
//

#import "SecondViewController.h"
#import "SecondCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "Default.h"
#import "SelectButton.h"
#import "DataBase.h"
#import "AppDelegate.h"
#import "HeroDetailViewController.h"


@interface SecondViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) UIView *selectView;

@end

@implementation SecondViewController
{
    NSMutableArray *buttonArray1;
    NSMutableArray *buttonArray2;
    
    
    NSArray *heroList;
    NSDictionary *heroIDList;
    
    UIButton *buttonGroup1NowSelect;
    UIButton *buttonGroup2NowSelect;
    
    NSDictionary *_selectedDict;

}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    [_dataArray removeAllObjects];
    [_dataArray addObjectsFromArray:dataArray];
    
    [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    appdelegate.secondViewController = self;
    
    [self creatSelectView];
    [self setCollectionViewProperty];
}

- (void)setCollectionViewProperty
{
    [self.collectionView registerClass:[SecondCollectionViewCell class] forCellWithReuseIdentifier:@"SecondCollectionViewCell"];
    self.collectionView.backgroundColor = [UIColor redColor];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_dataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SecondCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SecondCollectionViewCell" forIndexPath:indexPath];
    NSDictionary *dict = [_dataArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = [dict objectForKey:@"title"];
    [cell.imageView setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"icon"]] placeholderImage:[UIImage imageNamed:@"hero_icon_loading"]];
    [cell setTitleLabelFontSizeIsBigFont:cell.titleLabel.text];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(73, 95);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedDict = [_dataArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"HeroViewController" sender:self];
}

- (void)creatSelectView{
    _selectView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, 640, 70)];
    [_selectView setBackgroundColor:[Default colorWithR:220 withG:220 withB:220]];
    buttonArray1 = [[NSMutableArray alloc] initWithCapacity:6];
    buttonArray2 = [[NSMutableArray alloc] initWithCapacity:4];
    
    SelectButton *btn_select_all = [[SelectButton alloc]initWithFrame:CGRectMake(0, 1, 73, 33) Title:@"全部"];
    [btn_select_all addTarget:self action:@selector(selectGroup1Action:) forControlEvents:UIControlEventTouchUpInside];
    btn_select_all.selected = YES;
    btn_select_all.tag =100 + 1;
    SelectButton *btn_select_up_1 = [[SelectButton alloc]initWithFrame:CGRectMake(73, 1, 50, 33) Title:@"上单"];
    [btn_select_up_1 addTarget:self action:@selector(selectGroup1Action:) forControlEvents:UIControlEventTouchUpInside];
    btn_select_up_1.tag =100 + 2;
    
    SelectButton *btn_select_up_2 = [[SelectButton alloc]initWithFrame:CGRectMake(73+50, 1, 50, 33) Title:@"中单"];
    [btn_select_up_2 addTarget:self action:@selector(selectGroup1Action:) forControlEvents:UIControlEventTouchUpInside];
    btn_select_up_2.tag =100 + 3;
    
    SelectButton *btn_select_up_3 = [[SelectButton alloc]initWithFrame:CGRectMake(73+50*2, 1, 50, 33) Title:@"打野"];
    [btn_select_up_3 addTarget:self action:@selector(selectGroup1Action:) forControlEvents:UIControlEventTouchUpInside];
    btn_select_up_3.tag =100 + 4;
    
    
    SelectButton *btn_select_up_4 = [[SelectButton alloc]initWithFrame:CGRectMake(73+50*3, 1, 43, 33) Title:@"ADC"];
    [btn_select_up_4 addTarget:self action:@selector(selectGroup1Action:) forControlEvents:UIControlEventTouchUpInside];
    btn_select_up_4.tag =100 + 5;
    
    SelectButton *btn_select_up_5 = [[SelectButton alloc]initWithFrame:CGRectMake(73+50*3+43, 1, 50, 33) Title:@"辅助"];
    [btn_select_up_5 addTarget:self action:@selector(selectGroup1Action:) forControlEvents:UIControlEventTouchUpInside];
    btn_select_up_5.tag =100 + 6;
    
    
    [buttonArray1 addObject:btn_select_all];
    [buttonArray1 addObject:btn_select_up_1];
    [buttonArray1 addObject:btn_select_up_2];
    [buttonArray1 addObject:btn_select_up_3];
    [buttonArray1 addObject:btn_select_up_4];
    [buttonArray1 addObject:btn_select_up_5];
    
    buttonGroup1NowSelect = btn_select_all;
    
    
    SelectButton *btn_select_new = [[SelectButton alloc]initWithFrame:CGRectMake(0, 33, 71, 33) Title:@"按最新"];
    [btn_select_new addTarget:self action:@selector(selectGroup2Action:) forControlEvents:UIControlEventTouchUpInside];
    btn_select_new.selected = YES;
    btn_select_new.tag = 100 + 10;
    
    SelectButton *btn_select_ticket = [[SelectButton alloc]initWithFrame:CGRectMake(71, 33, 67, 33) Title:@"按点券"];
    [btn_select_ticket addTarget:self action:@selector(selectGroup2Action:) forControlEvents:UIControlEventTouchUpInside];
    btn_select_ticket.tag = 100 + 20;
    
    SelectButton *btn_select_coin = [[SelectButton alloc]initWithFrame:CGRectMake(71+67, 33, 67, 33) Title:@"按金币"];
    [btn_select_coin addTarget:self action:@selector(selectGroup2Action:) forControlEvents:UIControlEventTouchUpInside];
    btn_select_coin.tag = 100 + 30;
    
    
    SelectButton *btn_select_pinyin = [[SelectButton alloc]initWithFrame:CGRectMake(71+67*2, 33, 67, 33) Title:@"按拼音"];
    [btn_select_pinyin addTarget:self action:@selector(selectGroup2Action:) forControlEvents:UIControlEventTouchUpInside];
    btn_select_pinyin.tag = 100 + 40;
    
    
    [buttonArray2 addObject:btn_select_new];
    [buttonArray2 addObject:btn_select_ticket];
    [buttonArray2 addObject:btn_select_coin];
    [buttonArray2 addObject:btn_select_pinyin];
    
    
    buttonGroup2NowSelect = btn_select_new;
    
    [self.view addSubview:_selectView];
    [_selectView addSubview:btn_select_all];
    [_selectView addSubview:btn_select_up_1];
    [_selectView addSubview:btn_select_up_2];
    [_selectView addSubview:btn_select_up_3];
    [_selectView addSubview:btn_select_up_4];
    [_selectView addSubview:btn_select_up_5];
    [_selectView addSubview:btn_select_new];
    [_selectView addSubview:btn_select_ticket];
    [_selectView addSubview:btn_select_coin];
    [_selectView addSubview:btn_select_pinyin];
}

- (void)selectGroup1Action:(UIButton *)button
{
    if (button.selected) {
        return;
    }
    buttonGroup1NowSelect = button;
    for (UIButton *button in buttonArray1) {
        button.selected = NO;
    }
    button.selected = YES;
    [self getDataFromDataBase];
    
    
}

- (void)selectGroup2Action:(UIButton *)button
{
    if (button.selected) {
        return;
    }
    buttonGroup2NowSelect = button;
    for (UIButton *button in buttonArray2) {
        button.selected = NO;
    }
    button.selected = YES;
    [self getDataFromDataBase];
}

- (void)getDataFromDataBase
{
    if (!heroList) {
        heroList = [[NSUserDefaults standardUserDefaults] objectForKey:@"HeroList"];
        
    }
    if (!heroIDList) {
        heroIDList = [[NSUserDefaults standardUserDefaults] objectForKey:@"HeroIDList"];
        
    }
    if (buttonGroup2NowSelect.tag == 110) {
        NSArray *resultArray = [[DataBase sharedDataBase] getHeroListForNewsLocation:buttonGroup1NowSelect.titleLabel.text];
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSString * heroId in resultArray) {
            NSString *location = [heroIDList objectForKey:heroId];
            [tempArray addObject:[heroList objectAtIndex:[location intValue]]];
        }
        self.dataArray = tempArray;
        
    }
    if (buttonGroup2NowSelect.tag == 120) {
        NSArray *resultArray = [[DataBase sharedDataBase] getHeroListForTicketLocation:buttonGroup1NowSelect.titleLabel.text];
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSString * heroId in resultArray) {
            NSString *location = [heroIDList objectForKey:heroId];
            [tempArray addObject:[heroList objectAtIndex:[location intValue]]];
        }
        self.dataArray = tempArray;
        
    }
    if (buttonGroup2NowSelect.tag == 130) {
        NSArray *resultArray = [[DataBase sharedDataBase] getHeroListForCoinLocation:buttonGroup1NowSelect.titleLabel.text];
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSString * heroId in resultArray) {
            NSString *location = [heroIDList objectForKey:heroId];
            [tempArray addObject:[heroList objectAtIndex:[location intValue]]];
        }
        self.dataArray = tempArray;
        
    }
    if (buttonGroup2NowSelect.tag == 140) {
        NSArray *resultArray = [[DataBase sharedDataBase] getHeroListForEnNameLocation:buttonGroup1NowSelect.titleLabel.text];
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSString * heroId in resultArray) {
            NSString *location = [heroIDList objectForKey:heroId];
            [tempArray addObject:[heroList objectAtIndex:[location intValue]]];
        }
        self.dataArray = tempArray;
        
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *controller = segue.destinationViewController;
    if ([controller isKindOfClass:[HeroDetailViewController class]]) {
        ((HeroDetailViewController *) controller).heroId = _selectedDict[@"id"];
    }

}

@end

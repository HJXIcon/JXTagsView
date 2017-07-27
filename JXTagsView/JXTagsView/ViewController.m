//
//  ViewController.m
//  JXTagsView
//
//  Created by mac on 17/7/27.
//  Copyright © 2017年 JXIcon. All rights reserved.
//

#import "ViewController.h"
#import "JXTagsView.h"

@interface ViewController ()
@property (strong, nonatomic) JXTagsView *tagsView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"高度自动跟随标题计算";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tagsView = [[JXTagsView alloc]init];
    //
    NSArray *tags = @[@"HJXIcon",@"晓梦影",@"iOS_icon",@"4乌尔奇奥拉",@"传统钓",@"台钓",@"手竿钓",@"海竿钓",@"抬竿钓(拉晃)",@"路亚",@"夜钓",@"冰钓",@"野钓",@"竞技钓",@"休闲钓",@"商业塘公关钓"];
    
    self.tagsView.tagsArray = tags;
    JXTagsCollectionViewFlowLayout *layout = [[JXTagsCollectionViewFlowLayout alloc]init];
    
    self.tagsView.layout = layout;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    __weak typeof(self) weakSelf = self;
    
    CGFloat height = [JXTagsView getHeightWithTags:tags layout:layout tagAttribute:nil maxWidth:self.view.bounds.size.width];
    
    [self.tagsView setTagsFrameUpdateBlock:^(CGFloat height){
        
        weakSelf.tagsView.frame = CGRectMake(0, 64, weakSelf.view.bounds.size.width, height);
    }];
    
    self.tagsView.isMultiSelect = YES;
    self.tagsView.isSort = YES;
    
    
    [self.tagsView setCompletion:^(NSArray <NSString *> *selectArray,NSInteger index){
        
        NSLog(@"selectArray == %@",selectArray);
        NSLog(@"======================");
        NSLog(@"index == %ld",index);
    }];
    
    
    
    self.tagsView.frame = CGRectMake(0, 64, self.view.bounds.size.width, height);
    
    [self.view addSubview:self.tagsView];
    
    
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.tagsView reloadData];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

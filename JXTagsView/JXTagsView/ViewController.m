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
    
    // 0.如果应用有导航栏的话，不自动设置相应的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 1.标签数组
    NSArray *tags = @[@"HJXIcon",@"晓梦影",@"iOS_icon",@"4乌尔奇奥拉",@"传统钓",@"台钓",@"手竿钓",@"海竿钓",@"抬竿钓(拉晃)",@"路亚",@"夜钓",@"冰钓",@"商业塘公da",@"野钓",@"竞技钓",@"休闲钓",@"商业塘公关钓",@"休闲钓",@"商业塘公关钓"];
    
    __weak typeof(self) weakSelf = self;
    
    // 2.设置属性
    JXTagsAttribute *attribute = [[JXTagsAttribute alloc]init];
    // 圆角
    attribute.isShowCorner = YES;
    attribute.edgeInsets = UIEdgeInsetsMake(5, 10, 15, 20);
    _tagsView.tagAttribute = attribute;
    
    // 3.创建tagsView
    self.tagsView = [[JXTagsView alloc]initWithFrame:CGRectZero Tags:tags TagAttribute:attribute UpdateFrame:^(CGFloat currentHeight) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            weakSelf.tagsView.frame = CGRectMake(0, 64, weakSelf.view.bounds.size.width, currentHeight);
            
           
            NSLog(@"update----- %f",currentHeight);
        });
    } completion:^(NSArray<NSNumber *> *selectArray, NSArray<NSString *> *tags) {
        
        NSLog(@"selectArray == %@",selectArray);
        NSLog(@"======================");
        NSLog(@"tags == %@",tags);
    }];
    
    self.tagsView.isMultiSelect = YES;
    self.tagsView.isSort = YES;
    
    
    // 4.计算高度（如果标签不能滚动的话，需要先计算出所有的标签总体高度）
    CGFloat height = [self.tagsView getHeightWithMaxWidth:self.view.bounds.size.width];
    NSLog(@"height----- %f",height);
    self.tagsView.frame = CGRectMake(0, 64, self.view.bounds.size.width, height);
    self.tagsView.backgroundColor = [UIColor redColor];
    
    
    // 5.添加
    [self.view addSubview:self.tagsView];
    
    
}



@end

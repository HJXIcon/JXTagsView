# JXTagsView

### 1.支持拖动排序
### 2.支持拖动是否滚动，高度自动计算
### 3支持多选单选

![image](https://github.com/HJXIcon/JXTagsView/blob/master/JXTagsView/JXTagsView/Gif%E6%95%88%E6%9E%9C%E5%9B%BE/tags%E6%95%88%E6%9E%9C%E5%9B%BE.gif)
</br>
#### 高度自适应
![image](https://github.com/HJXIcon/JXTagsView/blob/master/JXTagsView/JXTagsView/Gif%E6%95%88%E6%9E%9C%E5%9B%BE/tagsFrame.gif)
<img src="https://github.com/HJXIcon/JXTagsView/blob/master/JXTagsView/JXTagsView/Gif%E6%95%88%E6%9E%9C%E5%9B%BE/tagsFrame.gif" width = "320" height = "568" alt="高度自适应" align=center />
</br>

#### 设置内边距
<img src="https://github.com/HJXIcon/JXTagsView/blob/master/JXTagsView/JXTagsView/Gif%E6%95%88%E6%9E%9C%E5%9B%BE/Snip20171020_4.png" width = "320" height = "568" alt="设置内边距" align=center />
</br>

##### 使用步骤
pod search JXTagsView --simple

pod 'JXTagsView', '~> 1.0.1'

    // 0.如果应用有导航栏的话，需要设置
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 1.标签数组
    NSArray *tags = @[@"HJXIcon",@"晓梦影",@"iOS_icon",@"4乌尔奇奥拉",@"传统钓",@"台钓",@"手竿钓",@"海竿钓",@"抬竿钓(拉晃)",@"路亚",@"夜钓",@"冰钓",@"商业塘公da",@"野钓",@"竞技钓",@"休闲钓",@"商业塘公关钓",@"休闲钓",@"商业塘公关钓"];
    
    __weak typeof(self) weakSelf = self;
    
    // 2.设置属性
    JXTagsAttribute *attribute = [[JXTagsAttribute alloc]init];
    // 圆角
    attribute.isShowCorner = YES;
    attribute.edgeInsets = UIEdgeInsetsMake(5, 10, 15, 20);
    
    // 3.创建tagsView
    JXTagsView *tagsView = [[JXTagsView alloc]initWithFrame:CGRectZero Tags:tags TagAttribute:attribute UpdateFrame:^(CGFloat currentHeight) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 更新frame
            weakSelf.tagsView.frame = CGRectMake(0, 64, self.view.bounds.size.width, currentHeight);
        });
    } completion:^(NSArray<NSNumber *> *selectArray, NSArray<NSString *> *tags) {
        
        NSLog(@"selectArray == %@",selectArray);
        NSLog(@"tags == %@",tags);
    }];
    
    _tagsView = tagsView;
    tagsView.isMultiSelect = YES;
    tagsView.isSort = YES;
    
    
    // 4.计算高度（如果标签不能滚动的话，需要先计算出所有的标签总体高度）
    CGFloat height = [tagsView getHeightWithMaxWidth:self.view.bounds.size.width];
    tagsView.frame = CGRectMake(0, 64, self.view.bounds.size.width, height);
    tagsView.backgroundColor = [UIColor redColor];
    
    
    // 5.添加
    [self.view addSubview:tagsView];

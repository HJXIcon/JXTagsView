//
//  JXTagsCollectionViewCell.m
//  JXTagsView
//
//  Created by mac on 17/7/27.
//  Copyright © 2017年 JXIcon. All rights reserved.
//

#import "JXTagsCollectionViewCell.h"

@implementation JXTagsCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.titleLabel.frame = self.bounds;
    
}


/// 细胞被重用如何提前知道？重写单元的prepareForReuse官方头文件中有说明。当前已经被分配的小区如果被重用了（通常是滚动出屏幕外了），会调用细胞的prepareForReuse通知小区。注意这里重写方法的时候，注意一定要调用父类方法[super prepareForReuse]。这个在使用单元格作为网络访问的代理容器时尤其要注意，需要在这里通知取消掉前一次网络请求。不要再给这个单元发数据了。

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.titleLabel.text = @"";
}
@end

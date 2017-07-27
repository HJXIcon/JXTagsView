//
//  JXTagsCollectionViewFlowLayout.m
//  JXTagsView
//
//  Created by mac on 17/7/27.
//  Copyright © 2017年 JXIcon. All rights reserved.
//

#import "JXTagsCollectionViewFlowLayout.h"
@interface JXTagsCollectionViewFlowLayout ()

@property (nonatomic, weak) id<UICollectionViewDelegateFlowLayout> delegate;
///
@property (nonatomic, strong) NSMutableArray <UICollectionViewLayoutAttributes *>*itemAttributes;
@property (nonatomic, assign) CGFloat contentWidth;//滑动宽度 水平
@property (nonatomic, assign) CGFloat contentHeight;//滑动高度 垂直

@end

@implementation JXTagsCollectionViewFlowLayout

#pragma mark - lazy load
- (NSMutableArray<UICollectionViewLayoutAttributes *> *)itemAttributes{
    if (_itemAttributes == nil) {
        _itemAttributes = [NSMutableArray array];
    }
    return _itemAttributes;
}


#pragma mark - init


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.itemSize = CGSizeMake(100.0f, 34.0f);
        self.minimumInteritemSpacing = 10.0f;
        self.minimumLineSpacing = 10.0f;
        self.sectionInset = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    }
    return self;
}

#pragma mark - ovrride
- (void)prepareLayout{
    [super prepareLayout];
    
     [self.itemAttributes removeAllObjects];
    
    //滑动的宽度 = 左边
    self.contentWidth = self.sectionInset.left;
    
    //cell的高度 = 顶部 + 高度
    self.contentHeight = self.sectionInset.top  + self.itemSize.height;
    
    CGFloat originX = self.sectionInset.left;
    CGFloat originY = self.sectionInset.top;
    
    // item 个数
     NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    
    for (NSInteger i = 0; i < itemCount; i ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        // item的Size
        CGSize itemSize = [self itemSizeForIndexPath:indexPath];
        
        // 判断滚动方向
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            // ===>>>> 垂直滚动
            //当前CollectionViewCell的起点 + 当前CollectionViewCell的宽度 + 当前CollectionView距离右侧的间隔 > collectionView的宽度
            if ((originX + itemSize.width + self.sectionInset.right) > self.collectionView.frame.size.width) {
                
                originX = self.sectionInset.left;
                originY += itemSize.height + self.minimumLineSpacing;
                
                /// 垂直滚动范围
                self.contentHeight += itemSize.height + self.minimumLineSpacing;
            }
            
        }else{
            // ===>>>> 水平滚动
            self.contentWidth += itemSize.width + self.minimumInteritemSpacing;
            
        }
        
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.frame = CGRectMake(originX, originY, itemSize.width, itemSize.height);
        [self.itemAttributes addObject:attributes];
        
        /// 起点增加
        originX += itemSize.width + self.minimumInteritemSpacing;
        
        
    }
    
    /// 垂直滚动范围 = 加上最后的底边距
    self.contentHeight += self.sectionInset.bottom;
    
    
    
}

- (CGSize)collectionViewContentSize
{
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        return CGSizeMake(self.collectionView.frame.size.width, self.contentHeight);
        
    } else {
        return CGSizeMake(self.contentWidth,self.collectionView.frame.size.height);
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.itemAttributes;
}

// 判定为布局需要被无效化并重新计算的时候,布局对象会被询问以提供新的布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    
    
    CGRect oldBounds = self.collectionView.bounds;
    
    if (CGRectGetWidth(newBounds) != CGRectGetWidth(oldBounds)) {
        return YES;
    }
    
    return NO;
}


#pragma mark - 
- (id<UICollectionViewDelegateFlowLayout>)delegate{
    
    if (_delegate == nil) {
        _delegate =  (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    }
    
    return _delegate;
}


#pragma mark - 返回一个item的size
- (CGSize)itemSizeForIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
        
        self.itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
        
    }
    return self.itemSize;
    
}






@end

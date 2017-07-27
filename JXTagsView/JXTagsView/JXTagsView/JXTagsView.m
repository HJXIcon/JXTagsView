//
//  JXTagsView.m
//  JXTagsView
//
//  Created by mac on 17/7/27.
//  Copyright © 2017年 JXIcon. All rights reserved.
//

#import "JXTagsView.h"
#import "JXTagsCollectionViewCell.h"
#import "JXTagsAttribute.h"

/// 最大宽度
static CGFloat MaxWidth = 0;

static NSString * const reuseIdentifier = @"JXTagsCollectionViewCellId";

@interface JXTagsView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
/// ====>>> iOS9方法
//@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;

@property (nonatomic,assign)BOOL isChange;
@property (nonatomic,strong)NSMutableArray *cellAttributesArray;

@property (nonatomic, strong) NSMutableArray <NSString *>*selectedTags;

@end

@implementation JXTagsView

#pragma mark - lazy load
- (NSMutableArray<NSString *> *)selectedTags{
    if (_selectedTags == nil) {
        _selectedTags = [NSMutableArray array];
    }
    return _selectedTags;
}

- (NSMutableArray *)cellAttributesArray {
    if(_cellAttributesArray == nil) {
        _cellAttributesArray = [[NSMutableArray alloc] init];
    }
    return _cellAttributesArray;
}


- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
        [_collectionView registerClass:[JXTagsCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    }
    
    _collectionView.collectionViewLayout = _layout;
    
    if (_layout.scrollDirection == UICollectionViewScrollDirectionVertical) {
        //垂直
        _collectionView.showsVerticalScrollIndicator = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
    } else {
        _collectionView.showsHorizontalScrollIndicator = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
    }
    
    
    return _collectionView;
    
}
- (id)initWithFrame:(CGRect)frame UpdateFrame:(JXTagsFrameUpdateBlock)updateFrame  completion:(JXTagsSelectedCompletion)completion{
    
    if (self = [super initWithFrame:frame]) {
        [self setup];
        self.tagsFrameUpdateBlock = updateFrame;
        self.completion = completion;
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    
    return self;
}



- (void)setup
{
    //初始化样式
    _tagAttribute = [[JXTagsAttribute alloc]init];
    
    _layout = [[JXTagsCollectionViewFlowLayout alloc] init];
    
    _scaleTagInSort = 1.2;
    
    /// ====>>> iOS9方法
//    _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(lonePressMoving:)];
//    [self.collectionView addGestureRecognizer:_longPress];
    [self addSubview:self.collectionView];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
    
}

#pragma mark - setter
- (void)setScaleTagInSort:(CGFloat)scaleTagInSort
{
    if (_scaleTagInSort < 1) {
        @throw [NSException exceptionWithName:@"JXTagsError" reason:@"(scaleTagInSort)缩放比例必须大于1" userInfo:nil];
    }
    _scaleTagInSort = scaleTagInSort;
    
}




#pragma mark - **** 长按手势
- (void)longPressAction:(UILongPressGestureRecognizer *)longPress {
    
    JXTagsCollectionViewCell *cell = (JXTagsCollectionViewCell *)longPress.view;
    
    [UIView animateWithDuration:-.25 animations:^{
        cell.transform = CGAffineTransformMakeScale(_scaleTagInSort, _scaleTagInSort);
    }];
    
    NSIndexPath *cellIndexpath = [self.collectionView indexPathForCell:cell];
    
    [self.collectionView bringSubviewToFront:cell];
    
    _isChange = NO;
    
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan: {
            [self.cellAttributesArray removeAllObjects];
            for (int i = 0; i < self.tagsArray.count; i++) {
                
                [self.cellAttributesArray addObject:[self.collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]]];
            }
            
        }
            
            break;
            
        case UIGestureRecognizerStateChanged: {
            
            cell.center = [longPress locationInView:self.collectionView];
            
            for (UICollectionViewLayoutAttributes *attributes in self.cellAttributesArray) {
                
                if (CGRectContainsPoint(attributes.frame, cell.center) && cellIndexpath != attributes.indexPath) {
                    _isChange = YES;
                    NSString *tagString = self.tagsArray[cellIndexpath.row];
                    NSMutableArray *tmpArray = [[NSMutableArray alloc]initWithArray:self.tagsArray];
                    
                    [tmpArray removeObjectAtIndex:cellIndexpath.row];
                    [tmpArray insertObject:tagString atIndex:attributes.indexPath.row];
                    
                    self.tagsArray = tmpArray;
                    
                    [self.collectionView moveItemAtIndexPath:cellIndexpath toIndexPath:attributes.indexPath];
                    
                    
                    /// 更新Frame
                    if (self.tagsFrameUpdateBlock) {
                        self.tagsFrameUpdateBlock([JXTagsView getHeightWithTags:self.tagsArray layout:_layout tagAttribute:_tagAttribute maxWidth:MaxWidth]);
                    }
                }
            }
            
        }
            
            break;
            
        case UIGestureRecognizerStateEnded: {
            
            if (!_isChange) {
                cell.center = [_collectionView layoutAttributesForItemAtIndexPath:cellIndexpath].center;
                [UIView animateWithDuration:-.25 animations:^{
                    cell.transform = CGAffineTransformIdentity;
                }];
            }
        }
            
            break;
            
        default:
            break;
    }
    
}

/// ====>>> iOS9方法
/*！
#pragma mark - Actions
- (void)lonePressMoving:(UILongPressGestureRecognizer *)longPress{
    
    
    switch (_longPress.state) {
        case UIGestureRecognizerStateBegan: {
            {
                NSIndexPath *selectIndexPath = [self.collectionView indexPathForItemAtPoint:[_longPress locationInView:self.collectionView]];
                
                // 开始移动的时候调用此方法，可以获取相应的数据源方法设置特殊的indexpath能否移动，如果能移动返回的是YES，不能移动返回的是NO
                [self.collectionView beginInteractiveMovementForItemAtIndexPath:selectIndexPath];
                
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            
            // 更新移动过程的位置
            [self.collectionView updateInteractiveMovementTargetPosition:[longPress locationInView:_longPress.view]];
            break;
        }
            
        case UIGestureRecognizerStateEnded: {
            
            // 结束移动的时候调用此方法，collectionView会响应相应的数据源方法，collectionView：moveItemAtIndexPath：toIndexPath：我们可以在这个方法中将移动的数据源，与目标数据源交互位置。
            [self.collectionView endInteractiveMovement];
            
            break;
        }
            
        default:{
            // 取消移动的时候调用，会返回最原始的位置。
            [self.collectionView cancelInteractiveMovement];
            
        }
            break;
    }
}*/

#pragma mark - 移动方法
/// ====>>> iOS9方法
/*！
// 在开始移动时会调用此代理方法，
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
     //根据indexpath判断单元格是否可以移动，如果都可以移动，直接就返回YES ,不能移动的返回NO
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath toIndexPath:(nonnull NSIndexPath *)destinationIndexPath
{
    // 1.调整数据源数据
    NSMutableArray *tags = [[NSMutableArray alloc]initWithArray:self.tagsArray];
    
    [tags exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
    NSLog(@"sourceIndexPath == %ld,destinationIndexPath == %ld",sourceIndexPath.item,destinationIndexPath.item);
    
    _tagsArray = tags;
    
    // 2.刷新
    [self.collectionView reloadData];
}

*/


#pragma mark - UICollectionViewDelegate | UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _tagsArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JXTagsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = _tagAttribute.normalBackgroundColor;
    cell.layer.borderColor = _tagAttribute.borderColor.CGColor;
    cell.layer.cornerRadius = _tagAttribute.cornerRadius;
    cell.layer.borderWidth = _tagAttribute.borderWidth;
    cell.titleLabel.textColor = _tagAttribute.normalTextColor;
    cell.titleLabel.font = [UIFont systemFontOfSize:_tagAttribute.titleSize];
    cell.titleLabel.text = self.tagsArray[indexPath.row];
    
    
    NSString *title = self.tagsArray[indexPath.item];
    
    cell.titleLabel.text = title;
    
    
    if ([self.selectedTags containsObject:self.tagsArray[indexPath.item]]) {
        cell.backgroundColor = _tagAttribute.selectedBackgroundColor;
    }
    
    
    // 是否排序
    if (_isSort) {
        //为每个cell 添加长按手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        [cell addGestureRecognizer:longPress];
        
    }
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    JXTagsCollectionViewCell *cell = (JXTagsCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if ([self.selectedTags containsObject:self.tagsArray[indexPath.item]]) {
        cell.backgroundColor = _tagAttribute.normalBackgroundColor;
        [self.selectedTags removeObject:self.tagsArray[indexPath.item]];
    }
    
    else {
        if (_isMultiSelect) {
            cell.backgroundColor = _tagAttribute.selectedBackgroundColor;
            [self.selectedTags addObject:self.tagsArray[indexPath.item]];
            
        } else {
            [self.selectedTags removeAllObjects];
            [self.selectedTags addObject:self.tagsArray[indexPath.item]];
            
            [self reloadData];
        }
    }
    
    if (self.completion) {
        self.completion(self.selectedTags,indexPath.item);
    }
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JXTagsCollectionViewFlowLayout *layout = (JXTagsCollectionViewFlowLayout *)collectionView.collectionViewLayout;
    CGSize maxSize = CGSizeMake(collectionView.frame.size.width - layout.sectionInset.left - layout.sectionInset.right, layout.itemSize.height);
    
    CGRect frame = [_tagsArray[indexPath.item] boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:_tagAttribute.titleSize]} context:nil];
    
    return CGSizeMake(frame.size.width + _tagAttribute.tagPadding * 2, layout.itemSize.height);
}



#pragma mark - public Method
- (void)reloadData{
    [self.collectionView reloadData];
    
}

/**
 计算tagsView的高度
 
 @param tagsArray 标签数组
 @param layout 布局
 @param tagAttribute 样式属性
 @param maxWidth 最大宽度
 */
+ (CGFloat)getHeightWithTags:(NSArray <NSString *>*)tagsArray layout:(JXTagsCollectionViewFlowLayout *)layout tagAttribute:(JXTagsAttribute *)tagAttribute maxWidth:(CGFloat)maxWidth{
    
    MaxWidth = maxWidth;
    
    CGFloat contentHeight;
    
    if (!layout) {
        layout = [[JXTagsCollectionViewFlowLayout alloc] init];
    }
    
    if (tagAttribute.titleSize <= 0) {
        tagAttribute = [[JXTagsAttribute alloc] init];
    }
    
    if (maxWidth == 0) {
        @throw [NSException exceptionWithName:@"JXTagsError" reason:@"设置标签的最大宽度" userInfo:nil];
    }
    
    
    //cell的高度 = 顶部 + 高度
    contentHeight = layout.sectionInset.top + layout.itemSize.height;
    
    CGFloat originX = layout.sectionInset.left;
    CGFloat originY = layout.sectionInset.top;
    
    NSInteger itemCount = tagsArray.count;
    
    for (NSInteger i = 0; i < itemCount; i++) {
        CGSize maxSize = CGSizeMake(maxWidth - layout.sectionInset.left - layout.sectionInset.right, layout.itemSize.height);
        
        CGRect frame = [tagsArray[i] boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:tagAttribute.titleSize]} context:nil];
        
        CGSize itemSize = CGSizeMake(frame.size.width + tagAttribute.tagPadding * 2, layout.itemSize.height);
        
        if (layout.scrollDirection == UICollectionViewScrollDirectionVertical) {
            //垂直滚动
            //当前CollectionViewCell的起点 + 当前CollectionViewCell的宽度 + 当前CollectionView距离右侧的间隔 > collectionView的宽度
            if ((originX + itemSize.width + layout.sectionInset.right) > maxWidth) {
                originX = layout.sectionInset.left;
                originY += itemSize.height + layout.minimumLineSpacing;
                
                contentHeight += itemSize.height + layout.minimumLineSpacing;
            }
        }
        
        originX += itemSize.width + layout.minimumInteritemSpacing;
    }
    
    contentHeight += layout.sectionInset.bottom;
    
    
    
    return contentHeight;

}


@end

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


static NSString * const reuseIdentifier = @"JXTagsCollectionViewCellId";

@interface JXTagsView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
/// ====>>> iOS9方法
//@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;

@property (nonatomic,assign)BOOL isChange;
@property (nonatomic,strong)NSMutableArray *cellAttributesArray;

@property (nonatomic, strong) NSMutableArray <NSNumber *>*selectedTags;
@property (nonatomic, strong) JXTagsCollectionViewFlowLayout *layout;
@property (nonatomic, assign) CGFloat collectionViewHeight; // 记录高度
@property (nonatomic, assign) CGFloat maxWidth; // 记录最大宽度
@end

@implementation JXTagsView

#pragma mark - lazy load
- (JXTagsCollectionViewFlowLayout *)layout{
    if (_layout == nil) {
        _layout = [[JXTagsCollectionViewFlowLayout alloc]init];
        _layout.scrollDirection = _scrollDirection;
    }
    return _layout;
}

- (NSMutableArray<NSNumber *> *)selectedTags{
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
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollsToTop = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[JXTagsCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    }
    
    
    if (_scrollDirection == UICollectionViewScrollDirectionVertical) {
        //垂直
        _collectionView.showsVerticalScrollIndicator = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
    } else {
        _collectionView.showsHorizontalScrollIndicator = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
    }
    
    
    return _collectionView;
    
}

- (instancetype)initWithFrame:(CGRect)frame
                         Tags:(NSArray <NSString *>*)tags
                 TagAttribute:(JXTagsAttribute *)tagAttribute
                  UpdateFrame:(JXTagsFrameUpdateBlock)updateFrame
                   completion:(JXTagsSelectedCompletion)completion{
    
    if (self = [super initWithFrame:frame]) {
        self.tagsArray = tags;
        self.tagAttribute = tagAttribute;
        self.tagsFrameUpdateBlock = updateFrame;
        self.completion = completion;
        [self setup];
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
    if(_tagAttribute == nil) _tagAttribute = [[JXTagsAttribute alloc]init];
    _scaleTagInSort = 1.2;
    
    /// ====>>> iOS9方法
//    _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(lonePressMoving:)];
//    [self.collectionView addGestureRecognizer:_longPress];
    [self addSubview:self.collectionView];
   
}



- (void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"layoutsubViews ---- ");
    self.collectionView.frame = self.bounds;
    
    
    
}

#pragma mark - setter
- (void)setScaleTagInSort:(CGFloat)scaleTagInSort
{
    if (_scaleTagInSort <= 1) {
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
            _collectionViewHeight = CGRectGetHeight(self.collectionView.frame);
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
                    /// 改变数据源
                    NSMutableArray *tmpArray = [[NSMutableArray alloc]initWithArray:self.tagsArray];
                    [tmpArray removeObjectAtIndex:cellIndexpath.row];
                    [tmpArray insertObject:tagString atIndex:attributes.indexPath.row];
                    
                    self.tagsArray = tmpArray;
                    
                    [self.collectionView moveItemAtIndexPath:cellIndexpath toIndexPath:attributes.indexPath];
                    
                    /// 更新Frame
                    CGFloat height = [self getHeightWithMaxWidth:_maxWidth];
                    if (self.tagsFrameUpdateBlock && _collectionViewHeight != height) {
                        self.tagsFrameUpdateBlock(height);
                        _collectionViewHeight = height;
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
    cell.attribute = _tagAttribute;
    cell.layer.borderColor = _tagAttribute.borderColor.CGColor;
    cell.layer.cornerRadius = _tagAttribute.isShowCorner ? self.layout.itemSize.height * 0.5 : _tagAttribute.cornerRadius;
    cell.layer.masksToBounds = YES;
    cell.layer.borderWidth = _tagAttribute.borderWidth;
    cell.titleLabel.textColor = _tagAttribute.normalTextColor;
    
    NSString *title = self.tagsArray[indexPath.item];
    cell.titleLabel.text = title;
    
    
    if ([self.selectedTags containsObject:@(indexPath.item)]) {
        cell.contentView.backgroundColor = _tagAttribute.selectedBackgroundColor;
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
    
    if (_isMultiSelect && [self.selectedTags containsObject:@(indexPath.item)]) {
        cell.contentView.backgroundColor = _tagAttribute.normalBackgroundColor;
        [self.selectedTags removeObject:@(indexPath.item)];
    }
    
    else {
        if (_isMultiSelect) {
            cell.contentView.backgroundColor = _tagAttribute.selectedBackgroundColor;
            [self.selectedTags addObject:@(indexPath.item)];
            
        } else {
            [self.selectedTags removeAllObjects];
            [self.selectedTags addObject:@(indexPath.item)];
            
            [self reloadData];
        }
    }
    
    if (self.completion) {
        self.completion(self.selectedTags,self.tagsArray);
    }
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JXTagsCollectionViewFlowLayout *layout = (JXTagsCollectionViewFlowLayout *)collectionView.collectionViewLayout;
    CGSize maxSize = CGSizeMake(collectionView.frame.size.width - layout.sectionInset.left - layout.sectionInset.right, layout.itemSize.height);
    
    CGRect frame = [_tagsArray[indexPath.item] boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: _tagAttribute.titleFont} context:nil];
    
    CGFloat horizontalMargin = _tagAttribute.edgeInsets.right + _tagAttribute.edgeInsets.left;
    CGFloat verticalMargin = _tagAttribute.edgeInsets.top + _tagAttribute.edgeInsets.bottom;
    
    CGSize size = CGSizeMake(frame.size.width + horizontalMargin, ceilf(frame.size.height) + verticalMargin);
    
    return size;
}


// 刷新数据
- (void)reloadData{
    [self.collectionView reloadData];
}


/**
 计算tagsView的高度
 */
- (CGFloat)getHeightWithMaxWidth:(CGFloat)maxWidth{
    NSAssert(maxWidth > 0, @"'maxWidth'不能小于0");
    
    _maxWidth = maxWidth;
    
    CGFloat contentHeight;
    
    if (self.tagsArray.count == 0) {
        @throw [NSException exceptionWithName:@"JXTagsError" reason:@"请先设置'tagsArray'，才能计算高度" userInfo:nil];
    }
    
    if (self.tagAttribute == nil) {
        @throw [NSException exceptionWithName:@"JXTagsError" reason:@"请先设置'tagAttribute'属性，才能计算高度" userInfo:nil];
    }
    
    
    
    //cell的高度 = 顶部 + 高度
    contentHeight = self.layout.sectionInset.top + self.layout.itemSize.height;
    
    CGFloat originX = self.layout.sectionInset.left;
    CGFloat originY = self.layout.sectionInset.top;
    
    NSInteger itemCount = self.tagsArray.count;
    
    for (NSInteger i = 0; i < itemCount; i++) {
        CGSize maxSize = CGSizeMake(maxWidth - self.layout.sectionInset.left - self.layout.sectionInset.right, self.layout.itemSize.height);
        //// >>>> 注意!!!!!
        // 由于计算出来的值比实际需要的值略小，故需要对其向上取整，这样子获取的高度才是我们所需要的。
        CGRect frame = [self.tagsArray[i] boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.tagAttribute.titleFont} context:nil];
        
        CGFloat horizontalMargin = _tagAttribute.edgeInsets.right + _tagAttribute.edgeInsets.left;
        CGFloat verticalMargin = _tagAttribute.edgeInsets.top + _tagAttribute.edgeInsets.bottom;
        CGSize itemSize = CGSizeMake(frame.size.width + horizontalMargin, ceilf(frame.size.height) + verticalMargin);
        
        if (self.layout.scrollDirection == UICollectionViewScrollDirectionVertical) {
            //垂直滚动
            //当前CollectionViewCell的起点 + 当前CollectionViewCell的宽度 + 当前CollectionView距离右侧的间隔 > collectionView的宽度
            if ((originX + itemSize.width + self.layout.sectionInset.right) > maxWidth) {
                originX = self.layout.sectionInset.left;
                originY += itemSize.height + self.layout.minimumLineSpacing;
                
                contentHeight += itemSize.height + self.layout.minimumLineSpacing;
            }
        }
        
        originX += itemSize.width + self.layout.minimumInteritemSpacing;
    }
    
    contentHeight += self.layout.sectionInset.bottom;
    
    
    return contentHeight;

}


@end

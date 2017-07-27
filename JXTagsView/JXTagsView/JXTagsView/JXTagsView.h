//
//  JXTagsView.h
//  JXTagsView
//
//  Created by mac on 17/7/27.
//  Copyright © 2017年 JXIcon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXTagsCollectionViewFlowLayout.h"
#import "JXTagsAttribute.h"

typedef void(^JXTagsSelectedCompletion)(NSArray <NSString *>*,NSInteger);
typedef void(^JXTagsFrameUpdateBlock)(CGFloat currentHeight);



@interface JXTagsView : UIView

/** 传入的字符数组*/
@property (nonatomic, strong)NSArray <NSString *>* tagsArray;
@property (nonatomic,strong) JXTagsCollectionViewFlowLayout *layout;//布局layout

/*！标签样式 */
@property (nonatomic,strong) JXTagsAttribute *tagAttribute;

@property (nonatomic,assign) BOOL isMultiSelect;//是否可以多选 默认:NO 单选

// ======= >>>>>>>> Block
/**! 更新frameBlock */
@property(nonatomic, copy) JXTagsFrameUpdateBlock tagsFrameUpdateBlock;
@property (nonatomic,copy) JXTagsSelectedCompletion completion;//选中的标签数组,当前点击的index


// ======= >>>>>>>> 排序
/**
 *  是否需要排序功能
 */
@property (nonatomic, assign) BOOL isSort;
/**
 *  在排序的时候，放大标签的比例，必须大于1  默认1.5
 */
@property (nonatomic, assign) CGFloat scaleTagInSort;



/**
 便利构建方法

 @param frame frame
 @param updateFrame frame改变回调
 @param completion  选择回调
 */
- (id)initWithFrame:(CGRect)frame UpdateFrame:(JXTagsFrameUpdateBlock)updateFrame  completion:(JXTagsSelectedCompletion)completion;

//刷新界面
- (void)reloadData;



/**
 计算tagsView的高度

 @param tagsArray 标签数组
 @param layout 布局  可以传nil 默认布局
 @param tagAttribute 样式属性 可以传nil 默认样式
 @param maxWidth 最大宽度
 */
+ (CGFloat)getHeightWithTags:(NSArray <NSString *>*)tagsArray layout:(JXTagsCollectionViewFlowLayout *)layout tagAttribute:(JXTagsAttribute *)tagAttribute maxWidth:(CGFloat)maxWidth;

@end

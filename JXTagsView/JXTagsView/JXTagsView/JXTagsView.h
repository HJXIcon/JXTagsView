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

/// 选中数组，改变之后的标签数组
typedef void(^JXTagsSelectedCompletion)(NSArray <NSNumber *>*,NSArray <NSString *>*);
typedef void(^JXTagsFrameUpdateBlock)(CGFloat currentHeight);



@interface JXTagsView : UIView

/** 传入的字符数组*/
@property (nonatomic, strong)NSArray <NSString *>* tagsArray;
/*！标签样式 */
@property (nonatomic,strong) JXTagsAttribute *tagAttribute;
/**
 默认垂直方向
 */
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

@property (nonatomic,assign) BOOL isMultiSelect;//是否可以多选 默认:NO 单选

// ======= >>>>>>>> Block
/**! 更新frameBlock */
@property(nonatomic, copy) JXTagsFrameUpdateBlock tagsFrameUpdateBlock; // >>> 只有tags支持拖拽排序并且拖拽之后才会调用

@property (nonatomic,copy) JXTagsSelectedCompletion completion;//选中的标签数组,当前点击的index


// ======= >>>>>>>> 排序
/**
 *  是否需要排序功能  默认NO
 */
@property (nonatomic, assign) BOOL isSort;
/**
 *  在排序的时候，放大标签的比例，必须大于1  默认1.5
 */
@property (nonatomic, assign) CGFloat scaleTagInSort;


/**
 便利构造方法
 
 @param tags 标签数组
 @param tagAttribute 标签样式属性 可以传nil 默认样式
 @param updateFrame 更新frame的Block
 @param completion 选中回调Block
 */
- (instancetype)initWithFrame:(CGRect)frame
                         Tags:(NSArray <NSString *>*)tags
                 TagAttribute:(JXTagsAttribute *)tagAttribute
                  UpdateFrame:(JXTagsFrameUpdateBlock)updateFrame
                   completion:(JXTagsSelectedCompletion)completion;


// ======= >>>>>>>> 想让标签全部显示出来，不滚动
/**
 计算tagsView的高度
 */

- (CGFloat)getHeightWithMaxWidth:(CGFloat)maxWidth;

@end

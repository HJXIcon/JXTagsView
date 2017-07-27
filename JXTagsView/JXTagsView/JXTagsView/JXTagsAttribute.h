//
//  JXTagsAttribute.h
//  JXTagsView
//
//  Created by mac on 17/7/27.
//  Copyright © 2017年 JXIcon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 标签的属性
 */
@interface JXTagsAttribute : NSObject
/// =======>>>>>  border
@property (nonatomic,assign) CGFloat borderWidth;//标签边框宽度  默认0.5
@property (nonatomic,strong) UIColor *borderColor;//标签边框颜色
@property (nonatomic,assign) CGFloat cornerRadius;//标签圆角大小 默认2.0

/// =======>>>>>  color
@property (nonatomic,strong) UIColor *normalBackgroundColor;//标签默认背景颜色  默认白色
@property (nonatomic,strong) UIColor *selectedBackgroundColor;//标签选中背景颜色
@property (nonatomic,strong) UIColor *normalTextColor;//标签默认字体颜色
@property (nonatomic,strong) UIColor *selectedTextColor;//标签选中字体颜色 默认白色
@property (nonatomic,strong) UIColor *keyColor;//搜索关键词颜色 默认red


/// =======>>>>>
@property (nonatomic,assign) CGFloat titleSize;//标签字体大小 默认14
@property (nonatomic,assign) CGFloat tagPadding ;//标签内部左右间距(标题距离边框2边的距离和) 默认是10


@end

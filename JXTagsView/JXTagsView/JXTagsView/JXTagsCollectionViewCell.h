//
//  JXTagsCollectionViewCell.h
//  JXTagsView
//
//  Created by mac on 17/7/27.
//  Copyright © 2017年 JXIcon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JXTagsAttribute;
@interface JXTagsCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic, strong) JXTagsAttribute *attribute;
@end

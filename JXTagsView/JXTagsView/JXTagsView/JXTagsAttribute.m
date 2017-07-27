//
//  JXTagsAttribute.m
//  JXTagsView
//
//  Created by mac on 17/7/27.
//  Copyright © 2017年 JXIcon. All rights reserved.
//

#import "JXTagsAttribute.h"

@implementation JXTagsAttribute

- (instancetype)init{
    if (self = [super init]) {
        
        int r = arc4random() % 255;
        int g = arc4random() % 255;
        int b = arc4random() % 255;
        
        UIColor *normalColor = [UIColor colorWithRed:b/255.0 green:r/255.0 blue:g/255.0 alpha:1.0];
        UIColor *normalBackgroundColor = [UIColor whiteColor];
        UIColor *selectedBackgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
        
        _borderWidth = 0.5f;
        _borderColor = normalColor;
        _cornerRadius = 2.0;
        _normalBackgroundColor = normalBackgroundColor;
        _selectedBackgroundColor = selectedBackgroundColor;
        _titleSize = 14;
        _normalTextColor = normalColor;
        _selectedTextColor = normalBackgroundColor;
        _keyColor = [UIColor redColor];
        _tagPadding = 10;
    }
    return self;
}
@end


//
//  LicenseButton.m
//  SwiftCustomKeyboard
//
//  Created by 123 on 2017/10/26.
//  Copyright © 2017年 codeIsMyGirl. All rights reserved.
//

#import "LicenseButton.h"

@implementation LicenseButton

+ (instancetype)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font backGroundColor:(UIColor *)backGroundColor
{
    LicenseButton *btn = [self buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = font;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setBackgroundColor:backGroundColor];
    return btn;
}


@end

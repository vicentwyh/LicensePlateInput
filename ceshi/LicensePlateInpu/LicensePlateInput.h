//
//  LicensePlateInputView.h
//  ePark
//
//  Created by 123 on 2017/10/26.
//  Copyright © 2017年 Zorasun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LicenseInputConfig.h"

@class LicenseKeyBoardView, LicenseInputTextModel;


@interface LicensePlateInput : UIView

/// 输入框配置
@property (nonatomic, strong) LicenseInputConfig *config;

@property (nonatomic, strong) LicenseKeyBoardView *keyBoard;

@property (nonatomic, copy) void(^inputComplete)(NSString *lisenseString);

// 选中位置改变时进行的操作
- (void)selectedChangeHander:(NSInteger)selectedIndex NS_REQUIRES_SUPER;
// 输入长度限制改变时进行的操作
- (void)maxLengthChangeHander NS_REQUIRES_SUPER;
// 字体改变时进行的操作
- (void)textFontChangeHander NS_REQUIRES_SUPER;
// 字体改变时进行的操作
- (void)textColorChangeHander NS_REQUIRES_SUPER;

// 结束输入
- (void)stopInput;
// 当前输入框的值
- (NSString *)currentLicenseString;
// 替换指定范围的字符串
- (void)replaceStringWithRage:(NSRange)range string:(NSString *)string;

@end


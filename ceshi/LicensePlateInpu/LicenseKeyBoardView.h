//
//  LicenseKeyBoardView.h
//  SwiftCustomKeyboard
//
//  Created by 123 on 2017/10/26.
//  Copyright © 2017年 codeIsMyGirl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LicenseKeyBoardViewDelegate <NSObject>

-(void)licenseKeyBoardViewDidPick:(NSInteger)index;

-(void)licenseKeyBoardViewDisMissed;


@end

@interface LicenseKeyBoardView : UIView

// 是否显示数字和英文字母键盘，默认为NO
@property (nonatomic, assign) BOOL showLetter;
// 不能选择的字符串
@property (nonatomic, strong) NSArray<NSString *> *invalidStrings;
// 除开头外所有字符
@property (nonatomic, strong) NSArray<NSString *> *allLetters;
// 所有开头字符
@property (nonatomic, strong) NSArray<NSString *> *allProvinces;

@property(weak,nonatomic) id<LicenseKeyBoardViewDelegate> delegate;

// 展示过程回调
@property (nonatomic, copy) void(^showProgerssBlock)(LicenseKeyBoardView *keyboard);

@property (nonatomic, copy) void(^doneActionBloack)();

- (void)showInView:(UIView *)view;

- (void)dismiss;

@end


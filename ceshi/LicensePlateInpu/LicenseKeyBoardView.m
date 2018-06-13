//
//  LicenseKeyBoardView.m
//  SwiftCustomKeyboard
//
//  Created by 123 on 2017/10/26.
//  Copyright © 2017年 codeIsMyGirl. All rights reserved.
//

#import "LicenseKeyBoardView.h"
#import "LicenseKeyBoardContentView.h"
#import "LicenseButton.h"
#import "LicenseKeyBoardLetterNumberView.h"

static CGFloat const sureViewHeight = 40.0;
#define iPhoneX   ([UIScreen mainScreen].bounds.size.width == 375 && [UIScreen mainScreen].bounds.size.height == 812)

@interface LicenseKeyBoardView ()
{
    BOOL _isLetterKeyBoard;
}

@property (nonatomic, strong) LicenseKeyBoardContentView *provinceContentView;
@property (nonatomic, strong) LicenseKeyBoardLetterNumberView *letterAndNumberContentView;
@property (nonatomic, weak) UIView *currentContentView;
@property (nonatomic, assign, getter=isSwitchingKeybaord) BOOL switchingKeybaord;
@property (nonatomic, weak) UIView *sureView;

@end

@implementation LicenseKeyBoardView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:208/255.0 green:212/255.0 blue:217/255.0 alpha:1.0];
        
        [self addSureAccessoryView];
    }
    return self;
}

- (void)addSureAccessoryView
{
    UIView *sureView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, sureViewHeight)];
    sureView.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1.0];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(CGRectGetWidth(sureView.frame)-10-50, 0, 50, CGRectGetHeight(sureView.frame));
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [sureView addSubview:btn];
    [self addSubview:sureView];
    _sureView = sureView;
}

- (void)sureAction
{
    _switchingKeybaord = NO;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LicenseDidDoneNotification" object:nil];
    
    if (_doneActionBloack) {
        _doneActionBloack();
    }
    
    [self dismiss];
}

- (void)setShowLetter:(BOOL)showLetter
{
    BOOL switchingKeybaord = NO;
    if (self.isFirstShow) {
        _showLetter = showLetter;
    } else {
        // 避免重复显示当前类型键盘操作
        if (_showLetter == showLetter)  return;
        _showLetter = showLetter;
        
        switchingKeybaord = YES;
        [_currentContentView removeFromSuperview];
    }
    _currentContentView = showLetter ? self.letterAndNumberContentView : self.provinceContentView;
    [self addSubview:_currentContentView];
    
    // adjust frame
    [self layoutIfNeeded];
    
    
    [self showInView:nil animate:!switchingKeybaord];
}

- (void)setInvalidStrings:(NSArray<NSString *> *)invalidStrings
{
    _invalidStrings = invalidStrings;
    
    [_currentContentView setValue:invalidStrings forKey:@"invalidStrings"];
}

- (BOOL)isFirstShow
{
    return self.superview == nil;
}

#pragma mark - 显示
- (void)showInView:(UIView *)view animate:(BOOL)animate
{
    if (self.isFirstShow) {
        if (view == nil) {
            view = [self getWindow];
        }
        [view addSubview:self];
        self.frame = CGRectMake(0, CGRectGetHeight(view.frame), CGRectGetWidth(view.frame), self.frame.size.height);
    }
    
    CGFloat translationY = CGRectGetHeight(self.frame);
    if (iPhoneX) {
        translationY += 34;
    }
    if (animate) {
        [UIView animateWithDuration:0.25 animations:^{
            self.transform = CGAffineTransformMakeTranslation(0, -translationY);
        } completion:NULL];
    } else {
        self.transform = CGAffineTransformMakeTranslation(0, -translationY);
    }
    
    if (_showProgerssBlock) {
        _showProgerssBlock(self);
    }
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.frame;
    frame.size.height = _currentContentView.frame.size.height + _sureView.frame.size.height;
    self.frame = frame;
}


- (UIWindow *)getWindow
{
    NSArray *windows = [UIApplication sharedApplication].windows;
    for (UIWindow *window in windows.reverseObjectEnumerator) {
        if (CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds) && !window.hidden) {
            return window;
        }
    }
    return [UIApplication sharedApplication].keyWindow;
}

- (LicenseKeyBoardContentView *)provinceContentView
{
    if (!_provinceContentView) {
        _provinceContentView = [[LicenseKeyBoardContentView alloc] initWithFrame:CGRectMake(0, sureViewHeight, [UIScreen mainScreen].bounds.size.width, 290 - sureViewHeight)];
        _provinceContentView.allProvinces = _allProvinces;
        
    }
    return _provinceContentView;
}

- (LicenseKeyBoardLetterNumberView *)letterAndNumberContentView
{
    if (!_letterAndNumberContentView) {
        _letterAndNumberContentView = [[LicenseKeyBoardLetterNumberView alloc] initWithFrame:CGRectMake(0, sureViewHeight, [UIScreen mainScreen].bounds.size.width, 330 - sureViewHeight)];
        _letterAndNumberContentView.allLetters = _allLetters;
        
    }
    return _letterAndNumberContentView;
}


@end


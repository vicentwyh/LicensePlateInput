//
//  LicenceNumberCell.m
//  SwiftCustomKeyboard
//
//  Created by 123 on 2017/10/26.
//  Copyright © 2017年 codeIsMyGirl. All rights reserved.
//

#import "LicenceNumberCell.h"

@interface LicenceNumberCell ()

@property (nonatomic, weak) UIButton *licenseBtn;

@end

@implementation LicenceNumberCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self initSubView];
        
    }
    return self;
}

- (void)initSubView
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = self.contentView.bounds;
    btn.titleLabel.font = [UIFont systemFontOfSize:20];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn setTitleColor:[UIColor  blackColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"carNum_normal"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"carNum_high"] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage imageNamed:@"carNum_high"] forState:UIControlStateDisabled];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    _licenseBtn = btn;
}

- (void)btnClick:(UIButton *)btn
{
    if (_btnClickBlock) {
        _btnClickBlock(btn.currentTitle);
    }
}

- (void)setLicenseNum:(NSString *)licenseNum
{
    _licenseNum = [licenseNum copy];
    
    [_licenseBtn setTitle:licenseNum forState:UIControlStateNormal];
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled
{
    [super setUserInteractionEnabled:userInteractionEnabled];
    
    self.licenseBtn.enabled = userInteractionEnabled ;
}

@end

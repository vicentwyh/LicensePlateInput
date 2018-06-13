//
//  LicenseKeyBoardContentView.h
//  CarLicence
//
//  Created by 123 on 2017/10/26.
//  Copyright © 2017年 李挺哲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LicenseKeyBoardContentView : UIView

// 不能选择的字符串
@property (nonatomic, strong) NSArray<NSString *> *invalidStrings;
// 所有字符
@property (nonatomic, strong) NSArray<NSString *> *allProvinces;
@end

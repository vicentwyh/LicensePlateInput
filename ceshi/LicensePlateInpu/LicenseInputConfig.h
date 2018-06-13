//
//  LicenseInputConfig.h
//  ePark
//
//  Created by 123 on 2018/5/15.
//  Copyright © 2018年 Zorasun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LicenseInputTextModel.h"
@class LicensePlateInput;

@interface LicenseInputConfig : NSObject

// 各个输入框数据模型
@property (nonatomic, strong) NSArray<LicenseInputTextModel *> *TextArrays;
// 车牌号输入位数，默认为7
@property (nonatomic, assign) NSInteger maxLength;
// 选中位置
@property (nonatomic, assign) NSInteger selectedIndex;
/**
 设置车牌号指定位置的输入不能选择的值
 例如：第二个输入框不能输入I  invalid[@"1"] = @[@"I"];
 */
@property (nonatomic, strong) NSDictionary<NSString *, NSArray<NSString *> *> *invalid;
/*
 除开头外所有字符，默认值为
 @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"Q",@"W",@"E",@"R",@"T",@"Y",@"U",@"I",@"O",@"P",@"A",@"S",@"D",@"F",@"G",@"H",@"J",@"K",@"L",@"Z",@"X",@"C",@"V",@"B",@"N",@"M",@"学",@"警",@"港",@"澳",@"领", @"电"]
 */
@property (nonatomic, strong) NSArray<NSString *> *allLetters;
/*
 所有开头字符，默认值为
 @[@"京",@"沪",@"津",@"渝",@"黑",@"吉",@"辽",@"蒙",@"冀",@"新",@"甘",@"青",@"陕",@"宁",@"云",@"豫",@"鲁",@"晋",@"皖", @"鄂",@"湘",@"苏",@"川", @"贵",@"桂",@"藏",@"浙", @"赣", @"粤", @"闽", @"台", @"琼", @"港"]
 */
@property (nonatomic, strong) NSArray<NSString *> *allProvinces;

/// 初始化
+ (instancetype)configWithInputView:(LicensePlateInput *)inputView;


/// 替换相应位置的字符串
- (void)replaceStringWithRage:(NSRange)range string:(NSString *)string;
/// 添加字符串
- (void)addString:(NSString *)string;
/// 删除字符串
- (void)deleteWithString:(NSString *)string;

- (NSString *)currentLicenseString;

@end

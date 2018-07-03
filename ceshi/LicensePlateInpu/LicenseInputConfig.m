//
//  LicenseInputConfig.m
//  ePark
//
//  Created by 123 on 2018/5/15.
//  Copyright © 2018年 Zorasun. All rights reserved.
//

#import "LicenseInputConfig.h"
#import "LicensePlateInput.h"

typedef NS_ENUM(NSUInteger, CapacityChangeType) {
    CapacityChangeTypeExpand, // 扩充
    CapacityChangeTypeReduce  // 减小
};


@interface LicenseInputConfig ()

@property (nonatomic, weak) LicensePlateInput *inputView;

@end

@implementation LicenseInputConfig

+ (instancetype)configWithInputView:(LicensePlateInput *)inputView
{
    return [[self alloc] initWithInputView:inputView];
}

- (instancetype)initWithInputView:(LicensePlateInput *)inputView
{
    if (self = [super init]) {
        
        _inputView = inputView;
        [self initializeData];
    }
    return self;
}

- (void)initializeData
{
    _selectedIndex = -1;
    _maxLength = 7;
    _textFont = [UIFont systemFontOfSize:20];
}

- (void)replaceStringWithRage:(NSRange)range string:(NSString *)string
{
    NSParameterAssert(range.length == string.length);
    NSParameterAssert((range.location+range.length) <= (_maxLength-1));
    
    for (int i = (int)range.location; i <= range.location+range.length-1; i++) {
        LicenseInputTextModel *model = self.TextArrays[i];
        model.text = [string substringWithRange:NSMakeRange(i - range.location, 1)];
    }
}

- (void)addString:(NSString *)string
{
    NSInteger selectedIndex = _selectedIndex;
    LicenseInputTextModel *currentModel = self.TextArrays[selectedIndex];
    currentModel.text = string;
    selectedIndex++;
    if (selectedIndex >= self.TextArrays.count) {
        selectedIndex = self.TextArrays.count - 1;
    }
    self.selectedIndex = selectedIndex;
}

- (void)deleteWithString:(NSString *)string
{
    __block NSInteger selectedIndex = _selectedIndex;
    [self.TextArrays enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(LicenseInputTextModel * _Nonnull textModel, NSUInteger idx, BOOL * _Nonnull stop) {
        if (textModel.text != nil) {
            textModel.text = nil;
            selectedIndex = idx;
            
            *stop = YES;
        }
    }];
    self.selectedIndex = selectedIndex;
}

- (NSString *)currentLicenseString
{
    NSMutableString *lisence = [NSMutableString stringWithString:@""];
    
    for (LicenseInputTextModel *element in self.TextArrays) {
        if (element.text == nil) break;
        
        [lisence appendString:element.text];
    }
    return lisence;
}

- (void)changeCapacityWithType:(CapacityChangeType)type delta:(NSUInteger)delta
{
    if (type == CapacityChangeTypeExpand) {
        NSMutableArray *newTexts = [NSMutableArray arrayWithCapacity:delta];
        for (int i = 0; i < delta; i++) {
            LicenseInputTextModel *model = [LicenseInputTextModel new];
            [newTexts addObject:model];
        }
        self.TextArrays = [self.TextArrays arrayByAddingObjectsFromArray:newTexts];
    } else {
        NSUInteger count = self.TextArrays.count;
        self.TextArrays = [self.TextArrays subarrayWithRange:NSMakeRange(0, count-delta)];
    }
    
    [self.inputView maxLengthChangeHander];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    
    [self.inputView selectedChangeHander:selectedIndex];
}

- (void)setMaxLength:(NSInteger)maxLength
{
    if (_maxLength == maxLength) return;

    NSUInteger delta = labs(_maxLength - maxLength);
    CapacityChangeType type = maxLength > _maxLength ? CapacityChangeTypeExpand : CapacityChangeTypeReduce;
    [self changeCapacityWithType:type delta:delta];
    
    _maxLength = maxLength;
}

- (void)setTextFont:(UIFont *)textFont
{
    _textFont = textFont;
    
    [self.inputView textFontChangeHander];
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    
    [self.inputView textColorChangeHander];
}

- (NSArray<LicenseInputTextModel *> *)TextArrays
{
    if (!_TextArrays) {
        NSMutableArray *allText = [NSMutableArray arrayWithCapacity:_maxLength];
        for (int i = 0; i < _maxLength; i++) {
            LicenseInputTextModel *model = [LicenseInputTextModel new];
            [allText addObject:model];
        }
        _TextArrays = (NSArray *)allText;
    }
    return _TextArrays;
}

@end

//
//  LicensePlateInputView.m
//  ePark
//
//  Created by 123 on 2017/10/26.
//  Copyright © 2017年 Zorasun. All rights reserved.
//

#import "LicensePlateInput.h"
#import "licenseInputCell.h"
#import "LicenseInputTextModel.h"
#import "LicenseKeyBoardView.h"

typedef NS_ENUM(NSUInteger, InputTextChangeType) {
    InputTextChangeTypeAdd,
    InputTextChangeTypeDelete,
    InputTextChangeTypeConfirm,
};

@interface LicensePlateInput ()<UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

// 车牌号码展示
@property (nonatomic, weak) UICollectionView *collectionView;

@end

@implementation LicensePlateInput

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self prepare];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self prepare];
}

#pragma mark - Initialize
- (void)prepare
{
    [self initSubViews];
    
    [self addObserser];
}

- (void)addObserser
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(licenseDidSelect:) name:@"LicenseDidSelectNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(licenseDidDelete:) name:@"LicenseDidDeleteNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(licenseDidDone:) name:@"LicenseDidDoneNotification" object:nil];
}


- (void)initSubViews
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 5;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.pagingEnabled = YES;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    [collectionView registerClass:licenseInputCell.class forCellWithReuseIdentifier:NSStringFromClass(licenseInputCell.class)];
    [self addSubview:collectionView];
    _collectionView = collectionView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
}

#pragma mark - 键盘点击操作
- (void)licenseDidSelect:(NSNotification *)notification
{
    NSString *text = notification.userInfo[@"license"];
    [self changeInputTextWithType:InputTextChangeTypeAdd string:text];
}

- (void)licenseDidDelete:(NSNotification *)notification
{
    [self changeInputTextWithType:InputTextChangeTypeDelete string:nil];
}

- (void)licenseDidDone:(NSNotification *)notification
{
    [self endEditingToFill:YES];
}

- (void)changeInputTextWithType:(InputTextChangeType)type string:(NSString *)string
{
    if (type == InputTextChangeTypeAdd) {
        
        [self addString:string];
        
    } else if (type == InputTextChangeTypeDelete) {
        
        [self deleteWithString:string];
    }
}

#pragma mark - 替换、添加、删除输入内容
- (void)replaceStringWithRage:(NSRange)range string:(NSString *)string
{
    [self.config replaceStringWithRage:range string:string];
}

- (void)addString:(NSString *)string
{
    [self.config addString:string];
}

- (void)deleteWithString:(NSString *)string
{
    [self.config deleteWithString:string];
}

- (BOOL)isEditing
{
    return self.config.selectedIndex != -1;
}

- (BOOL)isLastSelectdeIndexExist
{
    return self.config.selectedIndex > -1 && self.config.selectedIndex < self.config.maxLength;
}

#pragma mark - 替换键盘类型
- (void)showLetterAndNumberKeyBoard:(NSInteger)selectedIndex
{
    if (self.keyBoard) {
        BOOL force = selectedIndex > 0;
        self.keyBoard.showLetter = force;
        
        NSString *index = [NSString stringWithFormat:@"%zd",selectedIndex];
        self.keyBoard.invalidStrings = self.config.invalid[index];
    }
}

#pragma mark - 结束编辑
- (void)stopInput
{
    if (!self.isEditing) return;
    
    [self endEditingToFill:NO];
    
    [self.keyBoard dismiss];
}

- (void)endEditingToFill:(BOOL)isFill
{
    self.config.selectedIndex = -1;
    
    if (_inputComplete && isFill) {
        _inputComplete(self.currentLicenseString);
    }
}

- (void)completeInput
{
    if (self.inputComplete) {
        
        NSString *lisence = self.currentLicenseString;
        self.inputComplete(lisence);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LicenseEndInput" object:nil];
}

- (NSString *)currentLicenseString
{
    return [self.config currentLicenseString];
}

- (void)refreshCollection
{
    [self.collectionView reloadData];
}

#pragma mark - 选中位置改变时进行的操作
- (void)selectedChangeHander:(NSInteger)selectedIndex
{
    [self refreshCollection];
    if (selectedIndex == -1) return;
    
    [self showLetterAndNumberKeyBoard:selectedIndex];
}

#pragma mark - 输入长度限制改变时进行的操作
- (void)maxLengthChangeHander
{
    [self refreshCollection];
}

- (void)textFontChangeHander
{
    [self refreshCollection];
}

- (void)textColorChangeHander
{
    [self refreshCollection];
}

#pragma mark - CollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.config.maxLength;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    licenseInputCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(licenseInputCell.class) forIndexPath:indexPath];
    cell.textLabel.font = self.config.textFont;
    cell.textLabel.text = self.config.TextArrays[indexPath.row].text;
    cell.selected = self.config.selectedIndex == indexPath.row;
    cell.textLabel.textColor = self.config.textColor;
    return cell;
}

#pragma mark - CollectionView Delegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) return YES;
    
    LicenseInputTextModel *model = self.config.TextArrays[indexPath.row - 1];
    return model.text != nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.row == self.config.selectedIndex) return;
    
    LicenseInputTextModel *selectedModel = self.config.TextArrays[indexPath.row];
    selectedModel.selected = YES;
    
    if (self.isLastSelectdeIndexExist) {
        LicenseInputTextModel *lastSelectedModel = self.config.TextArrays[self.config.selectedIndex];
        lastSelectedModel.selected = NO;
    }
     self.config.selectedIndex = indexPath.row;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger length = self.config.maxLength;
    return CGSizeMake(floor((collectionView.frame.size.width - (length-1) * 5) / length), CGRectGetHeight(collectionView.bounds));
}

#pragma mark - lazy
- (LicenseKeyBoardView *)keyBoard
{
    if (!_keyBoard) {
        _keyBoard = [[LicenseKeyBoardView alloc] init];
        _keyBoard.allLetters = self.config.allLetters;
        _keyBoard.allProvinces = self.config.allProvinces;
    }
    return _keyBoard;
}

- (LicenseInputConfig *)config
{
    if (!_config) {
        _config = [LicenseInputConfig configWithInputView:self];
        NSDictionary *invalid = @{@"1": @[@"I",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"],
                                  @"2": @[@"I",@"O"],
                                  @"3": @[@"I",@"O"],
                                  @"4": @[@"I",@"O"],
                                  @"5": @[@"I",@"O"],
                                  @"6": @[@"I",@"O"],
                                  @"7": @[@"I",@"O"],
                                  };
        _config.invalid = invalid;
    }
    return _config;
}


@end

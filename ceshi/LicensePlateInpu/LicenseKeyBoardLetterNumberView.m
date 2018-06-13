//
//  LicenseKeyBoardLetterNumberView.m
//  CarLicence
//
//  Created by 123 on 2017/10/26.
//  Copyright © 2017年 李挺哲. All rights reserved.
//

#import "LicenseKeyBoardLetterNumberView.h"
#import "LicenceNumberCell.h"

@interface LicenseKeyBoardLetterNumberView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic,weak) UICollectionView *letterCollection;
@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, assign) CGFloat lineMargin;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, assign) int maxRows;
@property (nonatomic, assign) int maxColumns;

@end

@implementation LicenseKeyBoardLetterNumberView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _margin = 2;
        _lineMargin = 5;
        _edgeInsets = UIEdgeInsetsMake(8, 5, 8, 5);
        _maxRows = 5;
        _maxColumns = 10;
        [self setupLeterAndNumberView];
        
        [self setupDeleteBtn];
    }
    return self;
}

- (void)setupLeterAndNumberView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = _margin;
    flowLayout.minimumLineSpacing = _lineMargin;
    UICollectionView *letterCollection = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    letterCollection.contentInset = _edgeInsets;
    letterCollection.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    letterCollection.backgroundColor = [UIColor colorWithRed:210/255.0 green:213/255.0 blue:219/255.0 alpha:1.0];
    letterCollection.dataSource = self;
    letterCollection.delegate = self;
    letterCollection.showsHorizontalScrollIndicator = NO;
    letterCollection.showsVerticalScrollIndicator = NO;
    
    // 注册cell
    [letterCollection registerClass:[LicenceNumberCell class] forCellWithReuseIdentifier:@"ProvinceCollectionViewCell"];
    
    [self addSubview:letterCollection];
    _letterCollection = letterCollection;
}

- (void)setupDeleteBtn
{
    // 删除
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton setImage:[UIImage imageNamed:@"deleteCarNumber"] forState:UIControlStateNormal];
    CGFloat btnW = 66;
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
    CGFloat btnH = [self collectionView:self.letterCollection layout:_letterCollection.collectionViewLayout sizeForItemAtIndexPath:indexpath].height;
    CGFloat btnX = CGRectGetWidth(self.frame) - _edgeInsets.right - btnW;
    CGFloat btnY = CGRectGetHeight(self.frame) - _edgeInsets.bottom - btnH;
    deleteButton.frame = CGRectMake(btnX, btnY, btnW, btnH);
    [self addSubview:deleteButton];
    deleteButton.backgroundColor = [UIColor colorWithRed:174/255.0 green:179/255.0 blue:190/255.0 alpha:1.0];
    deleteButton.layer.cornerRadius = 8;
    [deleteButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setInvalidStrings:(NSArray<NSString *> *)invalidStrings
{
    if ([_invalidStrings isEqualToArray:invalidStrings]) return;
    
    _invalidStrings = invalidStrings;
    [self.letterCollection reloadData];
}

#pragma mark - UICollection DataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.allLetters.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"ProvinceCollectionViewCell";
    
    __weak typeof(self) weakSelf = self;
    LicenceNumberCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    NSString *text = self.allLetters[indexPath.row];
    cell.licenseNum = text;
    cell.btnClickBlock = ^(NSString *text) {
        [weakSelf postNotificationWithText:text];
    };
    BOOL userInteractionNotEnabled = [self.invalidStrings containsObject:text];
    cell.userInteractionEnabled = !userInteractionNotEnabled;
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemW = (collectionView.frame.size.width - (_edgeInsets.left +_edgeInsets.right) - (_maxColumns-1)*_margin)/_maxColumns;
    CGFloat itemH = (collectionView.frame.size.height - _edgeInsets.top - _edgeInsets.bottom - _lineMargin*(_maxRows-1))/_maxRows;
    return CGSizeMake(itemW, itemH);
}

- (void)deleteAction
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LicenseDidDeleteNotification" object:nil];
}

- (void)postNotificationWithText:(NSString *)string
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[@"license"] = string;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LicenseDidSelectNotification" object:nil userInfo:userInfo];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{}

- (NSArray *)allLetters
{
    if (!_allLetters) {
        _allLetters = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"Q",@"W",@"E",@"R",@"T",@"Y",@"U",@"I",@"O",@"P",@"A",@"S",@"D",@"F",@"G",@"H",@"J",@"K",@"L",@"Z",@"X",@"C",@"V",@"B",@"N",@"M",@"学",@"警",@"港",@"澳",@"领", @"电"];
    }
    return _allLetters;
}


@end


//
//  LicenseKeyBoardContentView.m
//  CarLicence
//
//  Created by 123 on 2017/10/26.
//  Copyright © 2017年 李挺哲. All rights reserved.
//

#import "LicenseKeyBoardContentView.h"
#import "LicenceNumberCell.h"

// 间距
static CGFloat const margin = 3.0;
static CGFloat const lineMargin = 5.0;

@interface LicenseKeyBoardContentView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic,weak) UICollectionView *provinceCollection;

@end


@implementation LicenseKeyBoardContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self setupProvinceView];
        
    }
    return self;
}

- (void)setupProvinceView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = margin;
    flowLayout.minimumLineSpacing = lineMargin;
    UICollectionView *provinceCollection = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    provinceCollection.contentInset = UIEdgeInsetsMake(8, 5, 8, 5);
    provinceCollection.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    provinceCollection.backgroundColor = [UIColor colorWithRed:210/255.0 green:213/255.0 blue:219/255.0 alpha:1.0];
    provinceCollection.dataSource = self;
    provinceCollection.delegate = self;
    provinceCollection.showsHorizontalScrollIndicator = NO;
    provinceCollection.showsVerticalScrollIndicator = NO;
    
    // 注册cell
    [provinceCollection registerClass:[LicenceNumberCell class] forCellWithReuseIdentifier:@"ProvinceCollectionViewCell"];
    
    [self addSubview:provinceCollection];
    _provinceCollection = provinceCollection;
}

- (void)postNotificationWithText:(NSString *)string
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[@"license"] = string;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LicenseDidSelectNotification" object:nil userInfo:userInfo];
}

- (void)setInvalidStrings:(NSArray<NSString *> *)invalidStrings
{
    if ([_invalidStrings isEqualToArray:invalidStrings]) return;
    
    _invalidStrings = invalidStrings;
    [self.provinceCollection reloadData];
}

#pragma mark --UICollectionDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.allProvinces.count;
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
    NSString *text = self.allProvinces[indexPath.row];
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
    UIEdgeInsets inset = collectionView.contentInset;
    
    return CGSizeMake((collectionView.frame.size.width - (inset.left + inset.right) - 8*margin)/9, (collectionView.frame.size.height - (inset.top + inset.bottom) - lineMargin*3)/4);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _provinceCollection.frame = self.bounds;
}

- (NSArray <NSString *>*)allProvinces
{
    if (!_allProvinces) {
        _allProvinces = @[@"京",@"沪",@"津",@"渝",@"黑",@"吉",@"辽",@"蒙",@"冀",@"新",@"甘",@"青",@"陕",@"宁",@"云",@"豫",@"鲁",@"晋",@"皖", @"鄂",@"湘",@"苏",@"川", @"贵",@"桂",@"藏",@"浙", @"赣", @"粤", @"闽", @"台", @"琼", @"港"];
    }
    return _allProvinces;
}

@end


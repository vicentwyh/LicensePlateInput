//
//  licenseInputCell.h
//  ePark
//
//  Created by 123 on 2017/12/27.
//  Copyright © 2017年 Zorasun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LicenseInputTextModel;

@interface licenseInputCell : UICollectionViewCell

@property (strong, nonatomic) UILabel *textLabel;

@property (nonatomic, strong) LicenseInputTextModel *model;

@end


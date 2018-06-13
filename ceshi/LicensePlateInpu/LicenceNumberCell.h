//
//  LicenceNumberCell.h
//  SwiftCustomKeyboard
//
//  Created by 123 on 2017/10/26.
//  Copyright © 2017年 codeIsMyGirl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LicenceNumberCell : UICollectionViewCell

@property (copy, nonatomic) NSString *licenseNum;

@property (nonatomic, copy) void(^btnClickBlock)(NSString *text);

@end

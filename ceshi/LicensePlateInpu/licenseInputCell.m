//
//  licenseInputCell.m
//  ePark
//
//  Created by 123 on 2017/12/27.
//  Copyright © 2017年 Zorasun. All rights reserved.
//

#import "licenseInputCell.h"
#import "LicenseInputTextModel.h"
#import "LicenseInputSelectedBgView.h"

@implementation licenseInputCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        if (!self.textLabel) {
            self.textLabel = [UILabel new];
            self.textLabel.textAlignment = NSTextAlignmentCenter;
            self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
            self.textLabel.layer.masksToBounds = YES;
            self.textLabel.layer.cornerRadius = 5;
            self.textLabel.layer.borderWidth = 1;
            self.textLabel.layer.borderColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1.0].CGColor;
            self.textLabel.font = [UIFont systemFontOfSize:20];
            [self.contentView addSubview:self.textLabel];
            NSLayoutAttribute layoutAttributes[4] = {NSLayoutAttributeLeft,NSLayoutAttributeRight,NSLayoutAttributeTop,NSLayoutAttributeBottom};
            for (NSInteger i = 0; i < sizeof(layoutAttributes) / sizeof(NSInteger); i++) {
                NSLayoutAttribute layoutAttribute = layoutAttributes[i];
                NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.textLabel attribute:layoutAttribute relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:layoutAttribute multiplier:1.0 constant:0];
                [self.contentView addConstraint:constraint];
            }
        }
        
        LicenseInputSelectedBgView *selectedView = [[LicenseInputSelectedBgView alloc] initWithFrame:self.bounds];
        self.selectedBackgroundView = selectedView;
    }
    return self;
}

- (void)setModel:(LicenseInputTextModel *)model
{
    _model = model;
    
    self.textLabel.text = model.text;
}

@end


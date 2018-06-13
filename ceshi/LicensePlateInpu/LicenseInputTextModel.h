//
//  LicenseInputTextModel.h
//  ePark
//
//  Created by 123 on 2017/12/27.
//  Copyright © 2017年 Zorasun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LicenseInputTextModel : NSObject

@property (nonatomic, copy) NSString *text;

@property (nonatomic, assign, getter=isSelected) BOOL selected;

@end


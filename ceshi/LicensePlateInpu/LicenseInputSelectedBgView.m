//
//  LicenseInputSelectedBgView.m
//  ePark
//
//  Created by 123 on 2017/12/28.
//  Copyright © 2017年 Zorasun. All rights reserved.
//

#import "LicenseInputSelectedBgView.h"

@implementation LicenseInputSelectedBgView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithRed:90/255.0 green:181/255.0 blue:240/255.0 alpha:1.0].CGColor);
    CGContextSetLineWidth(ctx, 2);
    CGContextMoveToPoint(ctx, 10, CGRectGetHeight(self.frame)-10);
    CGContextAddLineToPoint(ctx, CGRectGetWidth(self.frame)-10, CGRectGetHeight(self.frame)-10);
    CGContextDrawPath(ctx, kCGPathFillStroke);
}

@end

//
//  ViewController.m
//  ceshi
//
//  Created by vicentwyh on 19/4/18.
//  Copyright © 2018年 vicentwyh. All rights reserved.
//

#import "ViewController.h"
#import "LicensePlateInput.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet LicensePlateInput *inputView; // 车牌输入视图


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [_inputView replaceStringWithRage:NSMakeRange(0, 2) string:@"闽D"];
    _inputView.inputComplete = ^(NSString *lisenseString) {
        
        
    };
}




@end

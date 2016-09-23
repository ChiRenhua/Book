//
//  TabBarViewController.m
//  Book
//
//  Created by Reeky on 16/3/20.
//  Copyright © 2016年 software. All rights reserved.
//

#import "TabBarViewController.h"
#import "UIColor+AppConfig.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.tabBar.tintColor = [UIColor bookAppColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

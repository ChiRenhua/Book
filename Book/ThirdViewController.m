//
//  ThirdViewController.m
//  Book
//
//  Created by Dreamylife on 16/3/18.
//  Copyright © 2016年 software. All rights reserved.
//

#import "ThirdViewController.h"

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds.size

@interface ThirdViewController ()

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.navigationItem.title = @"已审核";
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_BOUNDS.width/2-100, SCREEN_BOUNDS.height/2-25, 200, 50)];
    [lable setText:@"Third Page"];
    lable.font = [UIFont systemFontOfSize:20];
    lable.textAlignment = NSTextAlignmentCenter;
    [lable setTextColor:[UIColor blackColor]];
    [self.view addSubview:lable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
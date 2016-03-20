//
//  SecondViewController.m
//  Book
//
//  Created by Dreamylife on 16/3/18.
//  Copyright © 2016年 software. All rights reserved.
//

#import "SecondViewController.h"

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds.size

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.navigationItem.title = @"页面二";
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_BOUNDS.width/2-100, SCREEN_BOUNDS.height/2-25, 200, 50)];
    [lable setText:@"Second Page"];
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

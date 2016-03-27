//
//  BookDetialViewController.m
//  Book
//
//  Created by Dreamylife on 16/3/23.
//  Copyright © 2016年 software. All rights reserved.
//

#import "BookDetialViewController.h"
#import "Book.h"

@interface BookDetialViewController ()

@end

Book *detialBook;

@implementation BookDetialViewController

- (id)init:(Book *) book{
    if (self = [super init]) {
        detialBook = [[Book alloc]init];
        detialBook = book;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 100, 20)];
    lable.text = detialBook.bookName;
    [self.view addSubview:lable];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
//
//  CheckBookViewController.h
//  Book
//
//  Created by Dreamylife on 16/3/18.
//  Copyright © 2016年 software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckBookViewController : UIViewController
typedef NS_ENUM(NSInteger, ViewCode)
{
    firstUncheckedBook      = 1,
    firstCheckingBook       = 1 << 1,
    firstCheckedPassBook    = 1 << 2,
    firstCheckedUnpassBook  = 1 << 3,
    reviewUncheckedBook     = 1 << 4,
    reviewCheckingBook      = 1 << 5,
    reviewCheckedPassBook   = 1 << 6,
    reviewCheckedUnpassBook = 1 << 7
};
#pragma msrk 判断是初审还是复审页面
- (id)init:(int)viewcode;

@end


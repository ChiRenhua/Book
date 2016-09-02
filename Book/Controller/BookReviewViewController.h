//
//  BookReviewViewController.h
//  Book
//
//  Created by Dreamylife on 16/4/20.
//  Copyright © 2016年 software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"
#import "CustomIOSAlertView.h"

typedef void (^SbSuccess)(NSString *bookstate);

@interface BookReviewViewController : UIViewController

@property (nonatomic,copy)SbSuccess submitsuccess;

- (id)init:(Book *) book;

@end

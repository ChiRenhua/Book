//
//  SearchSonViewController.h
//  Book
//
//  Created by Renhuachi on 16/9/3.
//  Copyright © 2016年 software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchSonViewController : UIViewController
typedef NS_ENUM(NSInteger, searchType)
{
    searchKeyword      = 1,
    classifiedSearch   = 1 << 1,
};

- (id)init:(NSMutableArray *)array :(NSString *)title :(NSInteger)searchType;

@end

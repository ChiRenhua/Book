//
//  SearchModel.h
//  Book
//
//  Created by Renhuachi on 16/9/2.
//  Copyright © 2016年 software. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FailedLoadSearchData)();
typedef void (^SuccessLoadSearchData)();
@interface SearchModel : NSObject

@property(nonatomic,copy) FailedLoadSearchData failedLoadSearchData;
@property(nonatomic,copy) SuccessLoadSearchData successLoadSearchData;

+ (SearchModel *)sharedInstance;

- (void)getSearchDataWithURL:(NSString *)searchURL;

@end

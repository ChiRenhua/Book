//
//  BookReasonModel.h
//  Book
//
//  Created by Renhuachi on 16/8/29.
//  Copyright © 2016年 software. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^UpdateReason)(NSString * reason);
@interface BookReasonModel : NSObject

@property(nonatomic,copy) UpdateReason updateReason;

+ (BookReasonModel *)sharedInstance;

- (void)getBookreasonWithURL:(NSString *)bookReasonurl;

@end

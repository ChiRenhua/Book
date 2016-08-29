//
//  BookDetialModel.h
//  Book
//
//  Created by Renhuachi on 16/8/29.
//  Copyright © 2016年 software. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^UpdateReason)(NSString * reason);
typedef void (^BookDetialShowLoginView)();
@interface BookDetialModel : NSObject

@property(nonatomic,copy) UpdateReason updateReason;
@property(nonatomic,copy) BookDetialShowLoginView bookDetialShowLoginView;

typedef NS_ENUM(NSInteger, Module)
{
    bookReasonModule        = 1,
    addReviewButtonModule   = 1 << 1,
};

+ (BookDetialModel *)sharedInstance;

- (void)getBookreasonWithURL:(NSString *)bookReasonurl by:(NSInteger )Module;

@end

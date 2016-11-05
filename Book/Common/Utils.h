//
//  Utils.h
//  Book
//
//  Created by Renhuachi on 2016/11/5.
//  Copyright © 2016年 software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utils : NSObject

+ (CGSize)stringWedith:(NSString *)string size:(NSUInteger)size;

+ (NSString *)getLibraryPath;

+ (NSString *)UTF8URL:(NSString *)url;
@end

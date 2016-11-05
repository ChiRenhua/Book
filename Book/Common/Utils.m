//
//  Utils.m
//  Book
//
//  Created by Renhuachi on 2016/11/5.
//  Copyright © 2016年 software. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (CGSize)stringWedith:(NSString *)string size:(NSUInteger)size {
    return [string sizeWithFont:[UIFont systemFontOfSize:size] constrainedToSize:CGSizeMake(300.0f,CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
}

+ (NSString *)getLibraryPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return (NSString *)[paths objectAtIndex:0];
}

+ (NSString *)UTF8URL:(NSString *)url {
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end

//
//  UIColor+AppConfig.m
//  Book
//
//  Created by Renhuachi on 16/9/23.
//  Copyright © 2016年 software. All rights reserved.
//

#import "UIColor+AppConfig.h"

@implementation UIColor (AppConfig)

+ (UIColor *)bookRedColor {
    return [UIColor redColor];
}

+ (UIColor *)bookGreenColor {
    return [UIColor colorWithRed:0.0f/255.0f green:200.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
}

+ (UIColor *)bookBlueColor {
    return [UIColor colorWithRed:28.0f/255.0f green:134.0f/255.0f blue:238.0f/255.0f alpha:1.0f];
}

+ (UIColor *)bookAppColor {
   return  [UIColor colorWithRed:54.0f/255.0f green:188.0f/255.0f blue:210.0f/255.0f alpha:1.0f];
}

+ (UIColor *)bookLableColor {
    return  [UIColor colorWithRed:0.0f/255.0f green:159.0f/255.0f blue:198.0f/255.0f alpha:1.0f];
}

@end

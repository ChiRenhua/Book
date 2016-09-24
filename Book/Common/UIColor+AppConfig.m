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
   return  [UIColor colorWithRed:0.0f/255.0f green:205.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
}

+ (UIColor *)bookLableColor {
    return  [UIColor colorWithRed:0.0f/255.0f green:185.0f/255.0f blue:232.0f/255.0f alpha:1.0f];
}

+ (UIColor *)bookLoginBGColor {
    return  [UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
}

@end

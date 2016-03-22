//
//  GetBookInfo.m
//  Book
//
//  Created by Dreamylife on 16/3/22.
//  Copyright © 2016年 software. All rights reserved.
//

#import "GetBookInfo.h"

@implementation GetBookInfo

#pragma mark 书籍假数据
- (NSMutableArray *)getPassBooks {
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    NSMutableDictionary  *dic1 = [[NSMutableDictionary alloc]init];
    [dic1 setObject:@"Story Craft" forKey:@"bookName"];
    [dic1 setObject:@"Jack Hart" forKey:@"bookWriter"];
    [dic1 setObject:@"2016年3月20日" forKey:@"bookTime"];
    [dic1 setObject:@"谨以此书，献给那些不为众人所理解的一少数,希望大家能够了解他们生命中的欢乐与辛酸，灵魂深处的黑暗和光明。 " forKey:@"bookSummary"];
    [dic1 setObject:@"20M" forKey:@"bookSize"];
    [dic1 setObject:@"100页" forKey:@"bookPages"];
    [dic1 setObject:@"小说" forKey:@"bookCategory"];
    [dic1 setObject:@"book_01.jpg" forKey:@"bookPicture"];
    [dic1 setObject:@"待审核" forKey:@"bookState"];
    
    NSMutableDictionary  *dic2 = [[NSMutableDictionary alloc]init];
    [dic2 setObject:@"The Animal Part" forKey:@"bookName"];
    [dic2 setObject:@"Mark Payne" forKey:@"bookWriter"];
    [dic2 setObject:@"2016年3月25日" forKey:@"bookTime"];
    [dic2 setObject:@"谨以此书，献给那些不为众人所理解的一少数,希望大家能够了解他们生命中的欢乐与辛酸，灵魂深处的黑暗和光明。 " forKey:@"bookSummary"];
    [dic2 setObject:@"30M" forKey:@"bookSize"];
    [dic2 setObject:@"120页" forKey:@"bookPages"];
    [dic2 setObject:@"小说" forKey:@"bookCategory"];
    [dic2 setObject:@"book_02.jpg" forKey:@"bookPicture"];
    [dic2 setObject:@"待审核" forKey:@"bookState"];
    
    NSMutableDictionary  *dic3 = [[NSMutableDictionary alloc]init];
    [dic3 setObject:@"An Ethics Of Intrrogation" forKey:@"bookName"];
    [dic3 setObject:@"Michael" forKey:@"bookWriter"];
    [dic3 setObject:@"2016年3月21日" forKey:@"bookTime"];
    [dic3 setObject:@"谨以此书，献给那些不为众人所理解的一少数,希望大家能够了解他们生命中的欢乐与辛酸，灵魂深处的黑暗和光明。 " forKey:@"bookSummary"];
    [dic3 setObject:@"30M" forKey:@"bookSize"];
    [dic3 setObject:@"233页" forKey:@"bookPages"];
    [dic3 setObject:@"小说" forKey:@"bookCategory"];
    [dic3 setObject:@"book_03.jpg" forKey:@"bookPicture"];
    [dic3 setObject:@"待审核" forKey:@"bookState"];
    
    NSMutableDictionary  *dic4 = [[NSMutableDictionary alloc]init];
    [dic4 setObject:@"Dangerous" forKey:@"bookName"];
    [dic4 setObject:@"J.G" forKey:@"bookWriter"];
    [dic4 setObject:@"2016年3月20日" forKey:@"bookTime"];
    [dic4 setObject:@"谨以此书，献给那些不为众人所理解的一少数,希望大家能够了解他们生命中的欢乐与辛酸，灵魂深处的黑暗和光明。 " forKey:@"bookSummary"];
    [dic4 setObject:@"20M" forKey:@"bookSize"];
    [dic4 setObject:@"100页" forKey:@"bookPages"];
    [dic4 setObject:@"小说" forKey:@"bookCategory"];
    [dic4 setObject:@"book_04.jpg" forKey:@"bookPicture"];
    [dic4 setObject:@"待审核" forKey:@"bookState"];
    
    NSMutableDictionary  *dic5 = [[NSMutableDictionary alloc]init];
    [dic5 setObject:@"The Unconsoled" forKey:@"bookName"];
    [dic5 setObject:@"Ka Zuo" forKey:@"bookWriter"];
    [dic5 setObject:@"2016年3月20日" forKey:@"bookTime"];
    [dic5 setObject:@"谨以此书，献给那些不为众人所理解的一少数,希望大家能够了解他们生命中的欢乐与辛酸，灵魂深处的黑暗和光明。 " forKey:@"bookSummary"];
    [dic5 setObject:@"20M" forKey:@"bookSize"];
    [dic5 setObject:@"100页" forKey:@"bookPages"];
    [dic5 setObject:@"小说" forKey:@"bookCategory"];
    [dic5 setObject:@"book_05.jpg" forKey:@"bookPicture"];
    [dic5 setObject:@"待审核" forKey:@"bookState"];
    
    NSMutableDictionary  *dic6 = [[NSMutableDictionary alloc]init];
    [dic6 setObject:@"Charllotte" forKey:@"bookName"];
    [dic6 setObject:@"Jane" forKey:@"bookWriter"];
    [dic6 setObject:@"2016年3月20日" forKey:@"bookTime"];
    [dic6 setObject:@"谨以此书，献给那些不为众人所理解的一少数,希望大家能够了解他们生命中的欢乐与辛酸，灵魂深处的黑暗和光明。 " forKey:@"bookSummary"];
    [dic6 setObject:@"20M" forKey:@"bookSize"];
    [dic6 setObject:@"100页" forKey:@"bookPages"];
    [dic6 setObject:@"小说" forKey:@"bookCategory"];
    [dic6 setObject:@"book_06.jpg" forKey:@"bookPicture"];
    [dic6 setObject:@"待审核" forKey:@"bookState"];
    
    NSMutableDictionary  *dic7 = [[NSMutableDictionary alloc]init];
    [dic7 setObject:@"70" forKey:@"bookName"];
    [dic7 setObject:@"W.G" forKey:@"bookWriter"];
    [dic7 setObject:@"2016年3月20日" forKey:@"bookTime"];
    [dic7 setObject:@"谨以此书，献给那些不为众人所理解的一少数,希望大家能够了解他们生命中的欢乐与辛酸，灵魂深处的黑暗和光明。 " forKey:@"bookSummary"];
    [dic7 setObject:@"20M" forKey:@"bookSize"];
    [dic7 setObject:@"100页" forKey:@"bookPages"];
    [dic7 setObject:@"小说" forKey:@"bookCategory"];
    [dic7 setObject:@"book_07.jpg" forKey:@"bookPicture"];
    [dic7 setObject:@"待审核" forKey:@"bookState"];
    
    NSMutableDictionary  *dic8 = [[NSMutableDictionary alloc]init];
    [dic8 setObject:@"Flying LEAP" forKey:@"bookName"];
    [dic8 setObject:@"JUDY" forKey:@"bookWriter"];
    [dic8 setObject:@"2016年3月20日" forKey:@"bookTime"];
    [dic8 setObject:@"谨以此书，献给那些不为众人所理解的一少数,希望大家能够了解他们生命中的欢乐与辛酸，灵魂深处的黑暗和光明。 " forKey:@"bookSummary"];
    [dic8 setObject:@"20M" forKey:@"bookSize"];
    [dic8 setObject:@"100页" forKey:@"bookPages"];
    [dic8 setObject:@"小说" forKey:@"bookCategory"];
    [dic8 setObject:@"book_08.jpg" forKey:@"bookPicture"];
    [dic8 setObject:@"待审核" forKey:@"bookState"];
    
    NSMutableDictionary  *dic9 = [[NSMutableDictionary alloc]init];
    [dic9 setObject:@"LVE" forKey:@"bookName"];
    [dic9 setObject:@"bILLER" forKey:@"bookWriter"];
    [dic9 setObject:@"2016年3月20日" forKey:@"bookTime"];
    [dic9 setObject:@"谨以此书，献给那些不为众人所理解的一少数,希望大家能够了解他们生命中的欢乐与辛酸，灵魂深处的黑暗和光明。 " forKey:@"bookSummary"];
    [dic9 setObject:@"20M" forKey:@"bookSize"];
    [dic9 setObject:@"100页" forKey:@"bookPages"];
    [dic9 setObject:@"小说" forKey:@"bookCategory"];
    [dic9 setObject:@"book_09.jpg" forKey:@"bookPicture"];
    [dic9 setObject:@"待审核" forKey:@"bookState"];
    
    NSMutableDictionary  *dic10 = [[NSMutableDictionary alloc]init];
    [dic10 setObject:@"1984" forKey:@"bookName"];
    [dic10 setObject:@"George" forKey:@"bookWriter"];
    [dic10 setObject:@"2016年3月20日" forKey:@"bookTime"];
    [dic10 setObject:@"谨以此书，献给那些不为众人所理解的一少数,希望大家能够了解他们生命中的欢乐与辛酸，灵魂深处的黑暗和光明。 " forKey:@"bookSummary"];
    [dic10 setObject:@"20M" forKey:@"bookSize"];
    [dic10 setObject:@"100页" forKey:@"bookPages"];
    [dic10 setObject:@"小说" forKey:@"bookCategory"];
    [dic10 setObject:@"book_10.jpg" forKey:@"bookPicture"];
    [dic10 setObject:@"待审核" forKey:@"bookState"];
    
    
    Book *b1 = [Book staticInitWithDictionary:dic1];
    [array addObject:b1];
    Book *b2 = [Book staticInitWithDictionary:dic2];
    [array addObject:b2];
    Book *b3 = [Book staticInitWithDictionary:dic3];
    [array addObject:b3];
    Book *b4 = [Book staticInitWithDictionary:dic4];
    [array addObject:b4];
    Book *b5 = [Book staticInitWithDictionary:dic5];
    [array addObject:b5];
    Book *b6 = [Book staticInitWithDictionary:dic6];
    [array addObject:b6];
    Book *b7 = [Book staticInitWithDictionary:dic7];
    [array addObject:b7];
    Book *b8 = [Book staticInitWithDictionary:dic8];
    [array addObject:b8];
    Book *b9 = [Book staticInitWithDictionary:dic9];
    [array addObject:b9];
    Book *b10 = [Book staticInitWithDictionary:dic10];
    [array addObject:b10];
    
    return array;
}
- (NSMutableArray *)getUnpassBooks {
    return [self getPassBooks];
}
- (NSMutableArray *)getPendingBooks {
    return [self getPassBooks];
}
- (NSMutableArray *)getFirstReviewBooks {
    return [self getPassBooks];
}
- (NSMutableArray *)getSecondReviewBooks {
    return [self getPassBooks];
}

@end
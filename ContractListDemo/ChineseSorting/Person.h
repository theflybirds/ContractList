//
//  Person.h
//  YUChineseSorting
//
//  Created by LZW on 16/2/18.
//  Copyright © 2016年 BruceYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (strong , nonatomic) NSString * name;
@property (strong , nonatomic) NSString * photoPath;
@property (strong , nonatomic) NSString * userId;
@property (assign , nonatomic) NSInteger number;
@property (assign , nonatomic) NSInteger isVip;
@property (assign , nonatomic) BOOL isSelect;
@property (strong , nonatomic) NSString * lat;
@property (strong , nonatomic) NSString * lng;

@end

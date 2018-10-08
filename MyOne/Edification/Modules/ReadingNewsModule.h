//
//  ReadingNewsModule.h
//  MyOne
//
//  Created by 林辉武 on 2018/10/6.
//  Copyright © 2018年 melody. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseEntity.h"

@interface ReadingNewsModule : BaseEntity

@property (nonatomic,strong) NSString *author_name;
@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong) NSString *thumbnail_pic_s;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *uniquekey;
@property (nonatomic,strong) NSString *url;

@end

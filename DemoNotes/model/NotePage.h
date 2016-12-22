//
//  NotePage.h
//  MyNotes
//
//  Created by Wujianyun on 18/12/2016.
//  Copyright © 2016 yaoyaoi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Folder.h"
@interface NotePage : NSObject
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *content;
@property (nonatomic,strong)NSString *time;
@property (nonatomic,assign)NSInteger noteID;

+(void)creatNotepage:(NSString *)content ForFolder:(Folder *)folder;

+(void)updateNotePage:(NSString *)content currentNotePage:(NotePage *)notePage ForFolder:(Folder *)folder;

+(void)deleteNotePage:(NSString *)content currentNotePage:(NotePage *)notePage ForFolder:(Folder *)folder;
+(NSArray *)getTheTitlePages:(NSArray *)noteArray;
@end

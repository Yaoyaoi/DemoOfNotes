//
//  NotePage.m
//  MyNotes
//
//  Created by Wujianyun on 18/12/2016.
//  Copyright © 2016 yaoyaoi. All rights reserved.
//

#import "NotePage.h"
#import "SqlService.h"
#import "TimeDealler.h"

@implementation NotePage
+(void)creatNotepage:(NSString *)content ForFolder:(Folder *)folder
{
    if ([content length] == 0) {
        return;
    }
    NotePage *notePage = [[NotePage alloc]init];
    if ([content length]<10) {
        notePage.title = content;
    }else{
        notePage.title = [content substringToIndex:9];
    }
    
    notePage.content = content;
    notePage.time = [TimeDealler getCurrentTime];
    [[SqlService sqlInstance] insertNoteDBtable:notePage ForFolder:folder];

}

+(void)updateNotePage:(NSString *)content currentNotePage:(NotePage *)notePage ForFolder:(Folder *)folder{
    if ([content length]<10) {
        notePage.title = content;
    }else{
        notePage.title = [content substringToIndex:9];
    }
    notePage.content = content;
    notePage.time = [TimeDealler getCurrentTime];
    [[SqlService sqlInstance]updateNoteDBtable:notePage ForFolder:folder];

    
}

+(void)deleteNotePage:(NSString *)content currentNotePage:(NotePage *)notePage ForFolder:(Folder *)folder
{
        [[SqlService sqlInstance]deleteNoteDBtableList:notePage ForFolder:folder];
}


+(NSArray *)getTheTitlePages:(NSArray *)noteArray {
    NSMutableArray *array = [NSMutableArray array];
    for (id object in noteArray) {
        NotePage *notePage = object;
        NSString *title = [[NSString alloc]initWithString:notePage.title];
        
        [array addObject:title];
    }
    
    return [array copy];

}
@end


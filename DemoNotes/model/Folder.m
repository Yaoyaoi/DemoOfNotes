//
//  Folder.m
//  MyNotes
//
//  Created by Wujianyun on 18/12/2016.
//  Copyright © 2016 yaoyaoi. All rights reserved.
//

#import "Folder.h"
#import "SqlService.h"

@implementation Folder
+(void)createWithName:(NSString*)name
{
    Folder*folder=[[Folder alloc]init];
    folder.name=name;
    [[SqlService sqlInstance] insertFolderDBtable:folder];
}

+(void)updateFolder:(NSString *)name currentFolder:(Folder *)folder
{
    [folder setName:name];
    NSLog(@"%ld",folder.numOfNotes);

    [[SqlService sqlInstance] updateFolderDBtable:folder];
    
}

@end

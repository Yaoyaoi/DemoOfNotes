//
//  sqlService.h
//  DemoOfNotes
//
//  Created by Wujianyun on 18/12/2016.
//  Copyright © 2016 yaoyaoi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotePage.h"
#import "Folder.h"

@interface SqlService : NSObject
+(SqlService *)sqlInstance;

-(void)insertNoteDBtable:(NotePage *)notePage ForFolder:(Folder*)folder;
-(void)insertFolderDBtable:(Folder *)folder;

-(void)updateNoteDBtable:(NotePage *)notePage ForFolder:(Folder*)folder;
-(void)updateFolderDBtable:(Folder *)folder;

-(BOOL)deleteNoteDBtableList:(NotePage *)notePage ForFolder:(Folder*)folder;
-(BOOL)deleteFolderDBtableList:(Folder *)folder;

-(NSArray *)queryNoteDBtableForFolder:(Folder*)folder;
-(NSArray *)queryFolderDBtable;
@end

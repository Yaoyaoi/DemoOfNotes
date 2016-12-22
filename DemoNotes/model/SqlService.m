//
//  sqlService.m
//  DemoOfNotes
//
//  Created by Wujianyun on 18/12/2016.
//  Copyright © 2016 yaoyaoi. All rights reserved.
//

#import "SqlService.h"
#import "NotePage.h"
#import "Folder.h"
#import "FMDatabase.h"

#define TABLENAME @"foldertable"
#define TITLE @"title"
#define CONTENT @"content"
#define TIME @"time"
#define ID @"id"
#define NAME @"name"
#define NUMOFNOTES @"numofnotes"

static SqlService *sqlService;
@interface SqlService(){
    
}

@property (nonatomic,strong)FMDatabase *db;
@property (nonatomic,strong)NSString *dataBasePath;

@end
@implementation SqlService
@synthesize db;
@synthesize dataBasePath;
#pragma -mark DBinit
+(SqlService *)sqlInstance{
    @synchronized(self){
        if(!sqlService){
            sqlService = [[self alloc]init];
        }
    }
    
    return sqlService;
}

-(id)init{
    self = [super init];
    if(self){
        [self setSqlDB];
    }
    return self;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    @synchronized(self){
        if(!sqlService){
            sqlService = [super allocWithZone:zone];
        }
    }
    
    return sqlService;
}
-(void)setSqlDB{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    dataBasePath = [documents stringByAppendingPathComponent:@"DemoOfNotes.sqlite"];
    db  = [FMDatabase databaseWithPath:dataBasePath];
}
#pragma -mark table
-(void)createNoteTableForFolder:(Folder*)folder
{
    folder.tablename=[[NSString alloc]initWithFormat:@"noteTable%ld",folder.folderID];
    if([db open]){
        NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT,TITLE TEXT,CONTENT TEXT,TIME TEXT)",folder.tablename];
        BOOL res = [db executeUpdate:sqlCreateTable];
        
        if(!res){
            NSLog(@"create error");
        }else{
            NSLog(@"success");
        }
        
        [db close];
        
    }
}
-(void)createFolderTable
{
    if([db open]){
        NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS FOLDERTABLE (ID INTEGER PRIMARY KEY AUTOINCREMENT,NAME TEXT,NUMOFNOTES INTEGER)"];
        BOOL res = [db executeUpdate:sqlCreateTable];
        
        if(!res){
            NSLog(@"create error");
        }else{
            NSLog(@"success");
        }
        
        [db close];
        
    }
}

-(void)insertNoteDBtable:(NotePage *)notePage ForFolder:(Folder*)folder
{
    [self createNoteTableForFolder:folder];
    
    if([db open]){
        NSString *sqlInsertTable = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@','%@','%@')VALUES ('%@','%@','%@')",folder.tablename,TITLE,CONTENT,TIME,notePage.title,notePage.content,notePage.time];
        BOOL res = [db executeUpdate:sqlInsertTable];
        if(!res){
            NSLog(@"插入失败");
        }else{
            NSLog(@"insert success");
        }
        
        [db close];
    }
}
-(void)insertFolderDBtable:(Folder *)folder{
    [self createFolderTable];
    
    if([db open]){
        NSString *sqlInsertTable = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@','%@')VALUES ('%@','%ld')",TABLENAME,NAME,NUMOFNOTES,folder.name,(long)folder.numOfNotes];
        NSLog(@"%@",folder.name);
        BOOL res = [db executeUpdate:sqlInsertTable];
        if(!res){
            NSLog(@"插入失败");
        }else{
            NSLog(@"insert success");
        }
        
        [db close];
    }

}

-(void)updateNoteDBtable:(NotePage *)notePage ForFolder:(Folder*)folder
{
    if([db open]){
        NSString *sqlUpdeteTable = [NSString stringWithFormat:@"UPDATE '%@' SET '%@' = '%@' , '%@' = '%@' , '%@' = '%@' WHERE %@ = %ld",folder.tablename,TITLE,notePage.title,CONTENT,notePage.content,TIME,notePage.time,ID,(long)notePage.noteID];
        NSLog(@"%@",sqlUpdeteTable);
        BOOL res = [db executeUpdate:sqlUpdeteTable];
        if(!res){
            NSLog(@"update error");
        }else{
            NSLog(@"update success");
        }
        
        [db close];
    }

}
-(void)updateFolderDBtable:(Folder *)folder
{
    if([db open]){
        NSString *sqlUpdeteTable = [NSString stringWithFormat:@"UPDATE %@ SET '%@' = '%@' , '%@' = '%ld' WHERE %@ = %ld",TABLENAME,NAME,folder.name,NUMOFNOTES,(long)folder.numOfNotes,ID,folder.folderID];
        NSLog(@"%@",sqlUpdeteTable);
        BOOL res = [db executeUpdate:sqlUpdeteTable];
        if(!res){
            NSLog(@"update error");
        }else{
            NSLog(@"update success");
        }
        
        [db close];
    }

}

-(BOOL)deleteNoteDBtableList:(NotePage *)notePage ForFolder:(Folder*)folder
{
    if([db open]){
        NSLog(@"%@",folder.name);
        NSString *sqlDelete = [NSString stringWithFormat:@"delete from %@ where %@ = %ld",folder.tablename,ID,(long)notePage.noteID];
        NSLog(@"%@",sqlDelete);
        BOOL res = [db executeUpdate:sqlDelete];
        if(!res){
            NSLog(@"delete error");
        }else{
            NSLog(@"delete success");
        }
        [db close];
        return  res;
    }
    return NO;

}
-(BOOL)deleteFolderDBtableList:(Folder *)folder
{
    if([db open]){
        
        NSString *sqlDelete = [NSString stringWithFormat:@"delete from %@ where %@ = %ld",TABLENAME,ID,(long)folder.folderID];
        NSString* sqlDeleteTable=[NSString stringWithFormat:@"DROP TABLE %@",folder.tablename];
        BOOL res = [db executeUpdate:sqlDelete];
        BOOL resT=[db executeUpdate:sqlDeleteTable];
        if(res&&resT){
            NSLog(@"delete success");
        }else{
            NSLog(@"delete error");
        }
        [db close];
        return  res;
    }
    return NO;
}

-(NSArray *)queryNoteDBtableForFolder:(Folder*)folder
{
    [self createNoteTableForFolder:folder];
    
    NSMutableArray *array  = [NSMutableArray array];
    
    if([db open]){
        NSString *sql = [NSString stringWithFormat:@"SELECT *FROM %@",folder.tablename];;
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NotePage *notePage = [[NotePage alloc]init];
            notePage.noteID = [rs intForColumn:ID];
            notePage.title = [rs stringForColumn:TITLE];
            notePage.content = [rs stringForColumn:CONTENT];
            notePage.time = [rs stringForColumn:TIME];
            [array addObject:notePage];
        }
        [db close];
        return [array copy];
    }
    return nil;

}
-(NSArray *)queryFolderDBtable
{
    [self createFolderTable];
    
    NSMutableArray *array  = [NSMutableArray array];
    
    if([db open]){
        NSString *sql = [NSString stringWithFormat:@"SELECT *FROM %@",TABLENAME];;
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            Folder* folder=[[Folder alloc]init];
            folder.name= [rs stringForColumn:NAME];
            NSLog(@"%@",folder.name);
            folder.numOfNotes=[rs intForColumn:NUMOFNOTES];
            NSLog(@"%ld",folder.numOfNotes);
            folder.folderID=[rs intForColumn:ID];
            [array addObject:folder];
        }
        [db close];
        return [array copy];
    }
    return nil;
}


@end

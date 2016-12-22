//
//  Folder.h
//  MyNotes
//
//  Created by Wujianyun on 18/12/2016.
//  Copyright © 2016 yaoyaoi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Folder : NSObject
@property (nonatomic,strong)NSString * name;
@property (nonatomic,assign)NSInteger folderID;
@property (nonatomic,strong)NSArray *noteListArray;
@property (nonatomic,assign)NSInteger numOfNotes;
@property (nonatomic,strong)NSString * tablename;

+(void)createWithName:(NSString*)name;

+(void)updateFolder:(NSString *)name currentFolder:(Folder *)folder;

@end

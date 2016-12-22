//
//  FolderViewController.h
//  DemoNotes
//
//  Created by Wujianyun on 18/12/2016.
//  Copyright © 2016 yaoyaoi. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Folder.h"
@protocol FolderUpdateDelegate <NSObject>

-(void)updateTheFolderList;

@end
@interface FolderViewController : UITableViewController
@property (nonatomic,strong)Folder* currentFolder;
@property (nonatomic,weak)id<FolderUpdateDelegate>  delegate;
@end

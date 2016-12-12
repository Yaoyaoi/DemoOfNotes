//
//  folderController.h
//  DemoOfNotes
//
//  Created by Wujianyun on 13/12/2016.
//  Copyright © 2016 yaoyaoi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Folder : UITableViewController<UITableViewDelegate,UITableViewDataSource>
{
    UIBarButtonItem* _editBn;
    UIBarButtonItem* _composeBn;
    UIBarButtonItem* _fixedSpace;
    UIBarButtonItem* _backBn;
    UIBarButtonItem* _cancelBn;
    UIBarButtonItem* _moveAllBn;
    UIBarButtonItem* _deleteAllBn;
    UIAlertController* _alert;
}
@property (nonatomic,copy)  NSMutableArray *noteArray;
@property (nonatomic,copy)  NSMutableArray *dateArray;
@property (nonatomic,copy)  NSMutableArray *filteredNoteArray;
@property (nonatomic,copy)  NSString *folderName;
@property (nonatomic,copy)  NSMutableDictionary *folderDetail;
@property (nonatomic,copy)  NSMutableArray* foldersDetail;
@property BOOL isNew;
@property NSInteger myindex;
@end

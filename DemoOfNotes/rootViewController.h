//
//  rootViewController.h
//  DemoOfNotes
//
//  Created by Wujianyun on 13/12/2016.
//  Copyright © 2016 yaoyaoi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rootViewController : UITableViewController<UITableViewDelegate>
{
    UIBarButtonItem* _deleteBn;
    UIBarButtonItem* _editBn;
    UIBarButtonItem* _doneBn;
    UIBarButtonItem* _fixedSpace;
    UIBarButtonItem* _NewFolderBn;
    UIAlertController* _alert;
}
@property (nonatomic,copy)  NSMutableArray* foldersName;
@property (nonatomic,copy)  NSMutableArray* foldersDetail;

@end

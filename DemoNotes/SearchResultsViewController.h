//
//  SearchResultsViewController.h
//  DemoNotes
//
//  Created by Wujianyun on 21/12/2016.
//  Copyright © 2016 yaoyaoi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FolderViewController.h"

@interface SearchResultsViewController : UITableViewController
@property (nonatomic, strong) NSArray *filteredNotes;
@property (nonatomic, strong) FolderViewController  *folderViewController;
@end

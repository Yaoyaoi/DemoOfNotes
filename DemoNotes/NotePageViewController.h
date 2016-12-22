//
//  NotePageViewController.h
//  DemoNotes
//
//  Created by Wujianyun on 18/12/2016.
//  Copyright © 2016 yaoyaoi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotePage.h"
#import "Folder.h"
@protocol NotePageUpdateDelegate <NSObject>

-(void)updateTheNoteList;

@end
@interface NotePageViewController : UIViewController
@property (nonatomic,strong)NotePage * currentPage;
@property (nonatomic,strong)Folder * currentFolder;
@property (nonatomic,weak)id<NotePageUpdateDelegate>  delegate;
@end

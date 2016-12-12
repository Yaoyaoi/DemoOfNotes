//
//  noteController.h
//  DemoOfNotes
//
//  Created by Wujianyun on 13/12/2016.
//  Copyright © 2016 yaoyaoi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol isNotNew <NSObject>

-(void)isNotNew;
-(NSInteger)folderindex;

@end
@interface noteDetailVC : UIViewController
{
    UIAlertController* _alert;
}
@property UITextView* textView;
@property NSInteger myindex;
@property NSString *oldtext;
@property NSMutableDictionary* myDetail;
@property BOOL isNew;
@property NSMutableArray* foldersDetail;
@property id<isNotNew> delegate;
@end

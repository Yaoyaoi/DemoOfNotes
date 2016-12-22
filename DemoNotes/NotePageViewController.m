//
//  NotePageViewController.m
//  DemoNotes
//
//  Created by Wujianyun on 18/12/2016.
//  Copyright © 2016 yaoyaoi. All rights reserved.
//

#import "NotePageViewController.h"
#import "SqlService.h"
@interface NotePageViewController ()
{
    UIAlertController* _alert;
}
@property UITextView* textView;
@end

@implementation NotePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawView];
    // Do any additional setup after loading the view.
}
-(void)drawView
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size  .height)];
    UIBarButtonItem* trashBtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(trashPressed)];
    NSArray* arrayToolBarItems=[[NSArray alloc]initWithObjects:trashBtn,nil];
    UIBarButtonItem* saveBtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed)];
    [self.navigationItem setRightBarButtonItem:saveBtn];
    [self.navigationController setToolbarHidden:NO];
    [self setToolbarItems:arrayToolBarItems];
    [self.view addSubview:_textView];
    if(_currentPage)
    {
        _textView.text=_currentPage.content;
    }


}
-(void)trashPressed
{
    [[SqlService sqlInstance]deleteNoteDBtableList:_currentPage ForFolder:_currentFolder];
    [self.delegate updateTheNoteList];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)savePressed
{
    if(_currentPage){
        //修改操作
        if([_textView.text length] == 0){
            [NotePage deleteNotePage:_textView.text currentNotePage:_currentPage ForFolder:_currentFolder];
        }else{
            [NotePage updateNotePage:_textView.text currentNotePage:_currentPage ForFolder:_currentFolder];
        }
    }else{
        [NotePage creatNotepage:_textView.text ForFolder:_currentFolder];
    }
    [self.delegate updateTheNoteList];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  noteController.m
//  DemoOfNotes
//
//  Created by Wujianyun on 13/12/2016.
//  Copyright © 2016 yaoyaoi. All rights reserved.
//

#import "noteController.h"

@interface noteDetailVC ()

@end

@implementation noteDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setDelegate:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -2)]];
    _foldersDetail=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"foldersDetail"]];
    _myDetail=[[NSMutableDictionary alloc]initWithDictionary:[_foldersDetail objectAtIndex:[_delegate folderindex]]];
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size  .height)];
    if(!_isNew)
    {
        _textView.text = [[_myDetail objectForKey:@"noteArray"] objectAtIndex:_myindex];
    }
    UIBarButtonItem* trashBtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(trashPressed)];
    NSArray* arrayToolBarItems=[[NSArray alloc]initWithObjects:trashBtn,nil];
    UIBarButtonItem* saveBtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed)];
    [self.navigationItem setRightBarButtonItem:saveBtn];
    [self.navigationController setToolbarHidden:NO];
    [self setToolbarItems:arrayToolBarItems];
    [self.view addSubview:_textView];
    [_textView becomeFirstResponder];
    // Do any additional setup after loading the view.
}
#pragma mark --buttonResponse
-(void)trashPressed
{
    _alert = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure to delete this note?"preferredStyle:UIAlertControllerStyleActionSheet];
    [_alert addAction:[UIAlertAction actionWithTitle:@"yes" style:UIAlertActionStyleDestructive handler:
                       ^(UIAlertAction*action)
                       {
                           NSArray *tempArray = [_myDetail objectForKey:@"noteArray"];
                           NSMutableArray *mutableArray = [tempArray mutableCopy];
                           [mutableArray removeObjectAtIndex:_myindex];
                           [_myDetail setObject:mutableArray forKey:@"noteArray"];
                           
                           NSArray *tempDateArray = [_myDetail objectForKey:@"dateArray"];
                           NSMutableArray *mutableDateArray = [tempDateArray mutableCopy];
                           [mutableDateArray removeObjectAtIndex:_myindex];
                           [_myDetail setObject:mutableDateArray forKey:@"dateArray"];
                           
                           [_foldersDetail replaceObjectAtIndex:[_delegate folderindex] withObject:_myDetail];
                           [[NSUserDefaults standardUserDefaults] setObject:_foldersDetail forKey:@"foldersDetail"];
                           [self.navigationController popViewControllerAnimated:YES];
                       }]];
    [_alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:
                       ^(UIAlertAction*action)
                       {}]];
    [self presentViewController:_alert animated:YES completion:nil];
}
-(void)savePressed
{
    
    NSMutableArray* mutableDateArray=[[NSMutableArray alloc]initWithArray:[_myDetail objectForKey:@"dateArray"]];
    NSMutableArray* mutableNoteArray=[[NSMutableArray alloc]initWithArray:[_myDetail objectForKey:@"noteArray"]];
    
    NSString* textstring=[[NSString alloc]initWithString:_textView.text];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init ];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    NSDate *now = [NSDate date];
    NSString *datestring = [dateFormatter stringFromDate:now];
    
    if(_isNew)
    {
        [mutableDateArray insertObject:datestring atIndex:_myindex];
        [mutableNoteArray insertObject:textstring atIndex:_myindex];
    }
    else{
        [mutableDateArray replaceObjectAtIndex:_myindex withObject:datestring];
        [mutableNoteArray replaceObjectAtIndex:_myindex withObject:textstring];
    }
    [_myDetail setObject:mutableNoteArray forKey:@"noteArray"];
    [_myDetail setObject:mutableDateArray forKey:@"dateArray"];
    
    [_foldersDetail replaceObjectAtIndex:[_delegate folderindex] withObject:_myDetail];
    [[NSUserDefaults standardUserDefaults] setObject:_foldersDetail forKey:@"foldersDetail"];
    
    [_delegate isNotNew];
    [self.navigationController popViewControllerAnimated:YES];
    //警告对话框
    /*_alert = [UIAlertController alertControllerWithTitle:@"You have save this note successfully" message:nil preferredStyle:UIAlertControllerStyleAlert];
     [self presentViewController:_alert animated:YES completion:nil];
     [_alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:
     ^(UIAlertAction*action)
     {}]];
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -autoSaveNavigationViewControllerDelegate


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end

//
//  rootViewController.m
//  DemoOfNotes
//
//  Created by Wujianyun on 13/12/2016.
//  Copyright © 2016 yaoyaoi. All rights reserved.
//

#import "rootViewController.h"
#import "folderController.h"
@implementation rootViewController
- (void)viewWillAppear:(BOOL)animated {
    _foldersName = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"foldersName"]];
    if(_foldersName.count){
        [_editBn setEnabled:YES];
    }else{
        [_editBn setEnabled:NO];
    }
    [self.tableView reloadData];
    
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Folders"];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    _editBn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editPressed)];
    _NewFolderBn=[[UIBarButtonItem alloc]initWithTitle:@"New Folder" style:UIBarButtonItemStylePlain target:self action:@selector(addFolder)];
    _fixedSpace =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [_fixedSpace setWidth:250];
    NSArray* arrayToolBarItems=[[NSArray alloc]initWithObjects:_fixedSpace,_NewFolderBn,nil];
    [self.navigationController setToolbarHidden:NO];
    [self.navigationItem setRightBarButtonItem:_editBn];
    [self setToolbarItems:arrayToolBarItems];
    [[NSUserDefaults standardUserDefaults] setObject:_foldersName forKey:@"foldersName"];
    _foldersDetail=[[NSMutableArray alloc]init];
}

#pragma mark -buttonResponse
-(void)addFolder
{
    _alert = [UIAlertController alertControllerWithTitle:@"New Folder" message:@"Enter a name for this folder" preferredStyle:UIAlertControllerStyleAlert];
    [_alert addTextFieldWithConfigurationHandler:
     ^(UITextField*textField)
     {
         textField.placeholder=@"name";
         textField.clearButtonMode=UITextFieldViewModeAlways;
     }];
    [_alert.textFields[0] addTarget:self action:@selector(changeSaveBnState) forControlEvents:UIControlEventEditingChanged];
    [_alert addAction:[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDestructive handler:
                       ^(UIAlertAction*action)
                       {
                           NSMutableDictionary* folderDetail=[[NSMutableDictionary alloc]init];
                           [_foldersDetail insertObject:folderDetail atIndex:_foldersName.count];
                           [[NSUserDefaults standardUserDefaults] setObject:_foldersDetail forKey:@"foldersDetail"];
                           NSString* folderName=[[NSString alloc]initWithString:_alert.textFields[0].text];
                           Folder* newFolder=[[Folder alloc]init];
                           [newFolder setIsNew:YES];
                           [newFolder setMyindex:_foldersName.count];
                           [_foldersName insertObject:folderName atIndex:_foldersName.count];
                           [[NSUserDefaults standardUserDefaults] setObject:_foldersName forKey:@"foldersName"];
                           [self.navigationController pushViewController:newFolder animated:YES];
                       }]];
    [_alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:
                       ^(UIAlertAction*action)
                       {
                           NSLog(@"点击了Cancel按钮");
                       }]];
    [self presentViewController:_alert animated:YES completion:nil];
    [_alert.actions[0] setEnabled:NO];
    /*NSMutableArray* tryArry=[[NSMutableArray alloc]init];
     tryArry[0]=@(1);
     tryArry[1]=@(2);
     self.folderMArray=tryArry;*/
    [self.tableView reloadData];
}
-(void)changeSaveBnState
{
    if(_alert.textFields[0].text.length!=0){
        [_alert.actions[0] setEnabled:YES];
    }else{
        [_alert.actions[0] setEnabled:NO];
    }
}
-(void)editPressed
{
    //按钮变化
    _deleteBn=[[UIBarButtonItem alloc]initWithTitle:@"Delete" style:UIBarButtonItemStylePlain target:self action:@selector(deleteAllPressed)];
    _fixedSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [_fixedSpace setWidth:280];
    NSArray* arrayToolBarItems=[[NSArray alloc]initWithObjects:_fixedSpace,_deleteBn,nil];
    [self setToolbarItems:arrayToolBarItems];
    _doneBn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(backToMain)];
    [self.navigationItem setRightBarButtonItem:_doneBn];
    //单元格变化
    [self.tableView setEditing:YES];
}
//测试用
-(void)deleteAllPressed
{
    _foldersName=[[NSMutableArray alloc]init];
    _foldersDetail=[[NSMutableArray alloc]init];
    [self.tableView reloadData];
    [self backToMain];
}
-(void)backToMain
{
    if(_foldersName.count){
        [_editBn setEnabled:YES];
    }else{
        [_editBn setEnabled:NO];
    }
    [self.tableView setEditing:NO];
    [_fixedSpace setWidth:250];
    [self.navigationItem setRightBarButtonItem:_editBn];
    NSArray* arrayToolBarItems=[[NSArray alloc]initWithObjects:_fixedSpace,_NewFolderBn,nil];
    [self.navigationController setToolbarHidden:NO];
    [self setToolbarItems:arrayToolBarItems];
}
//#pragma mark- UITextFieldDelegate
/*- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
 {
 
 NSMutableString * changedString=[[NSMutableString alloc]initWithString:textField.text];
 [changedString replaceCharactersInRange:range withString:string];
 
 if (changedString.length!=0) {
 [_alert.actions[0] setEnabled:YES];
 }else{
 [_alert.actions[0] setEnabled:NO];
 }
 return YES;
 }*/
#pragma mark -UITableViewDelegate
//手指移动时显示编辑状态
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[_folerName removeObjectAtIndex:indexPath.row];
    //[self.tableView reloadData];
}
//设置编辑状态
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Folder *modifyFolder = [[Folder alloc]init];
    [modifyFolder setMyindex:[indexPath row]];
    [modifyFolder setIsNew:NO];
    [self.navigationController pushViewController:modifyFolder animated:YES];
}
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_foldersName count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"cell";
    
    
    UITableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    if (cell==nil) {
        
        
        cell                    = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        
        
        cell.accessoryType      = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text         = [NSString stringWithFormat:@"%@",[_foldersName objectAtIndex:indexPath.row]];
    
    return cell;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

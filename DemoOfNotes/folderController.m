//
//  folderController.m
//  DemoOfNotes
//
//  Created by Wujianyun on 13/12/2016.
//  Copyright © 2016 yaoyaoi. All rights reserved.
//

#import "folderController.h"
#import "noteController.h"


@interface Folder ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating,isNotNew>
@property UISearchController *searchDC;
@end
@implementation Folder
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _foldersDetail=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"foldersDetail"]];
    _folderDetail=[[NSMutableDictionary alloc]init];
    _folderDetail=[[_foldersDetail objectAtIndex:_myindex] mutableCopy];
    _noteArray = [[NSMutableArray alloc]initWithArray:[_folderDetail objectForKey:@"noteArray"]];
    _dateArray = [[NSMutableArray alloc]initWithArray:[_folderDetail objectForKey:@"dateArray"]];
    if(!_dateArray.count)
    {
        [_editBn setEnabled:NO];
    }else
    {
        [_editBn setEnabled:YES];
    }
    [self.tableView reloadData]; // to reload selected cell
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    //按钮创建-------
    _editBn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editPressed)];
    _composeBn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(addNote)];
    _fixedSpace =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [_fixedSpace setWidth:320];
    NSArray* arrayToolBarItems=[[NSArray alloc]initWithObjects:_fixedSpace,_composeBn,nil];
    [self.navigationController setToolbarHidden:NO];
    [self.navigationItem setRightBarButtonItem:_editBn];
    [self setToolbarItems:arrayToolBarItems];
    _folderName=[[NSUserDefaults standardUserDefaults]objectForKey:@"foldersName"][_myindex];
    [self setTitle:_folderName];
    //--------------
    //搜索功能-------
    /*UISearchBar* searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 44)];
     mySearchResultsViewController  * resultsController = [[mySearchResultsViewController alloc] init];
     _searchDC = [[UISearchController alloc]initWithSearchResultsController:resultsController];
     _searchDC.searchResultsUpdater=self;
     //self.tableView.tableHeaderView = searchBar;
     //self.definesPresentationContext = YES;
     //---------------
     */
}

#pragma mark -buttonResponse
-(void)editPressed
{
    _moveAllBn=[[UIBarButtonItem alloc]initWithTitle:@"Move All" style:UIBarButtonItemStylePlain target:self action:nil];
    _deleteAllBn=[[UIBarButtonItem alloc]initWithTitle:@"Delete All" style:UIBarButtonItemStylePlain target:self action:@selector(deleteAll)];
    _fixedSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [_fixedSpace setWidth:200];
    NSArray* arrayToolBarItems=[[NSArray alloc]initWithObjects:_moveAllBn,_fixedSpace,_deleteAllBn,nil];
    [self setToolbarItems:arrayToolBarItems];
    _cancelBn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backToMain)];
    [self.navigationItem setRightBarButtonItem:_cancelBn];
    //单元格变化
    [self.tableView setEditing:YES];
}
#pragma mark -buttonResponse
-(void)deleteAll
{
    //警示对话框
    _alert = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure to delete all notes?"preferredStyle:UIAlertControllerStyleActionSheet];
    [_alert addAction:[UIAlertAction actionWithTitle:@"yes" style:UIAlertActionStyleDestructive handler:
                       ^(UIAlertAction*action)
                       {
                           //--清除数据
                           NSMutableArray* initNoteArray=[[NSMutableArray alloc]init];
                           [_folderDetail setObject:initNoteArray forKey:@"noteArray"];
                           
                           NSMutableArray *initDateArray = [[NSMutableArray alloc]init];
                           NSMutableArray *mutableDateArray = [initDateArray mutableCopy];
                           
                           [_folderDetail setObject:mutableDateArray forKey:@"dateArray"];
                           _noteArray = [_folderDetail objectForKey:@"noteArray"];
                           _dateArray = [_folderDetail objectForKey:@"dateArray"];
                           
                           [_foldersDetail replaceObjectAtIndex:_myindex withObject:_folderDetail];
                           [[NSUserDefaults standardUserDefaults] setObject:_foldersDetail forKey:@"foldersDetail"];
                           [self.tableView reloadData];
                           [self backToMain];
                       }]];
    [_alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:
                       ^(UIAlertAction*action)
                       {}]];
    [self presentViewController:_alert animated:YES completion:nil];
}
-(void)backToMain
{
    [self.tableView setEditing:NO];
    [_fixedSpace setWidth:320];
    [self.navigationItem setRightBarButtonItem:_editBn];
    if(!_dateArray.count)
    {
        [_editBn setEnabled:NO];
    }else
    {
        [_editBn setEnabled:YES];
    }
    NSArray* arrayToolBarItems=[[NSArray alloc]initWithObjects:_fixedSpace,_composeBn,nil];
    [self setToolbarItems:arrayToolBarItems];
}
-(void)addNote
{
    noteDetailVC* newNote = [[noteDetailVC alloc]init];
    newNote.myindex=self.noteArray.count;
    [newNote setIsNew:YES];
    [self.navigationController pushViewController:newNote animated:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}
#pragma mark --UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    noteDetailVC* modifyNote = [[noteDetailVC alloc]init];
    [self.navigationController pushViewController:modifyNote animated:YES];
    [modifyNote setMyindex:[indexPath row]];
    [modifyNote setIsNew:NO];
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
}
#pragma mark --UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_noteArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"cellIdentifier";
    
    
    UITableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    if (cell==nil) {
        
        
        cell                    = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        
        
        cell.accessoryType      = UITableViewCellAccessoryDisclosureIndicator;
    }
    /* if (tableView == self.searchDC.searchResultsController) {
     note = [_filteredNoteArray objectAtIndex:indexPath.row];
     }
     else if(tableView == self.tableView){
     note = [_noteArray objectAtIndex:indexPath.row];
     };*/
    
    
    cell.textLabel.text       = [NSString stringWithFormat:@"%@",[_noteArray objectAtIndex:indexPath.row]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[_dateArray objectAtIndex:indexPath.row]];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
    return cell;
}
#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    // update the filtered array based on the search text
    NSString *searchText = searchController.searchBar.text;
    //NSMutableArray *searchResults = [self.products mutableCopy];
    
    // strip out all the leading and trailing spaces
    NSString *strippedString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // break up the search terms (separated by spaces)
    NSArray *searchItems = nil;
    if (strippedString.length > 0) {
        searchItems = [strippedString componentsSeparatedByString:@" "];
    }
}
#pragma mark - isNotNew
-(void)isNotNew
{
    [self setIsNew:NO];
}
-(NSInteger)folderindex
{
    return _myindex;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
@end

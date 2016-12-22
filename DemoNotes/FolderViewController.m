//
//  FolderViewController.m
//  DemoNotes
//
//  Created by Wujianyun on 18/12/2016.
//  Copyright © 2016 yaoyaoi. All rights reserved.
//

#import "FolderViewController.h"
#import "NotePage.h"
#import "SqlService.h"
#import "NotePageViewController.h"
#import "SearchResultsViewController.h"
@interface FolderViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate,NotePageUpdateDelegate,UISearchBarDelegate,UISearchResultsUpdating,UISearchControllerDelegate>
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
@property (nonatomic,strong)UISearchBar *searchBar;

@property (nonatomic,strong)UISearchController *searchDispCtrl;

@property (nonatomic,strong)NSArray *noteListArray;

@property (nonatomic,strong)NSMutableArray *dataArray;

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) SearchResultsViewController *searchResultsController;

@end

@implementation FolderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawView];
    
    _noteListArray = [[SqlService sqlInstance] queryNoteDBtableForFolder:_currentFolder];
    _dataArray = [[NSMutableArray alloc]initWithArray:_noteListArray];
    
    [self search];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)search{
    _searchResultsController=[[SearchResultsViewController alloc]init];
    _searchController=[[UISearchController alloc]initWithSearchResultsController:_searchResultsController];
    [_searchController setSearchResultsUpdater:self];
    [_searchController.searchBar sizeToFit];
    _searchResultsController.tableView.delegate = self;
    self.tableView.tableHeaderView=_searchController.searchBar;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    [_searchResultsController setFolderViewController:self];
    self.definesPresentationContext = YES;
    
}
-(void)drawView{
    [self setTitle:_currentFolder.name];
    _editBn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editPressed)];
    _composeBn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(addNote)];
    _fixedSpace =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [_fixedSpace setWidth:320];
    NSArray* arrayToolBarItems=[[NSArray alloc]initWithObjects:_fixedSpace,_composeBn,nil];
    [self.navigationController setToolbarHidden:NO];
    [self.navigationItem setRightBarButtonItem:_editBn];
    [self setToolbarItems:arrayToolBarItems];
    
}
-(void)editPressed{
    
}
-(void)addNote{
    NotePageViewController* notePageVC=[[NotePageViewController alloc]init];
    [notePageVC setCurrentFolder:_currentFolder];
    [notePageVC setDelegate:self];
    [self.navigationController pushViewController:notePageVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _noteListArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indetifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indetifier];
    
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indetifier];
        
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NotePage *notePage=_noteListArray[indexPath.row];
    cell.textLabel.text = notePage.title;
    cell.detailTextLabel.text=notePage.time;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NotePage *selectedNotePage = (tableView == self.tableView) ?
    _noteListArray[indexPath.row] : _searchResultsController.filteredNotes[indexPath.row];
    NotePageViewController *noteController = [[NotePageViewController  alloc]init];
    noteController.delegate = self;
    noteController.currentFolder=_currentFolder;
    noteController.currentPage = selectedNotePage;
    
    [self.navigationController pushViewController:noteController animated:YES];

}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

#pragma mark - updateNoteDelegate
-(void)updateTheNoteList{

    _noteListArray = [[SqlService sqlInstance] queryNoteDBtableForFolder:_currentFolder];
    _currentFolder.numOfNotes=[_noteListArray count];
    NSLog(@"%ld",_currentFolder.numOfNotes);
    [Folder updateFolder:_currentFolder.name currentFolder:_currentFolder];
    [self.tableView reloadData];
    [self.delegate updateTheFolderList];
}
#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}
#pragma mark - UISearchControllerDelegate
- (void)presentSearchController:(UISearchController *)searchController {
    
}

- (void)willPresentSearchController:(UISearchController *)searchController {
    // do something before the search controller is presented
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    // do something after the search controller is presented
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    // do something before the search controller is dismissed
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    // do something after the search controller is dismissed
}
#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *searchText = searchController.searchBar.text;
    NSMutableArray *searchResults = [_noteListArray mutableCopy];
    
    // strip out all the leading and trailing spaces
    NSString *strippedString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // break up the search terms (separated by spaces)
    NSArray *searchItems = nil;
    if (strippedString.length > 0) {
        searchItems = [strippedString componentsSeparatedByString:@" "];
    }
    
    // build all the "AND" expressions for each value in the searchString
    //
    NSMutableArray *andMatchPredicates = [NSMutableArray array];
    
    for (NSString *searchString in searchItems) {
        // each searchString creates an OR predicate for: name, yearIntroduced, introPrice
        //
        // example if searchItems contains "iphone 599 2007":
        //      name CONTAINS[c] "iphone"
        //      name CONTAINS[c] "599", yearIntroduced ==[c] 599, introPrice ==[c] 599
        //      name CONTAINS[c] "2007", yearIntroduced ==[c] 2007, introPrice ==[c] 2007
        //
        NSMutableArray *searchItemsPredicate = [NSMutableArray array];
        
        // Below we use NSExpression represent expressions in our predicates.
        // NSPredicate is made up of smaller, atomic parts: two NSExpressions (a left-hand value and a right-hand value)
        
        // name field matching
        NSExpression *lhs = [NSExpression expressionForKeyPath:@"title"];
        NSExpression *rhs = [NSExpression expressionForConstantValue:searchString];
        NSPredicate *finalPredicate = [NSComparisonPredicate
                                       predicateWithLeftExpression:lhs
                                       rightExpression:rhs
                                       modifier:NSDirectPredicateModifier
                                       type:NSContainsPredicateOperatorType
                                       options:NSCaseInsensitivePredicateOption];
        [searchItemsPredicate addObject:finalPredicate];
        
        // yearIntroduced field matching
       /* NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.numberStyle = NSNumberFormatterNoStyle;
        NSNumber *targetNumber = [numberFormatter numberFromString:searchString];
        if (targetNumber != nil) {   // searchString may not convert to a number
            lhs = [NSExpression expressionForKeyPath:@"yearIntroduced"];
            rhs = [NSExpression expressionForConstantValue:targetNumber];
            finalPredicate = [NSComparisonPredicate
                              predicateWithLeftExpression:lhs
                              rightExpression:rhs
                              modifier:NSDirectPredicateModifier
                              type:NSEqualToPredicateOperatorType
                              options:NSCaseInsensitivePredicateOption];
            [searchItemsPredicate addObject:finalPredicate];
            
            // price field matching
            lhs = [NSExpression expressionForKeyPath:@"introPrice"];
            rhs = [NSExpression expressionForConstantValue:targetNumber];
            finalPredicate = [NSComparisonPredicate
                              predicateWithLeftExpression:lhs
                              rightExpression:rhs
                              modifier:NSDirectPredicateModifier
                              type:NSEqualToPredicateOperatorType
                              options:NSCaseInsensitivePredicateOption];
            [searchItemsPredicate addObject:finalPredicate];
        }*/
        
        // at this OR predicate to our master AND predicate
        NSCompoundPredicate *orMatchPredicates = [NSCompoundPredicate orPredicateWithSubpredicates:searchItemsPredicate];
        [andMatchPredicates addObject:orMatchPredicates];
    }
    
    // match up the fields of the Product object
    NSCompoundPredicate *finalCompoundPredicate =
    [NSCompoundPredicate andPredicateWithSubpredicates:andMatchPredicates];
    searchResults = [[searchResults filteredArrayUsingPredicate:finalCompoundPredicate] mutableCopy];
    
    // hand over the filtered results to our search results table
   SearchResultsViewController *tableController = (SearchResultsViewController *)self.searchController.searchResultsController;
    tableController.filteredNotes = searchResults;
    [tableController.tableView reloadData];
}
@end

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


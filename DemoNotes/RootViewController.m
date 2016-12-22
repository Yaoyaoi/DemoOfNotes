#import "RootViewController.h"
#import "Folder.h"
#import "FolderViewController.h"
#import "SqlService.h"

@interface RootViewController ()<UITableViewDelegate,UITableViewDataSource,FolderUpdateDelegate>
{
    UIBarButtonItem* _deleteBn;
    UIBarButtonItem* _editBn;
    UIBarButtonItem* _doneBn;
    UIBarButtonItem* _fixedSpace;
    UIBarButtonItem* _NewFolderBn;
    UIAlertController* _alert;
}
@property (nonatomic,strong)NSArray *folderListArray;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self drawView];
    
    _folderListArray=[[SqlService sqlInstance] queryFolderDBtable];
    
    // Do any additional setup after loading the view.
}
-(void)drawView{
    _editBn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editPressed)];
    _NewFolderBn=[[UIBarButtonItem alloc]initWithTitle:@"New Folder" style:UIBarButtonItemStylePlain target:self action:@selector(addFolder)];
    _fixedSpace =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [_fixedSpace setWidth:250];
    NSArray* arrayToolBarItems=[[NSArray alloc]initWithObjects:_fixedSpace,_NewFolderBn,nil];
    [self.navigationController setToolbarHidden:NO];
    [self.navigationItem setRightBarButtonItem:_editBn];
    [self setToolbarItems:arrayToolBarItems];
}
#pragma -mark btnResponse
-(void)editPressed{
    
}
-(void)addFolder{
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
                           [Folder createWithName:_alert.textFields[0].text];
                           _folderListArray=[[SqlService sqlInstance]queryFolderDBtable];
                           [self.tableView reloadData];
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
-(void)changeSaveBnState{
    if(_alert.textFields[0].text.length!=0){
        [_alert.actions[0] setEnabled:YES];
    }else{
        [_alert.actions[0] setEnabled:NO];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _folderListArray.count;
}
#pragma -mark UITableView
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *indetifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indetifier];
    
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indetifier];
        
    }
    
    Folder  *folder= _folderListArray[indexPath.row];
    cell.textLabel.text = folder.name;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%ld",folder.numOfNotes];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FolderViewController* folderVC=[[FolderViewController alloc]init];
    
    folderVC.currentFolder= _folderListArray[indexPath.row];
    [folderVC setDelegate:self];
    [self.navigationController pushViewController:folderVC animated:YES];
    
}

-(void)updateTheFolderList{
    _folderListArray= [[SqlService sqlInstance] queryFolderDBtable];
    [self.tableView reloadData];
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

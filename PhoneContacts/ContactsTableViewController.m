//
//  ContactsTableViewController.m
//  PhoneContacts
//
//  Created by - on 6/11/18.
//  Copyright © 2018 liyihan. All rights reserved.
//

#import "ContactsTableViewController.h"
#import "Person.h"
#import "DBManager.h"

@interface ContactsTableViewController ()<UITableViewDelegate,UITableViewDataSource>
//@property (weak, nonatomic) IBOutlet UISearchBar *searchContacts;
@property (weak, nonatomic) IBOutlet UITableView *listContacts;
@property(nonatomic,strong)DBManager *dbManager;
@property (nonatomic,strong) UISearchDisplayController *searchDisplayController;
@property (nonatomic,retain)NSMutableArray *filtered;
@end

@implementation ContactsTableViewController
@synthesize dbManager,listContacts,filtered,searchDisplayController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    printf("ContactsTableView succeed");
    self.dbManager = [DBManager getDBConnection];
//    //添加导航栏的右按钮，回调方法为 toAddViewController
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(toProfileViewController)];
    
    //搜索功能
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    // 添加 searchbar 到 headerview
    self.tableView.tableHeaderView = searchBar;
    // 用 searchbar 初始化 SearchDisplayController
    // 并把 searchDisplayController 和当前 controller 关联起来
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
//    // searchResultsDataSource 就是 UITableViewDataSource
//    searchDisplayController.searchResultsDataSource = self;
//    // searchResultsDelegate 就是 UITableViewDelegate
//    searchDisplayController.searchResultsDelegate = self;
//

    //添加导航栏的左按钮，回调方法为 toSearchViewController
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(toSearchViewController)];
}

// viewWillApear,比如在当前页面即将展现的时候触发的，需要刷新一下列表，比如更新，添加页面，调回的时候，需要刷新一下列表
//页面将要跳回动画结束时
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:true];
    //重新加载数据库中的所有数据
    [self.dbManager loadAllContacts];
    //刷新列表
    [self.tableView reloadData];
    [self.listContacts reloadData];
}
////为添加按钮设置回调方法,只负责跳转一个页面即可
//#pragma mark - barButton target action
-(void)toProfileViewController
{
    //获取storyboard
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];

    //根据storyboard创建控制对象
    UIViewController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"Profile"];

    //跳转界面
    [self.navigationController pushViewController:viewController animated:YES];


}

#pragma mark - Table view data source
/**
 *  返回组数，分组的情况下，因为不分组，所以返回1
 *
 *  @param tableView 当前的tableView
 *
 *  @return 组数
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.001f;
}

#pragma mark - Table view data source

/**
 *  cell显示的内容
 *
 *  @param tableView 当前的tableView
 *  @param indexPath 当前的位置
 *
 *  @return 打包好的cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //获取模型
    Person* currentPerson = self.dbManager.contacts[indexPath.row];
    Person* filteredPerson = filtered[indexPath.row];
    
    //创建表格cell
    UITableViewCell *cell = [listContacts dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    //[tableView registerClass:[cell class] forCellReuseIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    //简单赋值
    if (tableView == self.tableView) {
        cell.textLabel.text = currentPerson.name;
    }else{
        cell.textLabel.text = filteredPerson.name;
    }
    
    return cell;
}

/**
 *  点击行的时候
 *
 *  @param tableView 当前的tableView
 *  @param indexPath 当前的位置
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取当前的模型
    Person* person = self.dbManager.contacts[indexPath.row];
    
    //获得当前的storyboard
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    //获得跳转的ViewController
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"Profile"];
    
    //KVC赋值
    [vc setValue:person forKey:@"person"];
    [vc setValue:indexPath forKey:@"index"];
    
    //跳转
    [self.navigationController pushViewController:vc animated:YES];
}
/**
 *  列表视图能够编辑
 *
 *  @param tableView 当前的tableView
 *  @param indexPath 当前的位置
 *
 *  @return YES表示可以编辑  NO表示不可以编辑
 */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

/**
 *  当前的编辑模式进行相应的操作
 *
 *  @param tableView    当前的tableView
 *  @param editingStyle 编辑的风格
 *  @param indexPath    当前的位置
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //从数据库中删除当前的对象
        [self.dbManager deletePerson:indexPath.row + 1];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


/**
 *  组的行数
 *  @param tableView 当前的tableView
 *  @param section   组的个数
 *  @return 返回每部分的行数
 */
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//
//    return self.dbManager.contacts.count;
//
//}

/*
 * 如果原 TableView 和 SearchDisplayController 中的 TableView 的 delete 指向同一个对象
 * 需要在回调中区分出当前是哪个 TableView
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return self.dbManager.contacts.count;
    }else{
        // 谓词搜索
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",searchDisplayController.searchBar.text];
        filtered =  [[NSMutableArray alloc] initWithArray:[dbManager.contacts filteredArrayUsingPredicate:predicate]];
        return filtered.count;
    }
}


@end

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
//@property (nonatomic,strong) UISearchDisplayController *searchDisplayController;
@property (readwrite,copy)NSMutableArray *filtered;
@property (nonatomic, copy) NSString *filterString;
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation ContactsTableViewController
@synthesize dbManager,listContacts,filtered,searchController,filterString;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dbManager = [DBManager getDBConnection];
//    //添加导航栏的右按钮，回调方法为 toAddViewController
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(toProfileViewController)];
    
    // 创建搜索控制器
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    // 搜索框输入时  更新列表
    self.searchController.searchResultsUpdater = self;
    // 设置为NO的时候 列表的单元格可以点击 默认为YES无法点击无效
    self.searchController.dimsBackgroundDuringPresentation = NO;
    // 设置代理
    self.searchController.delegate = self;
    // 搜索导航栏可见
    [self.searchController.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = NO;
    self.filtered=self.dbManager.contacts;
}

// viewWillApear,比如在当前页面即将展现的时候触发的，需要刷新一下列表，比如更新，添加页面，调回的时候，需要刷新一下列表
//页面将要跳回动画结束时
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:true];
    //重新加载数据库中的所有数据
    [self.dbManager loadAllContacts];
    self.filtered=self.dbManager.contacts;
    //刷新列表
    [self.listContacts reloadData];
    [self.tableView reloadData];
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
//    Person* currentPerson = self.dbManager.contacts[indexPath.row];
    Person* filteredPerson = filtered[indexPath.row];
    
    //创建表格cell
    UITableViewCell *cell = [listContacts dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    //[tableView registerClass:[cell class] forCellReuseIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = filteredPerson.name;
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
    if (!searchController.searchBar.text || searchController.searchBar.text.length <= 0) {
        return YES;
    }else{
        return NO;
    }
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
    self.filtered=self.dbManager.contacts;
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.filtered.count;
}

#pragma mark --- 重写 filterString的set方法
- (void)setFilterString:(NSString *)filterString
{
    // 如果搜索字符串为空 设置结果数组
    if (!filterString || filterString.length <= 0) {
        self.filtered = self.dbManager.contacts;
    } else {
        NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@", filterString];
        filtered =  [[NSMutableArray alloc] initWithArray:dbManager.contacts];
        filtered = [[filtered filteredArrayUsingPredicate:filterPredicate] copy];
    }
    [self.tableView reloadData];
}

- (void)updateSearchResultsForSearchController:(nonnull UISearchController *)searchController {
    if (!searchController.active) {
        return;
    }
    self.filterString = searchController.searchBar.text;
}
#pragma mark --- 设置searchController 代理方法
// 将要返回
- (void)willDismissSearchController:(UISearchController *)searchController
{
    // 点击cancel的时候 数组还原 刷新表
    self.filtered = self.dbManager.contacts;
    [self.tableView reloadData];
}



@end


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
@property (weak, nonatomic) IBOutlet UISearchBar *searchContacts;
@property (weak, nonatomic) IBOutlet UITableView *listContacts;
@property(nonatomic,strong)DBManager *dbManager;
@end

@implementation ContactsTableViewController
@synthesize dbManager,listContacts,searchContacts;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    printf("ContactsTableView succeed");
    self.dbManager = [DBManager getDBConnection];
//    //添加导航栏的右按钮，回调方法为 toAddViewController
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(toProfileViewController)];
    
//
//    //添加导航栏的左按钮，回调方法为 toSearchViewController
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
/**
 *  组的行数
 *  @param tableView 当前的tableView
 *  @param section   组的个数
 *  @return 返回每部分的行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dbManager.contacts.count;

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
    
    //创建表格cell
    UITableViewCell *cell = [listContacts dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    //[tableView registerClass:[cell class] forCellReuseIdentifier:@"Cell"];
    //简单赋值
    cell.textLabel.text = currentPerson.name;
    cell.detailTextLabel.text = currentPerson.phone;
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
    



@end

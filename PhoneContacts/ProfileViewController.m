//
//  ProfileViewController.m
//  PhoneContacts
//
//  Created by - on 6/19/18.
//  Copyright © 2018 liyihan. All rights reserved.
//

#import "ProfileViewController.h"
#import "DBManager.h"
#import "Person.h"

@interface ProfileViewController ()
@property (strong, nonatomic) IBOutlet UITextField *nameText;
@property (strong, nonatomic) IBOutlet UITextField *phoneText;
@property (strong, nonatomic) IBOutlet UITextField *wechatText;
@property (strong, nonatomic) IBOutlet UITextField *addressText;
@property (strong, nonatomic) IBOutlet UITextField *emailText;
@property (nonatomic,strong) DBManager *dbManager;

//更新时专用
@property(strong,nonatomic)Person *person;
@property(nonatomic,strong)NSIndexPath * index;

@end

@implementation ProfileViewController
@synthesize dbManager,nameText,phoneText,wechatText,addressText,emailText;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dbManager = [DBManager getDBConnection];
    //设置导航的右上角按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(addOrUpdate)];
    if (self.person)
    {
        self.navigationItem.title = @"Edit Contact";
        //赋值
        self.nameText.text = self.person.name;
        self.phoneText.text = self.person.phone;
        self.wechatText.text = self.person.wechat;
        self.addressText.text = self.person.address;
        self.emailText.text = self.person.email;
    }
    
    else
    {
        self.navigationItem.title = @"New Contact";
    }
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(2, 5, 50, 25);
    [btn addTarget:self action:@selector(dismissKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"Done"forState:UIControlStateNormal];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    NSArray * buttonsArray = [NSArray   arrayWithObjects:btnSpace,doneBtn,nil];
    [topView setItems:buttonsArray];
    [nameText setInputAccessoryView:topView];
    [phoneText setInputAccessoryView:topView];
    [wechatText setInputAccessoryView:topView];
    [addressText setInputAccessoryView:topView];
    [emailText setInputAccessoryView:topView];

}
-(void)addOrUpdate
{
    
    //初始化
    Person* person = [[Person alloc]initWithName:nameText.text phone:phoneText.text wechat:wechatText.text address:addressText.text email:emailText.text];
    
    //表示更新
    if (self.person)
    {
        //更新到数据库
        [self.dbManager updatePerson:person withIndex:self.index.row + 1];
    }
    //表示添加
    else
    {
        //添加到数据库sqlite
        [self.dbManager addPerson:person];
    }
    //调回原页面
    [self.navigationController popViewControllerAnimated:YES];
}
//收起键盘
-(void)dismissKeyBoard
{
    [nameText resignFirstResponder];
    [phoneText resignFirstResponder];
    [wechatText resignFirstResponder];
    [addressText resignFirstResponder];
    [emailText resignFirstResponder];
}
- (IBAction)sharePressed:(id)sender
{
    NSArray *contact = @[nameText.text,phoneText.text,wechatText.text,addressText.text,emailText.text];
    UIActivityViewController *activityController=[[UIActivityViewController alloc]initWithActivityItems:contact applicationActivities:nil];
    [self.navigationController presentViewController:activityController animated:YES completion:nil];
}
- (IBAction)callPressed
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneText.text]];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}


@end

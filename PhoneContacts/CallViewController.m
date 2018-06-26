//
//  CallViewController.m
//  PhoneContacts
//
//  Created by - on 6/18/18.
//  Copyright © 2018 liyihan. All rights reserved.
//


#import "CallViewController.h"
#import "DBManager.h"
#import "Person.h"

@interface CallViewController()
@property(nonatomic) BOOL isEntering;
@property (strong, nonatomic) IBOutlet UIButton *btnDelete;
@property (strong, nonatomic) IBOutlet UIButton *btnAdd;
@property (nonatomic,strong) DBManager *dbManager;
@end

@implementation CallViewController
@synthesize display,isEntering,btnDelete,btnAdd,dbManager;

- (IBAction)digitPressed:(UIButton*)sender {
    NSString *digit=[sender currentTitle];
    printf("digitPressed");
    if(self.isEntering){
        self.display.text = [self.display.text stringByAppendingString:digit];
        self.btnDelete.hidden=NO;
        self.btnAdd.hidden=NO;
    }else{
        self.display.text=digit;
        self.isEntering=YES;
    }
}

- (IBAction)enterPressed {
    self.isEntering = NO;
    //调用系统拨号
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.display.text]];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

- (IBAction)deletePressed
{
    if([self.display.text length] > 0){
        self.display.text = [self.display.text substringToIndex:([self.display.text length]-1)];// 去掉最后一个","
    }else{
        self.btnDelete.hidden=YES;
        self.btnAdd.hidden=YES;
    }
}

- (IBAction)addPressed
{
    self.dbManager = [DBManager getDBConnection];
    //提示框添加文本输入框
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Create New Contact"
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
    //响应事件
                                                         if(alert.textFields[0].text.length>0){
                                                             Person* person = [[Person alloc]initWithName:alert.textFields[0].text phone:alert.textFields[1].text wechat:@"" address:@"" email:@""];
                                                             [self.dbManager addPerson:person];
                                                         }
                                                         else{
                                                             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please fill in Name!" preferredStyle:UIAlertControllerStyleAlert];

                                                             UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];

                                                             [alert addAction:okAction];
                                                             [self presentViewController:alert animated:YES completion:nil];
                                                         }
                                                     }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {
                                                             //响应事件
                                                             NSLog(@"action = %@", alert.textFields);
                                                         }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Name";

    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text=self.display.text;
        textField.placeholder = @"Number";
    }];

    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end

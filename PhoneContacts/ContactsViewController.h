//
//  ContactsViewController.h
//  PhoneContacts
//
//  Created by - on 6/9/18.
//  Copyright © 2018 liyihan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactsViewController : UIViewController<UITableViewDelegate>

{
    UITableView *tableview;
    NSArray *array; //创建个数组来放我们的数据
}
@property (strong,nonatomic)UITableView *tableview;

@property (strong,nonatomic)NSArray *array;

@end


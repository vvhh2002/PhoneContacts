//
//  ContactsViewController.m
//  PhoneContacts
//
//  Created by - on 6/9/18.
//  Copyright © 2018 liyihan. All rights reserved.
//

#import "ContactsViewController.h"

@interface ContactsViewController ()

@end

@implementation ContactsViewController

@synthesize tableview;

@synthesize array;

- (void)viewDidLoad

{
    [super viewDidLoad];
    
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,self.view.bounds.size.width,self.view.bounds.size.height)style:UITableViewStylePlain];
    //    UITableViewStylePlain,
    //    UITableViewStyleGrouped
    
    tableview.delegate =self;
    [self.view addSubview:tableview];
    
    NSMutableArray *arrayValue = [[NSMutableArray alloc]init];
    
    for (int i = 0; i< 10; i++)
        
    {
        NSString *value = [NSString stringWithFormat:@"%d",i];
        [arrayValue addObject:value];
    }
    
    array = arrayValue;
    
    
    
}

- (void)didReceiveMemoryWarning

{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    
}


@end

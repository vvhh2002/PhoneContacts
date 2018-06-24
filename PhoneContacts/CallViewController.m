//
//  CallViewController.m
//  PhoneContacts
//
//  Created by - on 6/18/18.
//  Copyright © 2018 liyihan. All rights reserved.
//


#import "CallViewController.h"

@interface CallViewController()
@property(nonatomic) BOOL isEntering;
@property (strong, nonatomic) IBOutlet UIButton *btnContacts;
@property (strong, nonatomic) IBOutlet UIButton *btnDelete;
@end
@implementation CallViewController

@synthesize display,isEntering,btnContacts,btnDelete;

- (IBAction)digitPressed:(UIButton*)sender {
    NSString *digit=[sender currentTitle];
    printf("digitPressed");
    if(self.isEntering){
        self.display.text = [self.display.text stringByAppendingString:digit];
        self.btnContacts.hidden=NO;
        self.btnDelete.hidden=NO;
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




@end

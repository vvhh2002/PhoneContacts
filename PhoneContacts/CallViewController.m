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
@end
@implementation CallViewController

@synthesize display;
@synthesize isEntering;



- (IBAction)digitPressed:(UIButton*)sender {
    NSString *digit=[sender currentTitle];
    printf("digitPressed");
    if(self.isEntering){
        self.display.text = [self.display.text stringByAppendingString:digit];
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

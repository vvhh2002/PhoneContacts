//
//  CallViewController.m
//  PhoneContacts
//
//  Created by - on 6/9/18.
//  Copyright © 2018 liyihan. All rights reserved.
//

#import "CallViewController.h"

@interface CallViewController ()
@property(nonatomic) BOOL isEntering;
@end

@implementation CallViewController
@synthesize display;
@synthesize isEntering;
- (IBAction)digitPressed:(id)sender
{
    NSString *digit=[sender currentTitle];
    if(self.isEntering){
        self.display.text = [self.display.text stringByAppendingString:digit];
    }else{
        self.display.text=digit;
        self.isEntering=YES;
    }
}
- (IBAction)callPressed
{
    
}


@end

//
//  CallViewController.h
//  PhoneContacts
//
//  Created by - on 6/9/18.
//  Copyright © 2018 liyihan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *display;

- (IBAction)digitPressed:(id)sender;
- (IBAction)callPressed;

@end


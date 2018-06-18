//
//  CallViewController.h
//  PhoneContacts
//
//  Created by - on 6/18/18.
//  Copyright © 2018 liyihan. All rights reserved.
//

#ifndef CallViewController_h
#define CallViewController_h
#import <UIKit/UIKit.h>

@interface CallViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *display;

- (IBAction)digitPressed:(id)sender;

- (IBAction)enterPressed;


@end



#endif /* CallViewController_h */

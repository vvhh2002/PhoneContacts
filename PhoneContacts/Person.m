//
//  Person.m
//  PhoneContacts
//
//  Created by - on 6/18/18.
//  Copyright © 2018 liyihan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"
#import "sqlite3.h"
@interface Person()

@end
@implementation Person
@synthesize ID,name,phone,wechat,address,email;
-(id)initWithName:(NSString *)initName phone:(NSString *)initPhone wechat:(NSString *)initWechat address:(NSString*)initAddress  email:(NSString *)initEmail
{
    self = [super init];
    if (self) {
        self.name=initName;
        self.phone=initPhone;
        self.wechat=initWechat;
        self.address=initAddress;
        self.email=initEmail;
    }
    return self;
}


-(void)addPerson
{
    
}
-(void)deletePerson
{
    
}
-(void)updatePerson:(NSString *)str andType:(int)type
{
    
}
-(void)searchPerson:(NSString *)str
{
    
}
@end

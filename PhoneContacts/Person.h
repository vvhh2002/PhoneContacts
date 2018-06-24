//
//  Person.h
//  PhoneContacts
//
//  Created by - on 6/18/18.
//  Copyright © 2018 liyihan. All rights reserved.
//

#ifndef Person_h
#define Person_h
@interface Person : NSObject
@property (nonatomic, assign) int ID;
@property (nonatomic, copy) NSString *name,*phone,*wechat,*address,*email;

-(id)initWithName:(NSString*)initName phone:(NSString*)initPhone wechat:(NSString*)initWechat address:(NSString*)initAddress email:(NSString*)initEmail;

@end
#endif /* Person_h */

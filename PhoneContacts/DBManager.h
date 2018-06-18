//
//  DBManager.h
//  PhoneContacts
//
//  Created by - on 6/18/18.
//  Copyright © 2018 liyihan. All rights reserved.
//

#ifndef DBManager_h
#define DBManager_h
#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Person.h"
@interface DBManager: NSObject
{
    NSString *dbName;
    NSString *dbPath;
    NSMutableArray *contacts;
}
@property (nonatomic,retain)NSMutableArray *contacts;

-(void)addPerson:(Person*)newPerson;
-(void)updatePerson:(Person*)updatedPerson withIndex:(NSInteger)index;
-(void)deletePerson:(NSInteger)index;
-(void)searchPerson:(NSString*)searchKeyword;
+(instancetype)getDBConnection;
-(void)loadAllContacts;

@end


#endif /* DBManager_h */

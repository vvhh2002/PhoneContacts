//
//  DBManager.m
//  PhoneContacts
//
//  Created by - on 6/18/18.
//  Copyright © 2018 liyihan. All rights reserved.
//

#import "DBManager.h"
#import "Person.h"
@interface DBManager()
@property(nonatomic)sqlite3 *database;
@end

@implementation DBManager
@synthesize contacts,database;
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.contacts = [NSMutableArray array];
        [self openDatabase];
        [self loadAllContacts];
    }
    return self;
}
+(instancetype)getDBConnection
{
    static DBManager* dbManager=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        dbManager = [[DBManager alloc]init];
    });
    printf("getDBConnection succeed");
    return dbManager;
}
-(void)openDatabase
{
    NSString *localPathDB=[[NSBundle mainBundle] pathForResource:@"contacts" ofType:@"db"];
    
    //获取沙盒目录
    NSString * pathSandBox = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
//    NSString *pathLibrary = [pathSandBox stringByAppendingString:@"/Library"];
    //数据库名称
    NSString * pathDB = [pathSandBox stringByAppendingPathComponent:@"contacts.db"];
    [[NSFileManager defaultManager]copyItemAtPath:localPathDB toPath:pathDB error:nil];
//    BOOL isFilePresent = [self copyMissingFile:localPathDB toPath:pathLibrary];
//    if(isFilePresent){
//        NSLog(@"copy succeed");
//    }else{
//        NSLog(@"copy fail");
//    }
    
    //打开数据库
    sqlite3_open([pathDB UTF8String], &database);
}
- (BOOL)copyMissingFile:(NSString *)sourcePath toPath:(NSString *)toPath
{
    BOOL retVal = YES; // If the file already exists, we'll return success…
    NSString * finalLocation = [toPath stringByAppendingPathComponent:[sourcePath lastPathComponent]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:finalLocation])
    {
        retVal = [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:finalLocation error:NULL];
    }
    return retVal;
}

-(void)createTable
{
    //创建表的SQL语句,用C语言的字符串，如果用了NSString,记得转成C语言字符串即可
    const char * createTableSQL = "create table if not exists person(id integer primary key autoincrement not null,name text,phone text,wechat text,address text,email text)";
    
    //执行,第一个参数是sqlite3对象指针，第二个是C语言类型的SQL语句，后面3个参数填NULL即可
    sqlite3_exec(database, createTableSQL, NULL, NULL, NULL);
    
}
-(void)loadAllContacts
{
    [self.contacts removeAllObjects];
    const char *sql = "SELECT * FROM person ORDER BY name";//首字母排序
    sqlite3_stmt * stmt;
    sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    while(sqlite3_step(stmt)==SQLITE_ROW)
    {
        Person *newPerson = [[Person alloc]initWithName:[NSString stringWithUTF8String:(char*)(sqlite3_column_text(stmt, 1))]
                                phone:[NSString stringWithUTF8String:(char*)(sqlite3_column_text(stmt, 2))]
                                wechat:[NSString stringWithUTF8String:(char*)(sqlite3_column_text(stmt, 3))]
                                address:[NSString stringWithUTF8String:(char*)(sqlite3_column_text(stmt, 4))]
                            email:[NSString stringWithUTF8String:(char*)(sqlite3_column_text(stmt, 5))]];
        newPerson.ID=sqlite3_column_int(stmt, 0);
        [self.contacts addObject:newPerson];
    }
    
    sqlite3_finalize(stmt);
    
}
-(void)addPerson:(Person*)newPerson
{
    [self.contacts addObject:newPerson];
    const char *sql = "INSERT INTO person(name,phone,wechat,address,email)VALUES(?,?,?,?,?)";
    sqlite3_stmt * stmt;
    sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    sqlite3_bind_text(stmt, 1, [newPerson.name UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 2, [newPerson.phone UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 3, [newPerson.wechat UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 4, [newPerson.address UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 5, [newPerson.email UTF8String], -1, NULL);
    int rst=sqlite3_step(stmt);
    if(rst == SQLITE_DONE){
        sqlite3_commit_hook(database, NULL, NULL);
        NSLog(@"insert succeed");
    }
    else
    {
        sqlite3_rollback_hook(database, NULL, NULL);
        NSLog(@"insert fail.No:%d",rst);
    }
    
    sqlite3_finalize(stmt);
}
-(void)deletePerson:(NSInteger)index
{
    NSInteger currentID = ((Person*)self.contacts[index-1]).ID;
    [self.contacts removeObjectAtIndex:index-1];
    const char *sql = "DELETE FROM person WHERE id=?";
    sqlite3_stmt * stmt;
    sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    sqlite3_bind_int(stmt,1, (int)currentID);
    int rst=sqlite3_step(stmt);
    if(rst == SQLITE_DONE){
        NSLog(@"delete succeed");
    }
    else
    {
        NSLog(@"delete fail.No:%d",rst);
    }
    sqlite3_finalize(stmt);
}
-(void)updatePerson:(Person*)updatedPerson withIndex:(NSInteger)index
{
    NSInteger currentID = ((Person*)self.contacts[index-1]).ID;
    [self.contacts replaceObjectAtIndex:index-1 withObject:updatedPerson];
    const char *sql = "UPDATE person SET name=?,phone=?,wechat=?,address=?,email=? WHERE id=?";
    sqlite3_stmt * stmt;
    sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
    sqlite3_bind_text(stmt, 1, [updatedPerson.name UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 2, [updatedPerson.phone UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 3, [updatedPerson.wechat UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 4, [updatedPerson.address UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 5, [updatedPerson.email UTF8String], -1, NULL);
    sqlite3_bind_int(stmt, 6, (int)currentID);
    int rst=sqlite3_step(stmt);
    if(rst == SQLITE_DONE){
        sqlite3_commit_hook(database, NULL, NULL);
        NSLog(@"update succeed");
    }
    else
    {
        sqlite3_rollback_hook(database, NULL, NULL);
        NSLog(@"update fail.No:%d",rst);
    }
    sqlite3_finalize(stmt);
}

-(void)closeDatabase
{
    sqlite3_close(database);
}
-(void)dealloc
{
    [self closeDatabase];
}
@end

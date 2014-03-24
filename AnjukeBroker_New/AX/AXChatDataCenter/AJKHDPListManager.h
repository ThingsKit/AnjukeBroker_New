//
//  LPListManager.h
//
//  Created by casa on 10/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AJKHDPListManager : NSObject

@property (nonatomic, strong, readonly) NSString *fileName;
@property (nonatomic, copy) id listData; //plist中读出的数据
@property (nonatomic, readonly) BOOL isBundle; //是否从bunlde读取

/*  */

////////////////////////////  以下都是老版本的函数，这些函数还是会用到的，所以就不删了  //////////////////////////////

/** 这个函数会根据文件名在bundle或Library目录下读取内容，不用带后缀。 */
- (id)initWithFileName:(NSString *)fileName isBundle:(BOOL)isBundle;
/** 如果想在没有plist文件的情况下自动创建用这个，不用带后缀.只会在Library中查找文件或者创建文件。 */
- (id)initWithFileNameAutoCreate:(NSString *)fileName;
- (BOOL)save;

////////////////////////////////////////////////////////////////////////////////////////////////////////////

/* 
    以下涉及的filename都不需要带.plist的后缀, 如果文件名是@"abc.plist",那么传入的参数就是 @"abc"
 
    所有的plist文件都是在NSLibraryDirectory目录下。
 */

- (BOOL)isExistWithFileNameInLibrary:(NSString *)plistFileName;
- (BOOL)isExistWithFileNameInBundle:(NSString *)plistFileName;

/** 
    如果文件不存在的话就新建一个，如果文件已经存在的话，就会删掉已经有的文件重新创建一个
    data只能传NSArray或者NSDictionary
 */
- (BOOL)saveData:(id)data withFileName:(NSString *)fileName;
- (BOOL)saveString:(NSString *)string withFileName:(NSString *)fileName;

/** 如果文件不存在的话返回YES */
- (BOOL)deletePlistFile:(NSString *)fileName;

- (id)loadDataWithFileName:(NSString *)fileName;
- (NSString *)loadStringWithFileName:(NSString *)fileName;

- (void)appendString:(NSString *)string toFileName:(NSString *)filename;
- (id)loadFileWithName:(NSString *)filename;


@end

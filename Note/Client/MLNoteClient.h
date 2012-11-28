//
//  MLNoteClient.h
//  Note
//
//  Created by mah_lab on 2012/11/28.
//  Copyright (c) 2012年 mah-lab. All rights reserved.
//

#import "AFHTTPClient.h"

@interface MLNoteClient : AFHTTPClient

+ (MLNoteClient *) sharedClient;

- (void)setEmail:(NSString *)email password:(NSString *)password;

// Noteの一覧を取得する
- (void)getIndexWhenSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(int statusCode, NSString *errorString))failure;

// 指定したnoteIdのNoteを更新する
- (void)putNoteWithId:(int)noteId
                title:(NSString *)title
                 body:(NSString *)body
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(int statusCode, NSString *errorString))failure;

// Noteを新規作成する
- (void)createNoteWithTitle:(NSString *)title
                       body:(NSString *)body
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(int statusCode, NSString *errorString))failure;

// 指定したnoteIdのNoteを削除する
- (void)destroyNoteWithId:(int)noteId
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(int statusCode, NSString *errorString))failure;

@end
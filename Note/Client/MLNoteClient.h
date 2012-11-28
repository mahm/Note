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

- (void)getIndexWhenSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(int statusCode, NSString *errorString))failure;

@end

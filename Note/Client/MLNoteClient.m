//
//  MLNoteClient.m
//  Note
//
//  Created by mah_lab on 2012/11/28.
//  Copyright (c) 2012年 mah-lab. All rights reserved.
//

#import "MLNoteClient.h"

#define kBaseUrl @"http://iphone-note.dev/"
#define kToken @"token"

@interface MLNoteClient ()
@end

@implementation MLNoteClient

#pragma mark - Class methods

static MLNoteClient* _sharedClient;
+ (MLNoteClient *) sharedClient
{
    if (!_sharedClient) {
        _sharedClient = [[MLNoteClient alloc] init];
    }
    return _sharedClient;
}

#pragma mark - Instance methods

- (id) init
{
    if (self = [super initWithBaseURL:[NSURL URLWithString:kBaseUrl]]) {
        // initialize code
    }
    return self;
}

- (void)setEmail:(NSString *)email password:(NSString *)password
{
    [self clearAuthorizationHeader];
    [self setAuthorizationHeaderWithUsername:email password:password];
}

- (void)getIndexWhenSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(int statusCode, NSString *errorString))failure
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            kToken, @"token",
                            nil];
    [self getPath:@"notes.json"
       parameters:params
          success:success
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              failure([self statusCodeFromOperation:operation], [self errorStringFromOperation:operation]);
          }];
}

- (void)putNoteWithId:(int)noteId
                title:(NSString *)title
                 body:(NSString *)body
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(int statusCode, NSString *errorString))failure
{
    NSDictionary *note = [NSDictionary dictionaryWithObjectsAndKeys:
                          title, @"title",
                          body, @"body",
                          nil];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            kToken, @"token",
                            note, @"note",
                            nil];
    [self putPath:[NSString stringWithFormat:@"notes/%d", noteId]
       parameters:params
          success:success
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              failure([self statusCodeFromOperation:operation], [self errorStringFromOperation:operation]);
          }];
}

- (void)createNoteWithTitle:(NSString *)title
                       body:(NSString *)body
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(int statusCode, NSString *errorString))failure
{
    NSDictionary *note = [NSDictionary dictionaryWithObjectsAndKeys:
                          title, @"title",
                          body, @"body",
                          nil];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            kToken, @"token",
                            note, @"note",
                            nil];
    [self postPath:@"notes"
       parameters:params
          success:success
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              failure([self statusCodeFromOperation:operation], [self errorStringFromOperation:operation]);
          }];
}

- (void)destroyNoteWithId:(int)noteId
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(int statusCode, NSString *errorString))failure
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            kToken, @"token",
                            nil];
    [self deletePath:[NSString stringWithFormat:@"notes/%d", noteId]
        parameters:params
           success:success
           failure:^(AFHTTPRequestOperation *operation, NSError *error){
               failure([self statusCodeFromOperation:operation], [self errorStringFromOperation:operation]);
           }];
    
}


#pragma mark - Helper methods

- (int) statusCodeFromOperation:(AFHTTPRequestOperation *)operation
{
    return operation.response.statusCode;
}

- (NSString *)errorStringFromOperation:(AFHTTPRequestOperation *)operation
{
    return [[operation.responseData objectFromJSONData] valueForKey:@"errors"];
}

@end

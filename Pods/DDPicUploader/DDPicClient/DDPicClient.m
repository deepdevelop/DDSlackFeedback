//
//  DDPicClient.m
//  DDFeedbackDemo
//
//  Created by im61 on 15/10/11.
//  Copyright © 2015年 DeepDevelop. All rights reserved.
//

#import "DDPicClient.h"
#import "AFHTTPSessionManager.h"
#import "AFURLRequestSerialization.h"
#import "AFHTTPRequestOperationManager.h"

static NSString * const kPicpxBaseURL = @"http://picpx.com";
static NSString * const kUpyunBaseURL = @"http://v0.api.upyun.com";
static NSString * const kImageBaseURL = @"http://deeppic.b0.upaiyun.com";

@interface DDPicClient ()

@property (nonatomic, strong) AFHTTPSessionManager *picPxManager;
@property (nonatomic, strong) AFHTTPSessionManager *upyunManager;

@end


@implementation DDPicClient

+ (instancetype)sharedClient {
    static DDPicClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedClient = [[DDPicClient alloc] init];
    });
    
    return _sharedClient;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _picPxManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kPicpxBaseURL]];
        _picPxManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _picPxManager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        _upyunManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kUpyunBaseURL]];
        _upyunManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _upyunManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    
    return self;
}

- (void)upload:(NSData *)data
     imageName:(NSString *)imageName
    completion:(void (^)(NSError *error, NSString *url, NSDictionary *result))completion {
    [self requestPolicyAndSignatureWithImageName:imageName Completion:^(NSError *error, NSDictionary *result) {
        if (error) {
            if (completion) {
                completion(error, nil, nil);
            }
        } else {
            NSString *policy = result[@"policy"];
            NSString *signature = result[@"signature"];
            
            [self upload:data
               imageName:imageName
                  policy:policy
               signature:signature
              completion:^(NSError *error, NSDictionary *result) {
                  NSURL *baseURL = [NSURL URLWithString:kImageBaseURL];
                  NSString *path = result[@"url"];
                  NSURL *imageURL = [NSURL URLWithString:path relativeToURL:baseURL];
                  
                  if (completion) {
                      completion(error, imageURL.absoluteString, result);
                  }
              }];
        }
    }];
}

- (void)requestPolicyAndSignatureWithImageName:(NSString *)imageName Completion:(void (^)(NSError *error, NSDictionary *result))completion {
    [_picPxManager POST:@"uptoken"
             parameters:@{@"image": imageName}
                success:^(NSURLSessionDataTask *task, id responseObject) {
                    if (completion) {
                        completion(nil, responseObject);
                    }
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    if (completion) {
                        completion(error, nil);
                    }
                }];
}

- (void)upload:(NSData *)data
     imageName:(NSString *)imageName
        policy:(NSString *)policy
     signature:(NSString *)signature
    completion:(void (^)(NSError *error, NSDictionary *result))completion {
    NSDictionary *params = @{@"policy": policy, @"signature": signature};
    
    [_upyunManager POST:@"deeppic"
             parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                 [formData appendPartWithFileData:data name:@"file" fileName:imageName mimeType:@"image/png"];
             } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                 NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
                 if (completion) {
                     completion(nil, result);
                 }
             } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                 if (completion) {
                     completion(error, nil);
                 }
             }];
}
@end

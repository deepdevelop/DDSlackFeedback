//
//  DDSlackWebHookClient.m
//  SlackIncomingWebhooksDemo
//
//  Created by im61 on 15/10/11.
//  Copyright © 2015年 DeepDevelop. All rights reserved.
//

#import "DDSlackWebhookClient.h"
#import "AFHTTPSessionManager.h"
#import "AFURLRequestSerialization.h"
#import "AFHTTPRequestOperationManager.h"

@interface DDSlackWebhookClient ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSURL *webhookURL;
@property (nonatomic, strong) NSString *path;

@end

@implementation DDSlackWebhookClient

+ (instancetype)withWebhookURL:(NSURL *)webhookURL {
    DDSlackWebhookClient *client = [DDSlackWebhookClient sharedClient];
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        client.webhookURL = webhookURL;
    });
    
    return client;
}

+ (instancetype)sharedClient {
    static DDSlackWebhookClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedClient = [[DDSlackWebhookClient alloc] init];
    });
    
    return _sharedClient;
}

- (void)setWebhookURL:(NSURL *)webhookURL {
    _webhookURL = webhookURL;
    
    NSString *baseURLString = [NSString stringWithFormat:@"%@://%@", _webhookURL.scheme, _webhookURL.host];
    NSString *path = [[[_webhookURL pathComponents] componentsJoinedByString:@"/"] substringFromIndex:2];
    
    self.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseURLString]];
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    self.path = path;
}

- (void)postNotificationToChannel:(NSString *)channel
                             text:(NSString *)text
                         username:(NSString *)username
                          iconURL:(NSURL *)iconURL
                        iconEmoji:(NSString *)iconEmoji
                       completion:(void (^)(NSError *error))completion {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (channel) {
        params[@"channel"] = channel;
    }
    
    if (!text) {
        text = @"test incoming webhook";
    }
    
    if (username) {
        params[@"username"] = username;
    }
    
    if (iconURL) {
        params[@"icon_url"] = iconURL.absoluteString;
    }
    
    if (iconEmoji) {
        params[@"icon_emoji"] = iconEmoji;
    }
    
    params[@"text"] = text;
    
    [self.manager POST:self.path
            parameters:params
               success:^(NSURLSessionDataTask *task, id responseObject) {
                   if (completion) {
                       completion(nil);
                   }
               } failure:^(NSURLSessionDataTask *task, NSError *error) {
                   if (completion) {
                       completion(error);
                   }
               }];
}

@end

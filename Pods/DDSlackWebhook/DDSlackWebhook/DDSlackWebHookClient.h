//
//  DDSlackWebhookClient.h
//  SlackIncomingWebhooksDemo
//
//  Created by im61 on 15/10/11.
//  Copyright © 2015年 DeepDevelop. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface DDSlackWebhookClient : NSObject

/**
 * Initialize DDSlackWebhookClient. Call this method within your App Delegate's `application:didFinishLaunchingWithOptions:` and provide the slack incoming webhook url
 *
 * @param webhookURL the incoming webhook url from your Slack
 *
 * @return Returns the shared Fabric instance. In most cases this can be ignored.
 */

+ (instancetype)withWebhookURL:(NSURL *)webhookURL;

/**
 *  Returns the DDSlackWebhookClient singleton object.
 */

+ (instancetype)sharedClient;

/**
 *  Post notification to Slack Channel or a Direct Message to someone
 *
 *  @param channel      channel name or user id. example: #general or @61
 *  @param text         notification content
 *  @param username     displayed name
 *  @param iconURL      bot icon url
 *  @param iconEmoji    bot icon emoji
 *  @param completion   callback
 */

- (void)postNotificationToChannel:(NSString *)channel
                             text:(NSString *)text
                         username:(NSString *)username
                          iconURL:(NSURL *)iconURL
                        iconEmoji:(NSString *)iconEmoji
                       completion:(void (^)(NSError *error))completion;

@end

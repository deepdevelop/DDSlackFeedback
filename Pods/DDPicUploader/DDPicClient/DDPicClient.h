//
//  DDPicClient.h
//  DDFeedbackDemo
//
//  Created by im61 on 15/10/11.
//  Copyright © 2015年 DeepDevelop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDPicClient : NSObject

+ (instancetype)sharedClient;

- (void)upload:(NSData *)data
     imageName:(NSString *)imageName
    completion:(void (^)(NSError *error, NSString *url, NSDictionary *result))completion;

@end

//
//  DDSlackFeedbackManager.h
//  DDFeedbackDemo
//
//  Created by im61 on 15/10/12.
//  Copyright © 2015年 DeepDevelop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDSlackFeedbackManager : NSObject

+ (instancetype)withWebhookURL:(NSURL *)webhookURL;
+ (instancetype)sharedManager;

- (void)submitFeedback:(NSString *)feedback;
- (void)takeSnapShotForViewController:(UIViewController *)viewController submitFeedback:(NSString *)feedback;

@end

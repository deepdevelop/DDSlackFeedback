//
//  DDSlackFeedbackManager.m
//  DDFeedbackDemo
//
//  Created by im61 on 15/10/12.
//  Copyright © 2015年 DeepDevelop. All rights reserved.
//

#import "DDPicClient.h"
#import "DDSlackWebHookClient.h"
#import "DDSlackFeedbackManager.h"

@implementation DDSlackFeedbackManager

+ (instancetype)withWebhookURL:(NSURL *)webhookURL {
    DDSlackFeedbackManager *manager = [DDSlackFeedbackManager sharedManager];
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        [DDSlackWebhookClient withWebhookURL:webhookURL];
    });
    
    return manager;
}

+ (instancetype)sharedManager {
    static DDSlackFeedbackManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedManager = [[DDSlackFeedbackManager alloc] init];
    });
    
    return _sharedManager;
}

- (void)submitFeedback:(NSString *)feedback {
    [[DDSlackWebhookClient sharedClient] postNotificationToChannel:nil
                                                              text:feedback
                                                          username:nil
                                                           iconURL:nil
                                                         iconEmoji:nil
                                                        completion:nil];
}

- (void)takeSnapShotForViewController:(UIViewController *)viewController submitFeedback:(NSString *)feedback {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *snapshot = [self takeSnapShotForViewController:viewController];
        
        [[DDPicClient sharedClient] upload:UIImagePNGRepresentation(snapshot)
                                 imageName:@"screencapture.png"
                                completion:^(NSError *error, NSString *url, NSDictionary *result) {
            if (!error) {
                NSString *text = [NSString stringWithFormat:@"%@\n%@", url, feedback];
                [[DDSlackWebhookClient sharedClient] postNotificationToChannel:nil
                                                                          text:text
                                                                      username:nil
                                                                       iconURL:nil
                                                                     iconEmoji:nil
                                                                    completion:nil];
            }
        }];
    });
}

- (UIImage *)takeSnapShotForViewController:(UIViewController *)viewController {
    CGSize size = viewController.view.window.frame.size;
    
    UIGraphicsBeginImageContext(size);
    
    [viewController.view.window drawViewHierarchyInRect:CGRectMake(0, 0, size.width, size.height) afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end

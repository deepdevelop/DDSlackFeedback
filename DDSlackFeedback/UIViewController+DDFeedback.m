//
//  UIViewController+DDShake.m
//  DDFeedbackDemo
//
//  Created by im61 on 15/10/11.
//  Copyright © 2015年 DeepDevelop. All rights reserved.
//

#import "DDPicClient.h"
#import "DDSlackFeedbackManager.h"
#import "UIViewController+DDFeedback.h"

@implementation UIViewController (DDFeedback)

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"反馈"
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *captureScreenAction = [UIAlertAction actionWithTitle:@"截屏提交"
                                                                      style:UIAlertActionStyleDefault
                                                                    handler:^(UIAlertAction *action) {
                                                                        UITextField *textField = (UITextField *)alertController.textFields.firstObject;
                                                                        NSString *feedback = textField.text;
                                                                        
                                                                        NSTimeInterval delaySeconds = 1;
                                                                        
                                                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                            [[DDSlackFeedbackManager sharedManager] takeSnapShotForViewController:self
                                                                                                                                   submitFeedback:feedback];
                                                                        });
                                                                    }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"直接提交"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action) {
                                                             UITextField *textField = (UITextField *)alertController.textFields.firstObject;
                                                             NSString *feedback = textField.text;
                                                             
                                                             [[DDSlackFeedbackManager sharedManager] submitFeedback:feedback];
                                                         }];
        
        [alertController addAction:okAction];
        [alertController addAction:captureScreenAction];
        [alertController addAction:cancelAction];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
            textField.placeholder = @"输入需要反馈的问题";
        }];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


@end

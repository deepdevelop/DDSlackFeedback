# DDSlackWebhook

DDSlackWebhook is a simple client post notification to your slack channel use slack incoming webhooks. Written in Objective-c.

## Installation

#### CocoaPods

	
#### Source File
You can copy all the files under the `DDSlackWebhook` folder into your project.

## Usage

```objective-c

// Config
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [DDSlackWebhookClient withWebhookURL:[NSURL URLWithString:@""]];
    
    return YES;
}

// Post
[[DDSlackWebhookClient sharedClient] postNotificationToChannel:nil
                                                          text:nil
                                                      username:nil
                                                       iconURL:nil
                                                     iconEmoji:nil
                                                    completion:nil];

```

## Dependency

- AFNetworking

## Author

Liu Yi, 61upup@gmail.com

## License

DDSlackWebhook is available under the MIT license. See the LICENSE file for more info.
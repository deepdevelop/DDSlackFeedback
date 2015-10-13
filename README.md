# DDSlackFeedback

DDSlackFeedback help you easily post user text or image feedback to your slack channel, The only the your need
to do is shake your device.

## Installation

#### CocoaPods
	platform :ios, '8.0'
	pod 'DDSlackFeedback'

#### Source File
You can copy all the files under the `DDSlackFeedback` folder into your project.

## iOS 9

You need add exception domains in your plist file

	picpx.com
	v0.api.upyun.com

## Usage

```objective-c

	[DDSlackFeedbackManager withWebhookURL:[NSURL URLWithString:YOURWEBHOOKURL]];

```

## Author

Liu Yi, 61upup@gmail.com

## License

DDSlackFeedback is available under the MIT license. See the LICENSE file for more info.

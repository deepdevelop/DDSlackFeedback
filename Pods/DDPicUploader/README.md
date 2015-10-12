# DDPicUploader

DDPicUploader is a simple client upload image to picpx.com. Written in Objective-c.

## Installation

#### CocoaPods

	pod 'DDPicUploader'

#### Source File
You can copy all the files under the `DDPicUploader` folder into your project.

## iOS 9 

You need add exception domains in your plist file

	picpx.com
	v0.api.upyun.com
	
## Usage

```objective-c

[[DDPicClient sharedClient] upload:image
						 imageName:@"screencapture.png"
						completion:^(NSError *error, NSDictionary *result) {
        				}];

```

## Dependency

- AFNetworking

## Author

Liu Yi, 61upup@gmail.com

## License

DDPicUploader is available under the MIT license. See the LICENSE file for more info.

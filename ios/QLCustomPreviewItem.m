//  RNCustomPreviewItem.m
//  RNReactNativeDocViewer
//
//  Created by Minh Le on 3/27/18.
//  Copyright © 2018 Facebook. All rights reserved.
#import <Foundation/Foundation.h>
#import "QLCustomPreviewItem.h"

@implementation QLCustomPreviewItem

@synthesize previewItemURL = _previewItemURL;
@synthesize previewItemTitle = _previewItemTitle;
-(id)initWithURL:(NSURL *)url optionalFileName:(NSString *)optionalFileName {
    self = [super init];
    if(self != nil) {
        _previewItemURL = url;
        _previewItemTitle = optionalFileName ? optionalFileName : [url lastPathComponent];
    }
    return self;
}

@end


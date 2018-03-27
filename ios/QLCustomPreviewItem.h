//  QLCustomPreviewItem.h
//  RNReactNativeDocViewer
//
//  Created by Minh Le on 3/27/18.
//  Copyright © 2018 Facebook. All rights reserved.
#import <Foundation/Foundation.h>
#import <QuickLook/QuickLook.h>

@interface  QLCustomPreviewItem : NSObject<QLPreviewItem>

-(id)initWithURL:(NSURL *)url optionalFileName:(NSString *)optionalFileName;

@end



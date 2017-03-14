//
//  RNReactNativeDocViewer.h
//  RNReactNativeDocViewer
//
//  Created by Philipp Hecht on 10/03/17.
//  Copyright (c) 2017 Philipp Hecht. All rights reserved.
//
#if __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import <React/RCTBridgeModule.h>
#endif
#import <Foundation/Foundation.h>
#import <QuickLook/QuickLook.h>

@interface RNReactNativeDocViewer : NSObject <RCTBridgeModule, QLPreviewControllerDelegate, QLPreviewControllerDataSource, QLPreviewItem>
@property (strong, nonatomic) NSURL* fileUrl;
@property (readonly) NSURL* previewItemURL;
@end
  

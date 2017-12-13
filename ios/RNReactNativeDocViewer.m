//
//  RNReactNativeDocViewer.m
//  RNReactNativeDocViewer
//
//  Created by Philipp Hecht on 10/03/17.
//  Copyright (c) 2017 Philipp Hecht. All rights reserved.
//
#import "RNReactNativeDocViewer.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#if __has_include("RCTLog.h")
#import "RCTLog.h"
#else
#import <React/RCTLog.h>
#endif


@implementation RNReactNativeDocViewer
@synthesize alert = _alert;
CGFloat prog;

RCT_EXPORT_MODULE()

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

RCT_EXPORT_METHOD(testModule:(NSString *)name location:(NSString *)location)
{
    RCTLogInfo(@"TEST Module %@ at %@", name, location);
}

RCT_EXPORT_METHOD(statusProgress:(Boolean *)progress callback:(RCTResponseSenderBlock)callback)
{
    //NSArray *events = ...
    if(progress){
        callback(@[[NSNull null], @(prog)]);
    }else {
        callback(@[[NSNull null], @"no progress defined"]);
    }
    
}

/**
 * openDoc
 * open Base64 String
 * Parameters: NSArray
 */
RCT_EXPORT_METHOD(openDoc:(NSArray *)array callback:(RCTResponseSenderBlock)callback)
{

    __weak RNReactNativeDocViewer* weakSelf = self;
    //Download Progress
    NSDictionary* dict_download = [array objectAtIndex:0];
    NSString* urlStrdownload = dict_download[@"url"];
    [self hitServerForUrl:urlStrdownload];
    //Download END
    /*_alert = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    _downloadProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    _downloadProgressView.frame = CGRectMake(20, 20, 200, 15);
    _downloadProgressView.progress = 0.5;
    UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    progressView.progress = 0.75f;
    [[UIProgressView appearance] setFrame:CGRectMake(20, 100, 280, 50)];
    [progressView.layer setCornerRadius:4];
    progressView.layer.masksToBounds = TRUE;
    progressView.clipsToBounds = TRUE;
    
    [_alert addSubview: progressView];
    [_alert show];*/
    dispatch_queue_t asyncQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(asyncQueue, ^{
        NSDictionary* dict = [array objectAtIndex:0];
        NSString* urlStr = dict[@"url"];
        NSString* fileNameOptional = dict[@"fileNameOptional"];
        NSURL* url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSData* dat = [NSData dataWithContentsOfURL:url];
        RCTLogInfo(@"Url %@", url);
        RCTLogInfo(@"FileNameOptional %@", fileNameOptional);
        NSArray *parts = [urlStr componentsSeparatedByString:@"/"];
        NSString *fileNameExported = [parts lastObject];
        //Custom Filename
        NSString *fileName = @"";
        if([fileNameOptional length] > 0){
            NSString* fileExt = [fileNameExported pathExtension];
            fileName = [NSString stringWithFormat:@"%@%c%@", fileNameOptional , '.', fileExt];
        }else{
            //get File Name example a.pdf from Url http://xyz/a.pdf
            fileName = [NSString stringWithFormat:@"%@", fileNameExported];
        }
        
        //From the www
        if ([urlStr containsString:@"http"] || [urlStr containsString:@"https"]) {
            if (dat == nil) {
                if (callback) {
                    callback(@[[NSNull null], @"Doc Url not found"]);
                }
                return;
            }

            NSString* path = [NSTemporaryDirectory() stringByAppendingPathComponent: fileName];
            NSURL* tmpFileUrl = [[NSURL alloc] initFileURLWithPath:path];
            [dat writeToURL:tmpFileUrl atomically:YES];
            weakSelf.fileUrl = tmpFileUrl;
            (int)(100.0*prog);
            
        } else {
            
            NSURL* tmpFileUrl = [[NSURL alloc] initFileURLWithPath:urlStr];
            weakSelf.fileUrl = tmpFileUrl;
        }


        dispatch_async(dispatch_get_main_queue(), ^{
            QLPreviewController* cntr = [[QLPreviewController alloc] init];
            cntr.delegate = weakSelf;
            cntr.dataSource = weakSelf;
            if (callback) {
                callback(@[[NSNull null], array]);
            }
            UIViewController* root = [[[UIApplication sharedApplication] keyWindow] rootViewController];
            while (root.presentedViewController) {
                root = [root presentedViewController];
            }
            
          
            [root presentViewController:cntr animated:YES completion:^{
                //[_alert dismissWithClickedButtonIndex:0 animated:YES];
            }];
        });

    });
}


/**
 * BinaryinUrl
 * open Url with a Binary String
 * Parameters: NSArray
 */
RCT_EXPORT_METHOD(openDocBinaryinUrl:(NSArray *)array callback:(RCTResponseSenderBlock)callback)
{
    __weak RNReactNativeDocViewer* weakSelf = self;
    dispatch_queue_t asyncQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(asyncQueue, ^{
        NSDictionary* dict = [array objectAtIndex:0];
        NSString* url = dict[@"url"];
        NSString* filename = dict[@"fileName"];
        NSString* filetype = dict[@"fileType"];
        //NSArray* splitUrl = [url componentsSeparatedByString: @"/"];
        //NSString* binaryString = [splitUrl lastObject];
        //Parse the Binary from URL
        //NSData* byteArrayString = [binaryString dataUsingEncoding:NSUTF8StringEncoding];
         //NSLog(@"%@", byteArrayString);
        NSURL* urlbinary = [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSData* dat = [NSData dataWithContentsOfURL:urlbinary];
        if (dat == nil) {
            if (callback) {
                callback(@[[NSNull null], @"DATA nil"]);
            }
            return;
        }
        NSString* fileName = [NSString stringWithFormat:@"%@%@%@", filename, @".", filetype];
        NSString* fileExt = [fileName pathExtension];
        if([fileExt length] == 0){
            fileName = [NSString stringWithFormat:@"%@%@", fileName, @".pdf"];
        }
        NSString* path = [NSTemporaryDirectory() stringByAppendingPathComponent: fileName];
        NSURL* tmpFileUrl = [[NSURL alloc] initFileURLWithPath:path];

        [dat writeToURL:tmpFileUrl atomically:YES];
        weakSelf.fileUrl = tmpFileUrl;

        dispatch_async(dispatch_get_main_queue(), ^{
            QLPreviewController* cntr = [[QLPreviewController alloc] init];
            cntr.delegate = weakSelf;
            cntr.dataSource = weakSelf;
            if (callback) {
                callback(@[[NSNull null], @"Data"]);
            }
            UIViewController* root = [[[UIApplication sharedApplication] keyWindow] rootViewController];
            while (root.presentedViewController) {
                root = [root presentedViewController];
            }
            [root presentViewController:cntr animated:YES completion:nil];
        });

    });
}

/**
 * openDocb64
 * open Base64 String
 * Parameters: NSArray
 */
RCT_EXPORT_METHOD(openDocb64:(NSArray *)array callback:(RCTResponseSenderBlock)callback)
{

    __weak RNReactNativeDocViewer* weakSelf = self;
    dispatch_queue_t asyncQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(asyncQueue, ^{
        NSDictionary* dict = [array objectAtIndex:0];
        NSString* base64String = dict[@"base64"];
        NSString* filename = dict[@"fileName"];
        NSString* filetype = dict[@"fileType"];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"data:application/octet-stream;base64,%@",base64String]];
        NSData* dat = [NSData dataWithContentsOfURL:url];
        if (dat == nil) {
            if (callback) {
                callback(@[[NSNull null], @"DATA nil"]);
            }
            return;
        }
        NSString* fileName = [NSString stringWithFormat:@"%@%@%@", filename, @".", filetype];
        NSString* fileExt = [fileName pathExtension];
        if([fileExt length] == 0){
            fileName = [NSString stringWithFormat:@"%@%@", fileName, @".pdf"];
        }
        NSString* path = [NSTemporaryDirectory() stringByAppendingPathComponent: fileName];
        NSURL* tmpFileUrl = [[NSURL alloc] initFileURLWithPath:path];

        [dat writeToURL:tmpFileUrl atomically:YES];
        weakSelf.fileUrl = tmpFileUrl;

        dispatch_async(dispatch_get_main_queue(), ^{
            QLPreviewController* cntr = [[QLPreviewController alloc] init];
            cntr.delegate = weakSelf;
            cntr.dataSource = weakSelf;
            if (callback) {
                callback(@[[NSNull null], @"Data"]);
            }
            UIViewController* root = [[[UIApplication sharedApplication] keyWindow] rootViewController];
            while (root.presentedViewController) {
                root = [root presentedViewController];
            }
            [root presentViewController:cntr animated:YES completion:nil];
        });

    });
}


//Movie Files mp4
RCT_EXPORT_METHOD(playMovie:(NSString *)file callback:(RCTResponseSenderBlock)callback)
{
    //NSDictionary* dict = [array objectAtIndex:0];
    NSString *_uri = file;
    
    
    NSURL *fileURL = nil;
    if ([_uri containsString:@"http"] || [_uri containsString:@"https"]) {
        fileURL = [NSURL URLWithString:_uri];
    }else{
        NSString* mediaFilePath = [[NSBundle mainBundle] pathForResource:_uri ofType:nil];
        NSAssert(mediaFilePath, @"Media not found: %@", _uri);
        fileURL = [NSURL fileURLWithPath:mediaFilePath];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        
        AVPlayerViewController *movieViewController = [[AVPlayerViewController alloc] init];
        
        movieViewController.player = [AVPlayer playerWithURL:fileURL];
        
        [movieViewController.player play];
        
        movieViewController = movieViewController;
        
        UIViewController *ctrl = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        UIView *view = [ctrl view];
        
        view.window.windowLevel = UIWindowLevelStatusBar;
        if (callback) {
            callback(@[[NSNull null], @"true"]);
        }
        
        [ctrl presentViewController:movieViewController animated:TRUE completion: nil];
        
    });
}

- (NSInteger) numberOfPreviewItemsInPreviewController: (QLPreviewController *) controller
{
    return 1;
}

- (id <QLPreviewItem>) previewController: (QLPreviewController *) controller previewItemAtIndex: (NSInteger) index
{
    return self;
}

#pragma mark - QLPreviewItem protocol

- (NSURL*)previewItemURL
{
    return self.fileUrl;
}


//Download Task example
- (void)hitServerForUrl:(NSString*)urlString {
    NSURL *requestUrl = [NSURL URLWithString:urlString];
    
    NSURLSessionConfiguration *defaultConfigurationObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfigurationObject delegate:self delegateQueue: nil];
    
    NSURLSessionDownloadTask *fileDownloadTask = [defaultSession downloadTaskWithURL:requestUrl];
    
    [fileDownloadTask resume];
    
}

/*- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSURL *documentsDirectoryURL = [NSURL fileURLWithPath:documentsPath];
    NSURL *documentURL = [documentsDirectoryURL URLByAppendingPathComponent:[downloadTask.response suggestedFilename]];
    NSError *error;
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:[downloadTask.response suggestedFilename]];
    NSLog(@"file path : %@", filePath);
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        //Remove the old file from directory
    }
    
    [[NSFileManager defaultManager] moveItemAtURL:location
                                            toURL:documentURL
                                            error:&error];
    if (error){
        //Handle error here
    }
}*/

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error != nil) {
        NSData *resumeData = error.userInfo[NSURLSessionDownloadTaskResumeData];
        self.downloadResumeData = resumeData;
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    dispatch_sync(dispatch_get_main_queue(), ^{
        float progressValue = totalBytesWritten/totalBytesExpectedToWrite;
        prog = (float)totalBytesWritten/totalBytesExpectedToWrite;
        NSLog(@"downloaded %d%%", (int)(100.0*prog));
        //NSLog(@"downloaded 1 %f%%", progressValue);
        
    });
}



@end

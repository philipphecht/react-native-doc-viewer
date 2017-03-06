
#import <UIKit/UIKit.h>
#import "RNReactNativeDocViewer.h"
#import <React/RCTLog.h>

@implementation RNReactNativeDocViewer

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(open: (NSURL *)path)
{
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL:path];
    interactionController.delegate = self;
    [interactionController presentPreviewAnimated:YES];
}

RCT_EXPORT_METHOD(addEvent:(NSString *)name location:(NSString *)location)
{
    RCTLogInfo(@"Pretending to create an event %@ at %@", name, location);
}

- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller
{
    return [[[[UIApplication sharedApplication] delegate] window] rootViewController];
}


@end
  

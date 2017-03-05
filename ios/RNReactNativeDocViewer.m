
#import <UIKit/UIKit.h>
#import "RNReactNativeDocViewer.h"

@implementation RNReactNativeDocViewer


- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(open: (NSURL *)path)
{
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL:path];
    interactionController.delegate = self;
    [interactionController presentPreviewAnimated:YES];
}

- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller
{
    return [[[[UIApplication sharedApplication] delegate] window] rootViewController];
}


@end
  

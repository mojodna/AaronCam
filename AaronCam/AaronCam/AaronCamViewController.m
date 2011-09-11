//
//  AaronCamViewController.m
//  AaronCam
//

#import "AaronCamViewController.h"

#import <MobileCoreServices/UTCoreTypes.h>


@implementation AaronCamViewController

@synthesize request=_request;

#pragma mark - Object lifecycle

- (void)dealloc
{
    [_request release];

    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    OFFlickrAPIContext *context = [[OFFlickrAPIContext alloc] initWithAPIKey:@"API_KEY"
                                                                sharedSecret:@"SHARED_SECRET"];
    
    self.request = [[[OFFlickrAPIRequest alloc] initWithAPIContext:context] autorelease];
    self.request.delegate = self;
    
    [context release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    self.request = nil;
}

#pragma mark - Local methods

- (IBAction)showCamera:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
        NSLog(@"No camera available.");
        return;
    }

    UIImagePickerController *cameraController = [[UIImagePickerController alloc] init];

    // use the camera, not the film strip
    cameraController.sourceType = UIImagePickerControllerSourceTypeCamera;

    // photos and video
    cameraController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];

    // post-facto editing
    cameraController.allowsEditing = YES;
    cameraController.delegate = self;

    [self presentModalViewController:cameraController
                            animated:YES];

    [cameraController release];
}

#pragma mark - UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];

    if (CFStringCompare((CFStringRef)mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        UIImage *image;
        UIImage *editedImage = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
        UIImage *originalImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            image = editedImage;
        } else {
            image = originalImage;
        }

        // upload the photo to Flickr
        NSData *imageData = UIImagePNGRepresentation(image); // UIImageJPEGRepresentation is also an option
        NSInputStream *imageStream = [NSInputStream inputStreamWithData:imageData];
        [self.request uploadImageStream:imageStream
                      suggestedFilename:@"whatever.jpg"
                               MIMEType:@"image/png"
                              arguments:[NSDictionary dictionaryWithObjectsAndKeys:
                                         @"0", @"is_public",
                                         nil]
         ];
    }
    
    if (CFStringCompare((CFStringRef)mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
//        NSString *moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
    
        // TODO upload video to Flickr here
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Objective Flickr delegate methods

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest
 didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
    NSLog(@"Flickr request completed with: %@", inResponseDictionary);
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest
        didFailWithError:(NSError *)inError
{
    NSLog(@"Flickr request failed with error: %@", inError);
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest
    imageUploadSentBytes:(NSUInteger)inSentBytes
              totalBytes:(NSUInteger)inTotalBytes
{
    NSLog(@"%i / %i bytes sent", inSentBytes, inTotalBytes);
}

@end

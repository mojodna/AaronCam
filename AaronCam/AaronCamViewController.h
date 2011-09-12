//
//  AaronCamViewController.h
//  AaronCam
//

#import "ObjectiveFlickr.h"


@class OFFlickrAPIRequest;

@interface AaronCamViewController : UIViewController <OFFlickrAPIRequestDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
  @private
    OFFlickrAPIRequest *_request;
}

@property (nonatomic, retain) OFFlickrAPIRequest *request;

@end

//
//  ZPAttacchmentThumbnailFactory.m
//  ZotPad
//
//  Created by Rönkkö Mikko on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ZPAttachmentThumbnailFactory.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>
#import "ZPLogger.h"

@implementation ZPAttachmentThumbnailFactory


static ZPAttachmentThumbnailFactory* _instance;
static NSCache* _fileTypeImageCache;

+(ZPAttachmentThumbnailFactory*) instance{
    if(_instance == NULL){
        _instance = [[ZPAttachmentThumbnailFactory alloc] init];
        _fileTypeImageCache = [[NSCache alloc] init];
    }
    return _instance;
}

//TODO: Refactor: remove redundant code

-(UIImage*) getFiletypeImageForURL:(NSURL*)url height:(NSInteger)height width:(NSInteger)width{

    UIDocumentInteractionController* docController = [UIDocumentInteractionController interactionControllerWithURL:url];

    UIImage* image;

    //Get the largest image that can fit
    
    for(UIImage* icon in docController.icons) {
        
        if(icon.size.width<width && icon.size.height<height) image=icon;
        else{
            if(image==NULL) image=icon;
            break;   
        }
    }
    
    NSLog(@"Using image with size ( %f x %f )",image.size.width,image.size.height);
    
    return image;

}

-(UIImage*) getFiletypeImageForAttachment:(ZPZoteroAttachment*)attachment height:(NSInteger)height width:(NSInteger)width{
    
    NSString* key = [NSString stringWithFormat:@"%@%ix%i",attachment.contentType,height,width];
    
    UIImage* image = [_fileTypeImageCache objectForKey:key];
    
    if(image==NULL){
        NSLog(@"Getting file type image for %@ (%ix%i)",attachment.contentType,height,width);
        
        // Source: http://stackoverflow.com/questions/5876895/using-built-in-icons-for-mime-type-or-uti-type-in-ios
        
        //Need to initialize this way or the doc controller doesn't work
        NSURL*fooUrl = [NSURL URLWithString:@"file://foot.dat"];
        UIDocumentInteractionController* docController = [UIDocumentInteractionController interactionControllerWithURL:fooUrl];
        
        //Need to convert from mime type to a UTI to be able to get icons for the document
        CFStringRef mime = (__bridge CFStringRef) attachment.contentType;
        NSString *uti = (__bridge NSString*) UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType,mime, NULL);
        
        //Tell the doc controller what UTI type we want
        docController.UTI = uti;
        
        //Get the smalles image that does not fit anymore and scale it down
        
        for(UIImage* icon in docController.icons) {
            
            image=icon;
            NSLog(@"Comparing image with size ( %f x %f ) to requested size ( %i x %i )",image.size.width,image.size.height,width,height);

            if(icon.size.width>width && icon.size.height>height){
                NSLog(@"Image chosen");
                break;      
            }
        }
        
        NSLog(@"Using image with size ( %f x %f )",image.size.width,image.size.height);
        
        [_fileTypeImageCache setObject:image forKey:key];
    }
    
    return image;

}

@end
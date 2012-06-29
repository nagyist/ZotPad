//
//  ZPUploadVersionConflictViewControllerViewController.m
//  ZotPad
//
//  Created by Mikko Rönkkö on 27.6.2012.
//  Copyright (c) 2012 Helsiki University of Technology. All rights reserved.
//

#import "ZPUploadVersionConflictViewControllerViewController.h"
#import "ZPDatabase.h"
#import "ZPAttachmentIconViewController.h"

// A helper class for showing an original version of the attachment


@interface ZPUploadVersionConflictViewControllerViewController ()

@end

@implementation ZPUploadVersionConflictViewControllerViewController

@synthesize attachment, label, carousel, fileChannel,secondaryCarousel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    _carouselDelegate = [[ZPAttachmentCarouselDelegate alloc] init];
    
    //iPhone shows the versions in carousel. On iPad they are shown in separate carousels
    
    if(secondaryCarousel==NULL){
        [_carouselDelegate configureWithAttachmentArray:[NSArray arrayWithObjects:attachment, attachment, nil]];
        _carouselDelegate.mode = ZPATTACHMENTICONGVIEWCONTROLLER_MODE_FIRST_STATIC_SECOND_DOWNLOAD;
        _carouselDelegate.show = ZPATTACHMENTICONGVIEWCONTROLLER_SHOW_FIRST_MODIFIED_SECOND_ORIGINAL;
    }
    else{
        [_carouselDelegate configureWithAttachmentArray:[NSArray arrayWithObject:attachment]];
        _carouselDelegate.mode = ZPATTACHMENTICONGVIEWCONTROLLER_MODE_STATIC;
        _carouselDelegate.show = ZPATTACHMENTICONGVIEWCONTROLLER_SHOW_MODIFIED;
    }
    _carouselDelegate.carousel = carousel;
    carousel.delegate = _carouselDelegate;
    carousel.dataSource = _carouselDelegate;

    
    if(secondaryCarousel!=NULL){
        _secondaryCarouselDelegate = [[ZPAttachmentCarouselDelegate alloc] init];
        _secondaryCarouselDelegate.mode = ZPATTACHMENTICONGVIEWCONTROLLER_MODE_DOWNLOAD;
        _secondaryCarouselDelegate.show = ZPATTACHMENTICONGVIEWCONTROLLER_SHOW_ORIGINAL;
        [_secondaryCarouselDelegate configureWithAttachmentArray:[NSArray arrayWithObject: attachment]];
        _secondaryCarouselDelegate.carousel = secondaryCarousel;
        secondaryCarousel.delegate = _secondaryCarouselDelegate;
        secondaryCarousel.dataSource = _secondaryCarouselDelegate;
    }
    
    label.text = [NSString stringWithFormat:@"File '%@' has changed on server",attachment.filename];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Actions

-(IBAction)useMyVersion:(id)sender{
    attachment.versionIdentifier_local = attachment.versionIdentifier_server;
    [[ZPDatabase instance] writeVersionInfoForAttachment:attachment];
    [fileChannel startUploadingAttachment:attachment];
    [self dismissModalViewControllerAnimated:YES];
}
-(IBAction)useRemoteVersion:(id)sender{
    attachment.versionIdentifier_local = [NSNull null];
    [[NSFileManager defaultManager] removeItemAtPath:attachment.fileSystemPath_modified error:NULL];
    [[ZPDatabase instance] writeVersionInfoForAttachment:attachment];
    [fileChannel cancelUploadingAttachment:attachment];
    [self dismissModalViewControllerAnimated:YES];
}


@end
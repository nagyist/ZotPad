//
//  ZPLogViewController.h
//  ZotPad
//
//  Created by Mikko Rönkkö on 30.6.2012.
//  Copyright (c) 2012 Mikko Rönkkö. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPLogViewController : UIViewController  <MFMailComposeViewControllerDelegate, QLPreviewControllerDataSource>

@property (retain) IBOutlet UITextView* logView;
@property (retain) IBOutlet UIBarButtonItem* manualButton;

-(IBAction)showManual:(id)sender;
-(IBAction)onlineSupport:(id)sender;
-(IBAction)emailSupport:(id)sender;
-(IBAction)manageKey:(id)sender;
-(IBAction)dismiss:(id)sender;

@end
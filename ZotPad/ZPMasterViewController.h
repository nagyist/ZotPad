//
//  ZPMasterViewController.h
//  ZotPad
//
//  Created by Rönkkö Mikko on 11/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPDetailViewController.h"
#import "ZPDataLayer.h"

@class ZPDetailViewController;

@interface ZPMasterViewController : UITableViewController{
    ZPDataLayer* _database;
    NSArray* _content;
    NSInteger _currentLibrary;
    NSInteger _currentCollection;
}

@property (strong, nonatomic) ZPDetailViewController *detailViewController;
@property NSInteger currentLibrary;
@property NSInteger currentCollection;

@end

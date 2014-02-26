//
//  AlbumPickerController.h
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AXELCAssetSelectionDelegate.h"
#import "AXELCAssetPickerFilterDelegate.h"

@interface AXELCAlbumPickerController : UITableViewController <AXELCAssetSelectionDelegate>

@property (nonatomic, weak) id<AXELCAssetSelectionDelegate> parent;
@property (nonatomic, strong) NSMutableArray *assetGroups;

// optional, can be used to filter the assets displayed
@property (nonatomic, weak) id<AXELCAssetPickerFilterDelegate> assetPickerFilterDelegate;

@end


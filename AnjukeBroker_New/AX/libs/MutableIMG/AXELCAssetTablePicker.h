//
//  ELCAssetTablePicker.h
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AXELCAsset.h"
#import "AXELCAssetSelectionDelegate.h"
#import "AXELCAssetPickerFilterDelegate.h"

@interface AXELCAssetTablePicker : UITableViewController <AXELCAssetDelegate>

@property (nonatomic, weak) id <AXELCAssetSelectionDelegate> parent;
@property (nonatomic, strong) ALAssetsGroup *assetGroup;
@property (nonatomic, strong) NSMutableArray *elcAssets;
@property (nonatomic, strong) IBOutlet UILabel *selectedAssetsLabel;
@property (nonatomic, assign) BOOL singleSelection;
@property (nonatomic, assign) BOOL immediateReturn;

// optional, can be used to filter the assets displayed
@property(nonatomic, weak) id<AXELCAssetPickerFilterDelegate> assetPickerFilterDelegate;

- (int)totalSelectedAssets;
- (void)preparePhotos;

- (void)doneAction:(id)sender;

@end
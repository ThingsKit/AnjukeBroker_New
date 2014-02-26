//
//  Asset.h
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class AXELCAsset;

@protocol AXELCAssetDelegate <NSObject>

@optional
- (void)assetSelected:(AXELCAsset *)asset;
- (BOOL)shouldSelectAsset:(AXELCAsset *)asset;
@end


@interface AXELCAsset : NSObject

@property (nonatomic, strong) ALAsset *asset;
@property (nonatomic, weak) id<AXELCAssetDelegate> parent;
@property (nonatomic, assign) BOOL selected;

- (id)initWithAsset:(ALAsset *)asset;

@end
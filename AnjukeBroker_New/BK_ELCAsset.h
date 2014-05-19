//
//  Asset.h
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class BK_ELCAsset;

@protocol ELCAssetDelegate <NSObject>

@optional
- (void)assetSelected:(BK_ELCAsset *)asset;
- (BOOL)shouldSelectAsset:(BK_ELCAsset *)asset;
@end


@interface BK_ELCAsset : NSObject

@property (nonatomic, strong) ALAsset *asset;
@property (nonatomic, weak) id<ELCAssetDelegate> parent;
@property (nonatomic, assign) BOOL selected;

- (id)initWithAsset:(ALAsset *)asset;

@end
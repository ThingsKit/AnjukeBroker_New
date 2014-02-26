//
//  ELCAssetSelectionDelegate.h
//  ELCImagePickerDemo
//
//  Created by JN on 9/6/12.
//  Copyright (c) 2012 ELC Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AXELCAsset;

@protocol AXELCAssetSelectionDelegate <NSObject>

- (void)selectedAssets:(NSArray *)assets;
- (BOOL)shouldSelectAsset:(AXELCAsset *)asset previousCount:(NSUInteger)previousCount;

@end

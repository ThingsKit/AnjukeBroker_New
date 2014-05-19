//
// ELCAssetPickerFilterDelegate.h

@class BK_ELCAsset;
@class BK_ELCAssetTablePicker;

@protocol ELCAssetPickerFilterDelegate<NSObject>

// respond YES/NO to filter out (not show the asset)
-(BOOL)assetTablePicker:(BK_ELCAssetTablePicker *)picker isAssetFilteredOut:(BK_ELCAsset *)elcAsset;

@end
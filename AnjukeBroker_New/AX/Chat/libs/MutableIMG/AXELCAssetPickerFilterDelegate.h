//
// ELCAssetPickerFilterDelegate.h

@class AXELCAsset;
@class AXELCAssetTablePicker;

@protocol AXELCAssetPickerFilterDelegate<NSObject>

// respond YES/NO to filter out (not show the asset)
-(BOOL)assetTablePicker:(AXELCAssetTablePicker *)picker isAssetFilteredOut:(AXELCAsset *)elcAsset;

@end
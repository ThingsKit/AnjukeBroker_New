//
//  AlbumPickerController.m
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "BK_ELCAlbumPickerController.h"
#import "BK_ELCImagePickerController.h"
#import "BK_ELCAssetTablePicker.h"
#import "Util_UI.h"
#import "AppManager.h"

#define PhotoPickerTitle @"选择相册"

@interface BK_ELCAlbumPickerController ()

@property (nonatomic, strong) ALAssetsLibrary *library;

@end

@implementation BK_ELCAlbumPickerController

//Using auto synthesizers

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	   
    [self setTitleForNavBarWithStr:PhotoPickerTitle];
    
    if (![AppManager isIOS6]) {
        self.navigationController.navigationBar.barTintColor = SYSTEM_NAVBAR_DARK_BG;
        self.navigationController.navigationBar.translucent = NO;
    }
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self.parent action:@selector(cancelImagePicker)];
    if (![AppManager isIOS6]) {
        cancelButton.tintColor = SYSTEM_NAVIBAR_COLOR;
    }
	[self.navigationItem setRightBarButtonItem:cancelButton];

    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	self.assetGroups = tempArray;
    
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    self.library = assetLibrary;

    // Load Albums into assetGroups
    dispatch_async(dispatch_get_main_queue(), ^
    {
        @autoreleasepool {
        
        // Group enumerator Block
            void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) 
            {
                if (group == nil) {
                    return;
                }
                
                // added fix for camera albums order
                NSString *sGroupPropertyName = (NSString *)[group valueForProperty:ALAssetsGroupPropertyName];
                NSUInteger nType = [[group valueForProperty:ALAssetsGroupPropertyType] intValue];
                
                if ([[sGroupPropertyName lowercaseString] isEqualToString:@"camera roll"] && nType == ALAssetsGroupSavedPhotos) {
                    [self.assetGroups insertObject:group atIndex:0];
                }
                else {
                    [self.assetGroups addObject:group];
                }

                // Reload albums
                [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
            };
            
            // Group Enumerator Failure Block
            void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
                
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"相册选择出错: %@", [error localizedDescription]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                
                NSLog(@"A problem occured %@", [error description]);	                                 
            };	
                    
            // Enumerate Albums
            [self.library enumerateGroupsWithTypes:ALAssetsGroupAll
                                   usingBlock:assetGroupEnumerator 
                                 failureBlock:assetGroupEnumberatorFailure];
        
        }
    });    
}

- (void)reloadTableView
{
	[self.tableView reloadData];
//    [self setTitleForNavBarWithStr:PhotoPickerTitle];
}

- (BOOL)shouldSelectAsset:(BK_ELCAsset *)asset previousCount:(NSUInteger)previousCount
{
    return [self.parent shouldSelectAsset:asset previousCount:previousCount];
}

- (void)selectedAssets:(NSArray*)assets
{
	[_parent selectedAssets:assets];
}

- (void)setTitleForNavBarWithStr:(NSString *)title {
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 31)];
    lb.backgroundColor = [UIColor clearColor];
    lb.font = [UIFont systemFontOfSize:19];
    lb.text = title;
    lb.textAlignment = NSTextAlignmentCenter;
    lb.textColor = SYSTEM_NAVIBAR_COLOR;
    self.navigationItem.titleView = lb;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.assetGroups count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Get count
    ALAssetsGroup *g = (ALAssetsGroup*)[self.assetGroups objectAtIndex:indexPath.row];
    [g setAssetsFilter:[ALAssetsFilter allPhotos]];
    NSInteger gCount = [g numberOfAssets];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)",[g valueForProperty:ALAssetsGroupPropertyName], (long)gCount];
    [cell.imageView setImage:[UIImage imageWithCGImage:[(ALAssetsGroup*)[self.assetGroups objectAtIndex:indexPath.row] posterImage]]];
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	BK_ELCAssetTablePicker *picker = [[BK_ELCAssetTablePicker alloc] initWithNibName: nil bundle: nil];
	picker.parent = self;

    picker.assetGroup = [self.assetGroups objectAtIndex:indexPath.row];
    [picker.assetGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
    
	picker.assetPickerFilterDelegate = self.assetPickerFilterDelegate;
	
	[self.navigationController pushViewController:picker animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 57;
}

@end


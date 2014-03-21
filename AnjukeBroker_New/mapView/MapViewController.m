//
//  MapViewController.m
//  AnjukeBroker_New
//
//  Created by shan xu on 14-3-18.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "MapViewController.h"
#import "RegionAnnotation.h"
#import "RegexKitLite.h"
#import "CheckInstalledMapAPP.h"
#import "LocationChange.h"
#import "LocIsBaidu.h"

#define SYSTEM_NAVIBAR_COLOR [UIColor colorWithRed:1 green:1 blue:1 alpha:1]
#define ISIOS7 ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=7)
#define STATUS_BAR_H 20
#define NAV_BAT_H 44

#define FRAME_WITH_NAV CGRectMake(0, 0, [self windowWidth], [self windowHeight] - STATUS_BAR_H - NAV_BAT_H)
#define FRAME_USER_LOC CGRectMake(10, [self windowHeight] - STATUS_BAR_H - NAV_BAT_H-50, 40, 40)
#define FRAME_CENTRE_LOC CGRectMake([self windowWidth]/2-8, ([self windowHeight] - STATUS_BAR_H - NAV_BAT_H-32)/2, 16, 33)


@interface MapViewController ()
//导航2d,百度
@property(nonatomic,assign) CLLocationCoordinate2D naviCoordsBd;
//导航2d,高德
@property(nonatomic,assign) CLLocationCoordinate2D naviCoordsGd;
//user最新2d
@property(nonatomic,assign) CLLocationCoordinate2D nowCoords;
//最近一次成功查询2d
@property(nonatomic,assign) CLLocationCoordinate2D lastCoords;
//最近一次请求的中心2d
@property(nonatomic,assign) CLLocationCoordinate2D centerCoordinate;
@property(nonatomic,strong) NSMutableArray *requestLocArr;
@property(nonatomic,strong) MKMapView *regionMapView;
//updateInt初始化为0，大于1时，didUpdateUserLocation中setRegion不再执行
@property(nonatomic,assign) int updateInt;
//userRegion 地图中心点定位参数
@property(nonatomic,assign) MKCoordinateRegion userRegion;
@property(nonatomic,assign) MKCoordinateRegion naviRegion;

@property(nonatomic,strong) NSString *city;
@property(nonatomic,strong) NSArray *routes;//ios6路线arr
//地图的区域和详细地址
@property(nonatomic,strong) NSString *regionStr;
@property(nonatomic,strong) NSString *addressStr;
@end

@implementation MapViewController
@synthesize mapType;
@synthesize regionMapView;
@synthesize addressStr;
@synthesize updateInt;
@synthesize userRegion;
@synthesize naviRegion;
@synthesize lastCoords;
@synthesize naviCoordsBd;
@synthesize naviCoordsGd;
@synthesize nowCoords;
@synthesize routes;
@synthesize regionStr;
@synthesize navDic;
@synthesize requestLocArr;
@synthesize centerCoordinate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        updateInt = 0;
        self.navDic = [[NSDictionary alloc] init];
        self.requestLocArr = [[NSMutableArray alloc] init];
    }
    return self;
}
- (NSInteger)windowWidth {
    return [[[[UIApplication sharedApplication] windows] objectAtIndex:0] frame].size.width;
}
- (NSInteger)windowHeight {
    return [[[[UIApplication sharedApplication] windows] objectAtIndex:0] frame].size.height;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (ISIOS7) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    [self addBackButton];
    NSString *titStr;
    if (self.mapType == RegionNavi) {
        titStr = @"查看地理位置";
    }else{
        titStr = @"位置";
        [self addRightButton];
    }

    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 31)];
    lb.backgroundColor = [UIColor clearColor];
    lb.font = [UIFont systemFontOfSize:19];
    lb.textAlignment = NSTextAlignmentCenter;
    lb.textColor = SYSTEM_NAVIBAR_COLOR;
    lb.text = titStr;
    self.navigationItem.titleView = lb;
    
    self.regionMapView = [[MKMapView alloc] initWithFrame:FRAME_WITH_NAV];
    self.regionMapView.delegate = self;
    self.regionMapView.showsUserLocation = YES;
    [self.view addSubview:self.regionMapView];
 
    UIButton *goUserLocBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    goUserLocBtn.frame = FRAME_USER_LOC;
    [goUserLocBtn addTarget:self action:@selector(goUserLoc:) forControlEvents:UIControlEventTouchUpInside];
    [goUserLocBtn setImage:[UIImage imageNamed:@"wl_map_icon_position.png"] forState:UIControlStateNormal];
    [goUserLocBtn setImage:[UIImage imageNamed:@"wl_map_icon_position_press.png"] forState:UIControlStateHighlighted];
    goUserLocBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:goUserLocBtn];
    
    if (self.mapType == RegionChoose) {
        UIImageView *certerIcon = [[UIImageView alloc] initWithFrame:FRAME_CENTRE_LOC];
        certerIcon.image = [UIImage imageNamed:@"anjuke_icon_itis_position.png"];
        [self.view addSubview:certerIcon];
        
    }else{
        if ([LocIsBaidu locIsBaid:self.navDic]) {
            
            naviCoordsBd.latitude = [[self.navDic objectForKey:@"baidu_lat"] doubleValue];
            naviCoordsBd.longitude = [[self.navDic objectForKey:@"baidu_lng"] doubleValue];
            
            double gdLat,gdLon;
            bd_decrypt(naviCoordsBd.latitude, naviCoordsBd.longitude, &gdLat, &gdLon);
            
            naviCoordsGd.latitude = gdLat;
            naviCoordsGd.longitude = gdLon;
        }else{
            naviCoordsGd.latitude = [[self.navDic objectForKey:@"lat"] doubleValue];
            naviCoordsGd.longitude = [[self.navDic objectForKey:@"lng"] doubleValue];
            
            double bdLat,bdLon;
            bd_encrypt(naviCoordsGd.latitude, naviCoordsGd.longitude, &bdLat, &bdLon);
            
            naviCoordsBd.latitude = bdLat;
            naviCoordsBd.longitude = bdLon;
        }
        
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:naviCoordsGd.latitude longitude:naviCoordsGd.longitude];
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(naviCoordsGd, 200, 200);
        self.naviRegion = [self.regionMapView regionThatFits:viewRegion];
        [self.regionMapView setRegion:self.naviRegion animated:YES];
        
        [self showAnnotation:loc coord:naviCoordsGd];
    }
}
-(void)addRightButton{
    UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonAction:)];
    if (!ISIOS7) {
        self.navigationItem.rightBarButtonItem = rBtn;
    }
    else {
        [self.navigationController.navigationBar setTintColor:SYSTEM_NAVIBAR_COLOR];
        self.navigationItem.rightBarButtonItem = rBtn;
    }
}
- (void)addBackButton {
    //save btn
    NSString *title = @"返回";
    UIBarButtonItem *backBtn = nil;
    backBtn = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(doBack:)];
    
    if (!ISIOS7) {
        self.navigationItem.leftBarButtonItem = backBtn;
    }
    else {
        [self.navigationController.navigationBar setTintColor:SYSTEM_NAVIBAR_COLOR];
        self.navigationItem.leftBarButtonItem = backBtn;
    }
}
-(void)doBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightButtonAction:(id *)sender{
    if (lastCoords.latitude && lastCoords.longitude && self.regionStr && ![self.regionStr isEqualToString:@""] && self.addressStr && ![self.addressStr isEqualToString:@""]) {
        if (self.siteDelegate && [self.siteDelegate respondsToSelector:@selector(loadMapSiteMessage:)])
        {
            NSMutableDictionary *locationDic = [[NSMutableDictionary alloc] init];
            [locationDic setValue:self.addressStr forKey:@"address"];
            [locationDic setValue:self.city forKey:@"city"];
            [locationDic setValue:self.regionStr forKey:@"region"];
            [locationDic setValue:[NSString stringWithFormat:@"%.8f",lastCoords.latitude] forKey:@"lat"];
            [locationDic setValue:[NSString stringWithFormat:@"%.8f",lastCoords.longitude] forKey:@"lng"];
            
           [self.siteDelegate loadMapSiteMessage:locationDic];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您还没有定位到有效地址，请重新选择发送地址" delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
        [alert show];
    }
}

-(void)goUserLoc:(id *)sender{
    [self.regionMapView setRegion:self.userRegion animated:YES];
}

-(void)doAcSheet{
    NSArray *appListArr = [CheckInstalledMapAPP checkHasOwnApp];
    NSString *sheetTitle = [NSString stringWithFormat:@"导航到 %@",[self.navDic objectForKey:@"address"]];

    UIActionSheet *sheet;
    if ([appListArr count] == 2) {
        sheet = [[UIActionSheet alloc] initWithTitle:sheetTitle delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:appListArr[0],appListArr[1], nil];
    }else if ([appListArr count] == 3){
        sheet = [[UIActionSheet alloc] initWithTitle:sheetTitle delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:appListArr[0],appListArr[1],appListArr[2], nil];
    }else if ([appListArr count] == 4){
        sheet = [[UIActionSheet alloc] initWithTitle:sheetTitle delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:appListArr[0],appListArr[1],appListArr[2],appListArr[3], nil];
    }else if ([appListArr count] == 5){
        sheet = [[UIActionSheet alloc] initWithTitle:sheetTitle delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:appListArr[0],appListArr[1],appListArr[2],appListArr[3],appListArr[4], nil];
    }
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [sheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *btnTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if (buttonIndex == 0) {
        if (!ISIOS7) {//ios6 调用goole网页地图
            NSString *urlString = [[NSString alloc]
                                   initWithFormat:@"http://maps.google.com/maps?saddr=&daddr=%.8f,%.8f&dirfl=d",naviCoordsGd.latitude,naviCoordsGd.longitude];
            
            NSURL *aURL = [NSURL URLWithString:urlString];
            [[UIApplication sharedApplication] openURL:aURL];
        }else{//ios7 跳转apple map
            CLLocationCoordinate2D to;
            
            to.latitude = naviCoordsGd.latitude;
            to.longitude = naviCoordsGd.longitude;
            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:to addressDictionary:nil]];
            
            toLocation.name = addressStr;
            [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, toLocation, nil] launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil] forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
        }
    }
    
    if ([btnTitle isEqualToString:@"google地图"]) {
        NSString *urlStr = [NSString stringWithFormat:@"comgooglemaps://?saddr=%.8f,%.8f&daddr=%.8f,%.8f&directionsmode=transit",nowCoords.latitude,nowCoords.longitude,naviCoordsGd.latitude,naviCoordsGd.longitude];

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }else if ([btnTitle isEqualToString:@"高德地图"]){
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"iosamap://navi?sourceApplication=broker&backScheme=openbroker2&poiname=&poiid=BGVIS&lat=%.8f&lon=%.8f&dev=1&style=2",naviCoordsGd.latitude,naviCoordsGd.longitude]];
        [[UIApplication sharedApplication] openURL:url];
        
    }else if ([btnTitle isEqualToString:@"百度地图"]){
        NSString *stringURL = [NSString stringWithFormat:@"baidumap://map/direction?origin=%.8f,%.8f&destination=%.8f,%.8f&&mode=driving",nowCoords.latitude,nowCoords.longitude,naviCoordsBd.latitude,naviCoordsBd.longitude];
        NSURL *url = [NSURL URLWithString:stringURL];
        [[UIApplication sharedApplication] openURL:url];
    }else if ([btnTitle isEqualToString:@"显示路线"]){
        [self drawRout];
    }
}
-(void)drawRout{
    MKPlacemark *fromPlacemark = [[MKPlacemark alloc] initWithCoordinate:nowCoords addressDictionary:nil];
    MKPlacemark *toPlacemark   = [[MKPlacemark alloc] initWithCoordinate:naviCoordsGd addressDictionary:nil];
    MKMapItem *fromItem = [[MKMapItem alloc] initWithPlacemark:fromPlacemark];
    MKMapItem *toItem   = [[MKMapItem alloc] initWithPlacemark:toPlacemark];
    
    if (ISIOS7) {//ios7采用系统绘制方法
        [self.regionMapView removeOverlays:self.regionMapView.overlays];
        [self findDirectionsFrom:fromItem to:toItem];
    }else{//ios7以下借用google路径绘制方法
        if (routes) {
            routes = nil;
        }
        routes = [self calculateRoutesFrom];
        [self updateRouteView];
        [self centerMap];
    }
}
//ios6绘制路线方法
-(NSArray*)calculateRoutesFrom{
	NSString* apiUrlStr = [NSString stringWithFormat:@"http://maps.google.com/maps?output=dragdir&saddr=%0.8f,%0.8f&daddr=%0.8f,%0.8f", nowCoords.latitude, nowCoords.longitude, naviCoordsGd.latitude, naviCoordsGd.longitude];
	NSURL* apiUrl = [NSURL URLWithString:apiUrlStr];
//	NSString *apiResponse = [NSString stringWithContentsOfURL:apiUrl];
	NSString *apiResponse = [NSString stringWithFormat:@"%@",apiUrl];
    
    NSString* encodedPoints = [apiResponse stringByMatching:@"points:\\\"([^\\\"]*)\\\"" capture:1L];
	return [self decodePolyLine:[encodedPoints mutableCopy]:nowCoords to:naviCoordsBd];
}
-(NSMutableArray *)decodePolyLine: (NSMutableString *)encoded :(CLLocationCoordinate2D)f to: (CLLocationCoordinate2D) t {

    [encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"
								options:NSLiteralSearch
								  range:NSMakeRange(0, [encoded length])];
	NSInteger len = [encoded length];
	NSInteger index = 0;
	NSMutableArray *array = [[NSMutableArray alloc] init];
	NSInteger latV = 0;
	NSInteger lngV = 0;
	while (index < len) {
		NSInteger b;
		NSInteger shift = 0;
		NSInteger result = 0;
		do {
			b = [encoded characterAtIndex:index++] - 63;
			result |= (b & 0x1f) << shift;
			shift += 5;
		} while (b >= 0x20);
		NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
		latV += dlat;
		shift = 0;
		result = 0;
		do {
			b = [encoded characterAtIndex:index++] - 63;
			result |= (b & 0x1f) << shift;
			shift += 5;
		} while (b >= 0x20);
		NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
		lngV += dlng;
		NSNumber *latitude = [[NSNumber alloc] initWithFloat:latV * 1e-5];
		NSNumber *longitude = [[NSNumber alloc] initWithFloat:lngV * 1e-5];
		CLLocation *loc = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
		[array addObject:loc];
	}
    CLLocation *first = [[CLLocation alloc] initWithLatitude:[[NSNumber numberWithFloat:f.latitude] floatValue] longitude:[[NSNumber numberWithFloat:f.longitude] floatValue] ];
    CLLocation *end = [[CLLocation alloc] initWithLatitude:[[NSNumber numberWithFloat:t.latitude] floatValue] longitude:[[NSNumber numberWithFloat:t.longitude] floatValue] ];
	[array insertObject:first atIndex:0];
    [array addObject:end];
	return array;
}
-(void)centerMap {
	MKCoordinateRegion region;
    
	CLLocationDegrees maxLat = -90;
	CLLocationDegrees maxLon = -180;
	CLLocationDegrees minLat = 90;
	CLLocationDegrees minLon = 180;
	for(int idx = 0; idx < routes.count; idx++)
	{
		CLLocation* currentLocation = [routes objectAtIndex:idx];
		if(currentLocation.coordinate.latitude > maxLat)
			maxLat = currentLocation.coordinate.latitude;
		if(currentLocation.coordinate.latitude < minLat)
			minLat = currentLocation.coordinate.latitude;
		if(currentLocation.coordinate.longitude > maxLon)
			maxLon = currentLocation.coordinate.longitude;
		if(currentLocation.coordinate.longitude < minLon)
			minLon = currentLocation.coordinate.longitude;
	}
	region.center.latitude     = (maxLat + minLat) / 2;
	region.center.longitude    = (maxLon + minLon) / 2;
	region.span.latitudeDelta  = maxLat - minLat + 0.018;
	region.span.longitudeDelta = maxLon - minLon + 0.018;
    
	[self.regionMapView setRegion:region animated:YES];
}
-(void)updateRouteView {
    [self.regionMapView removeOverlays:self.regionMapView.overlays];
    
    CLLocationCoordinate2D pointsToUse[[routes count]];
    for (int i = 0; i < [routes count]; i++) {
        CLLocationCoordinate2D coords;
        CLLocation *loc = [routes objectAtIndex:i];
        coords.latitude = loc.coordinate.latitude;
        coords.longitude = loc.coordinate.longitude;
        pointsToUse[i] = coords;
    }
    MKPolyline *lineOne = [MKPolyline polylineWithCoordinates:pointsToUse count:[routes count]];
    [self.regionMapView addOverlay:lineOne];
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineView *lineview=[[MKPolylineView alloc] initWithOverlay:overlay] ;
        //路线颜色
        lineview.strokeColor=[UIColor colorWithRed:69.0f/255.0f green:212.0f/255.0f blue:255.0f/255.0f alpha:0.9];
        lineview.lineWidth=8.0;
        return lineview;
    }
    return nil;
}

#pragma mark - Private
//ios7路线绘制方法
-(void)findDirectionsFrom:(MKMapItem *)from to:(MKMapItem *)to{
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = from;
    request.destination = to;
    request.transportType = MKDirectionsTransportTypeWalking;
    if (ISIOS7) {
        request.requestsAlternateRoutes = YES;
    }
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    //ios7获取绘制路线的路径方法
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         if (error) {
             NSLog(@"error:%@", error);
         }
         else {
             MKRoute *route = response.routes[0];
             [self.regionMapView addOverlay:route.polyline];
         }
     }];
}
#pragma MKMapViewDelegate
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.lineWidth = 5.0;
    renderer.strokeColor = [UIColor redColor];
    return renderer;
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    nowCoords = [userLocation coordinate];
    //放大地图到自身的经纬度位置。
    self.userRegion = MKCoordinateRegionMakeWithDistance(nowCoords, 200, 200);

    if (self.mapType != RegionNavi) {
        if (updateInt >= 1) {
            return;
        }
        [self showAnnotation:userLocation.location coord:nowCoords];
        [self.regionMapView setRegion:self.userRegion animated:YES];
        updateInt += 1;
    }
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    if (self.mapType == RegionNavi) {
        return;
    }
    [mapView removeAnnotations:mapView.annotations];
    if (updateInt == 0){
        return;
    }
    self.centerCoordinate = mapView.region.center;

    CLLocation *loc = [[CLLocation alloc] initWithLatitude:self.centerCoordinate.latitude longitude:self.centerCoordinate.longitude];
    
    [self showAnnotation:loc coord:centerCoordinate];
}

-(void)showAnnotation:(CLLocation *)location coord:(CLLocationCoordinate2D)coords{
    if (self.mapType == RegionNavi) {
        [self addAnnotationView:location coord:coords region:[self.navDic objectForKey:@"region"]  address:[self.navDic objectForKey:@"address"]];
        return;
    }
    //每次请求位置时，把latitude塞入arr。在block回掉时判断但会latitude是否存在arr且和最近一次请求latitude一致。如果一致，则显示，否则舍弃
    [self.requestLocArr addObject:[NSString stringWithFormat:@"%ff",[location coordinate].latitude]];
    [self addAnnotationView:location coord:coords region:@"加载中..." address:nil];

    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *array, NSError *error) {
        CLLocation *centreLoc = [[CLLocation alloc] initWithLatitude:self.centerCoordinate.latitude longitude:self.centerCoordinate.longitude];
        
        if ([self.requestLocArr count] > 0 && [self.requestLocArr containsObject:[NSString stringWithFormat:@"%f",[location coordinate].latitude]] && (![[NSString stringWithFormat:@"%f",[location coordinate].latitude] isEqualToString:[NSString stringWithFormat:@"%f",[centreLoc coordinate].latitude]])) {
            [self.requestLocArr removeObject:[NSString stringWithFormat:@"%f",[location coordinate].latitude]];
            
            return;
        }

        if (array.count > 0) {
            if ([self.requestLocArr count] > 0) {
                [self.requestLocArr removeAllObjects];
            }
            CLPlacemark *placemark = [array objectAtIndex:0];
            
            NSString *region = [placemark.addressDictionary objectForKey:@"SubLocality"];
            NSString *address = [placemark.addressDictionary objectForKey:@"Name"];
            self.lastCoords = coords;
            self.regionStr = region;
            self.addressStr = address;
            self.city = placemark.administrativeArea;
            
            [self addAnnotationView:location coord:coords region:region address:address];
        }else{
            lastCoords.latitude = 0;
            lastCoords.longitude = 0;
            self.regionStr = nil;
            self.addressStr = nil;

            [self addAnnotationView:location coord:coords region:@"请重新滑动选择发送地址" address:nil];
        }
    }];
}

-(void)addAnnotationView:(CLLocation *)location coord:(CLLocationCoordinate2D)coords region:(NSString *)region address:(NSString *)address{
    RegionAnnotation *annotation = [[RegionAnnotation alloc] init];
    annotation.coordinate = coords;
    annotation.title = region;
    annotation.subtitle  = address;

    [self.regionMapView addAnnotation:annotation];

    if (ISIOS7) {
        [self.regionMapView selectAnnotation:annotation animated:YES];
    }else{
        [self performSelector:@selector(selectAnnotationDelay:) withObject:annotation afterDelay:1.0];
    }
    updateInt += 1;
}
-(void)selectAnnotationDelay:(RegionAnnotation *)annotation{
    [self.regionMapView selectAnnotation:annotation animated:YES];
}
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    if (self.mapType == RegionNavi) {
        return;
    }

    [mapView removeAnnotations:mapView.annotations];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    static NSString* identifier = @"MKAnnotationView";
    if ([annotation isKindOfClass:[RegionAnnotation class]]) {
        MKAnnotationView *annotationView;
        annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        
        annotationView.frame = CGRectMake(0, 0, 16, 33);
        if (self.self.mapType == RegionNavi) {
            annotationView.image = [UIImage imageNamed:@"anjuke_icon_itis_position.png"];

            UIButton *naviBtn;
            if (ISIOS7) {
                naviBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                naviBtn.backgroundColor = [UIColor blackColor];
                [naviBtn setImage:[UIImage imageNamed:@"anjuke_icon_to_position.png"] forState:UIControlStateNormal];
                [naviBtn setImage:[UIImage imageNamed:@"anjuke_icon_to_position1.png"] forState:UIControlStateHighlighted];
                naviBtn.frame = CGRectMake(0, 0, 65, 45);
            }else{
                naviBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [naviBtn setTitle:@"导航" forState:UIControlStateNormal];
                naviBtn.frame = CGRectMake(0, 0, 60, 35);
            }
            [naviBtn addTarget:self action:@selector(doAcSheet) forControlEvents:UIControlEventTouchUpInside];
            
            
            annotationView.rightCalloutAccessoryView = naviBtn;
        }
        [annotationView setCanShowCallout:YES];
        annotationView.annotation = annotation;

        return annotationView;
    }
    return nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

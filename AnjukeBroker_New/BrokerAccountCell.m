//
//  BrokerAccountCell.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/26/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "BrokerAccountCell.h"
#import "Util_UI.h"
#import "LoginManager.h"

@implementation BrokerAccountCell
@synthesize labKey;
@synthesize labValue;
@synthesize img;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.img = [[UIImageView alloc] initWithFrame:CGRectMake(100, 10, 62, 62)];
        
        self.labKey = [[UILabel alloc] initWithFrame:CGRectMake(17, 5, 80, 30)];
        self.labKey.textColor = [Util_UI colorWithHexString:@"#999999"];
        
        self.labValue = [[UILabel alloc] initWithFrame:CGRectMake(110, 5, 200, 30)];
        self.labValue.textColor = [Util_UI colorWithHexString:@"#333333"];
        self.labValue.font = [UIFont systemFontOfSize:16];
        
        [self.contentView addSubview:self.img];
        [self.contentView addSubview:self.labKey];
        [self.contentView addSubview:labValue];
        // Initialization code
    }
    return self;
}

- (BOOL)configureCell:(id)dataModel withIndex:(int)index {
    NSDictionary *tempDic = [NSDictionary dictionary];
    if([dataModel isKindOfClass:[NSDictionary class]]){
        tempDic = (NSDictionary *)dataModel;
    }
    switch (index) {
        case 0:
        {
        self.labKey.text = @"真实姓名";
        self.labValue.text = [tempDic objectForKey:@"brokerName"];
        }
            break;
        case 1:
        {
            self.labKey.text = @"账户余额";
            self.labValue.text = [NSString stringWithFormat:@"%@元", [tempDic objectForKey:@"balance"]];
        }
            break;

        case 2:
        {
            self.labKey.text = @"手机号码";
            self.labValue.text = [tempDic objectForKey:@"phone"];
        }
            break;
        case 3:
        {
            self.labKey.text = @"所在城市";
            self.labValue.text = [tempDic objectForKey:@"cityName"];
        }
            break;
        case 4:
        {
            self.labKey.text = @"工作区域";
            self.labValue.text = [tempDic objectForKey:@"workRegion"];
        }
            break;
        case 5:
        {
            
            self.labKey.text = @"所属公司";
            self.labValue.text = [self getCommpany:[tempDic objectForKey:@"company"]];
            
            
        }
            break;
        case 6:
        {
            self.labKey.text = @"所属门店";
            self.labValue.text = [tempDic objectForKey:@"store"];
        }
            break;
        default:
            break;
    }
    return YES;
}

- (NSString *)getCommpany:(NSString *)commpany {
    NSArray *tempStr = [NSArray array];
    tempStr = [commpany componentsSeparatedByString:@" "];
    if ([tempStr count] == 2) {
        return [tempStr objectAtIndex:0];
    }else {
        return commpany;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

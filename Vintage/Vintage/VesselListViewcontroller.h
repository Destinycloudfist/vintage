//
//  VesselListViewcontroller.h
//  Vintage
//
//  Created by Dustin Dettmer on 3/3/13.
//  Copyright (c) 2013 Dustin Dettmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vessel.h"

@class VesselListViewcontroller;

@protocol VesselListDelegate <NSObject>

- (void)vesselList:(VesselListViewcontroller*)controller selectedVessel:(Vessel*)vessel;

@end

@interface VesselListViewcontroller : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<VesselListDelegate> delegate;

@property (nonatomic, strong) NSArray *excludeKeys;

@end

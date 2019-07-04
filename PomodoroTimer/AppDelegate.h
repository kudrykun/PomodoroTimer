//
//  AppDelegate.h
//  PomodoroTimer
//
//  Created by Macbook on 17/06/2019.
//  Copyright © 2019 Sergey Vasilenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer* persistentContainer;

-(void) saveContext;

@end


//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"
#import <android_alarm_manager/AndroidAlarmManagerPlugin.h>
#import <receive_sharing_intent/ReceiveSharingIntentPlugin.h>
#import <sqflite/SqflitePlugin.h>
#import <url_launcher/UrlLauncherPlugin.h>

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [FLTAndroidAlarmManagerPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTAndroidAlarmManagerPlugin"]];
  [ReceiveSharingIntentPlugin registerWithRegistrar:[registry registrarForPlugin:@"ReceiveSharingIntentPlugin"]];
  [SqflitePlugin registerWithRegistrar:[registry registrarForPlugin:@"SqflitePlugin"]];
  [FLTUrlLauncherPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTUrlLauncherPlugin"]];
}

@end

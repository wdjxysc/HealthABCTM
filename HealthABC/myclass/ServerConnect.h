//
//  ServerConnect.h
//  HealthABC
//
//  Created by 夏 伟 on 13-12-4.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

@interface ServerConnect : NSObject

+(NSData *)doSyncRequest:(NSString *)urlString;
+(NSDictionary *)getDictionaryByUrl:(NSString *)url;

+(NSString *)Login:(NSString *)url;

+(NSDictionary *)getUserInfo:(NSString *)url;
+(NSArray *)getWeightDataHistory:(NSString *)url;
+(NSArray *)getBodyFatDataHistory:(NSString *)url;
+(NSArray *)getBloodPressureDataHistory:(NSString *)url;
+(NSDictionary *)requestCheckCode:(NSString *)url;
+(NSDictionary *)feedBackCheckCode:(NSString *)url;
+(NSDictionary *)getLastData:(NSString *)url;

//获取当前用户从开始时间到现在的所有数据
+(void)getAllDataFromCloud:(NSDate *)starttime;

+(BOOL)uploadUserInfo:(NSString *)url;
+(BOOL)uploadWeightData:(NSString *)url;
+(BOOL)uploadBodyFatData:(NSString *)url;
+(BOOL)uploadBloodPressureData:(NSString *)url;
+(BOOL)uploadTemperatureData:(NSString *)url;
+(BOOL)uploadWeightTarget:(NSString *)url;


+(BOOL)isConnectionAvailable;
+(BOOL)backCheckCode:(NSString *)url;

+(BOOL)resetPassword:(NSString *)url;


+(NSDictionary *)uploadTemperatureData:(NSDictionary *)datadic authkey:(NSString *)authkey;
+(NSDictionary *)uploadWeightData:(NSDictionary *)datadic authkey:(NSString *)authkey;
+(NSDictionary *)uploadBodyFatData:(NSDictionary *)datadic authkey:(NSString *)authkey;
+(NSDictionary *)uploadBloodPressureData:(NSDictionary *)datadic authkey:(NSString *)authkey;

//邮箱注册
+(NSString *)registByEmail:(NSString *)email password:(NSString *)password;
//邮箱找回密码时请求验证码
+(NSDictionary *)getCheckCodeByEmail:(NSString *)email;
//邮箱找回密码时发送获得的验证码
+(NSDictionary *)checkCheckCode:(NSString *)email checkcode:(NSString *)checkcode;
//邮箱找回密码时设置新密码
+(NSDictionary *)resetPasswordByEmail:(NSString *)email newpassword:(NSString *)newpassword;
@end

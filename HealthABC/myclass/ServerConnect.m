//
//  ServerConnect.m
//  HealthABC
//
//  Created by 夏 伟 on 13-12-4.
//  Copyright (c) 2013年 夏 伟. All rights reserved.
//

#import "ServerConnect.h"
#import "MySingleton.h"

@implementation ServerConnect


+(bool)regist:(NSString *)url
{
    bool b = false;
    
    
    
    return b;
}
//登陆
//登陆成功返回@“0”
//   失败返回 errormessage
+(NSString *)Login:(NSString *)url
{
    NSString *s;
    NSData *revData;
    @try {
        revData = [self doSyncRequest:url];
    }
    @catch (NSException *exception) {
        NSLog(@"**********%@",exception);
    }
    @finally {
        NSLog(@"");
    }
    NSData *jasonData = revData;
    if(jasonData != nil)
    {
        NSString *str = [[NSString alloc]initWithData:jasonData encoding:NSUTF8StringEncoding];
        NSLog(@"str = %@",str);
        NSRange range = [str rangeOfString:@"true"];
        if(range.length != 0)
        {
            NSLog(@"Login success！");
            NSRange range1 = [str rangeOfString:@"authkey"];
            NSRange range2 = [str rangeOfString:@"userid"];
            
            if(range1.length != 0 && range2.length != 0)
            {
                NSUInteger head = range1.location + range1.length + 3;
                NSUInteger end = range2.location - 3;
                NSString *authkey;
                authkey = [str substringWithRange:NSMakeRange(head, end-head)];
                
                NSLog(@"authkey = %@",authkey);
                NSLog(@"MySingleton AuthKey = %@", [[MySingleton sharedSingleton].nowuserinfo valueForKey:@"AuthKey"]);
                
                
                [MySingleton sharedSingleton].authKey = authkey;
                [[MySingleton sharedSingleton].nowuserinfo setValue:authkey forKey:@"AuthKey"];
                NSLog(@"MySingleton AuthKey = %@", [[MySingleton sharedSingleton].nowuserinfo valueForKey:@"AuthKey"]);
                s = @"0";
            }
        }
        else
        {
            NSError *error;
            id jasonObject = [NSJSONSerialization JSONObjectWithData:jasonData options:NSJSONReadingAllowFragments error:&error];
            if([jasonObject isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dictionary = (NSDictionary *)jasonObject;
                s =[[NSString alloc]initWithFormat:@"%@",[dictionary valueForKey:@"errormessage"]];
            }
        }
    }
    
    return s;
}

//获取用户信息
+(NSDictionary *)getUserInfo:(NSString *)url
{
    NSDictionary *dictionary;
    
    NSData *revData;
    @try {
        revData = [self doSyncRequest:url];
    }
    @catch (NSException *exception) {
        NSLog(@"**********%@",exception);
    }
    @finally {
        NSLog(@"");
    }
    
    if(revData == nil)
    {
        return false;
    }
    
    if(revData == nil)
    {
        return nil;
    }
    
    NSError *error = nil;
    //[{"like_name":"wahaha","age":"26","birthday":"1987","profesion":"1","sex":"0","height":"182.0","weight":"68.0","stepSize":"75.0","mobile":"18820995660","address":"","email":"null"}]
    NSString *str = [[NSString alloc]initWithData:revData encoding:NSUTF8StringEncoding];
    
    //    str = @"{\"like_name\":\"wahaha\",\"age\":\"26\",\"birthday\":\"1987\",\"profesion\":\"1\",\"sex\":\"0\",\"height\":\"182.0\",\"weight\":\"68.0\",\"stepSize\":\"75.0\",\"mobile\":\"18820995660\",\"address\":\"\",\"email\":\"null\"}";
    str = [str substringWithRange:NSMakeRange(1, str.length-1)];
    str = [str substringWithRange:NSMakeRange(0, str.length-1)];
    NSLog(@"%@",str);
    NSData *strdata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    if(revData == nil)return nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:strdata options:NSJSONReadingAllowFragments error:&error];
    
    NSLog(@"jsonObject : %@",jsonObject);
    
    if(jsonObject != nil)
    {
        NSLog(@"成功转为json数据");
        if([jsonObject isKindOfClass:[NSDictionary class]])
        {
            dictionary = (NSDictionary *)jsonObject;
            NSLog(@"Dictionary = %@",dictionary);
            
            //            NSString *like_name = [[NSString alloc]initWithFormat:@"%@",[dictionary valueForKey:@"like_name"]];
            //            [[MySingleton sharedSingleton].nowuserinfo setValue:like_name forKey:@"UserName"];
            NSString *age = [[NSString alloc]initWithFormat:@"%@",[dictionary valueForKey:@"age"]];
            [[MySingleton sharedSingleton].nowuserinfo setValue:age forKey:@"Age"];
            NSString *birthday = [[NSString alloc]initWithFormat:@"%@",[dictionary valueForKey:@"birthday"]];
            NSLog(@"birthday:%@",birthday);
            [[MySingleton sharedSingleton].nowuserinfo setValue:birthday forKey:@"Birthday"];
            NSString *height = [[NSString alloc]initWithFormat:@"%@",[dictionary valueForKey:@"height"]];
            [[MySingleton sharedSingleton].nowuserinfo setValue:height forKey:@"Height"];
            NSString *profesion = [[NSString alloc]initWithFormat:@"%@",[dictionary valueForKey:@"profesion"]];
            [[MySingleton sharedSingleton].nowuserinfo setValue:profesion forKey:@"Profession"];
            NSString *sex = [[NSString alloc]initWithFormat:@"%@",[dictionary valueForKey:@"sex"]];
            [[MySingleton sharedSingleton].nowuserinfo setValue:sex forKey:@"Gender"];
            NSString *stepSize = [[NSString alloc]initWithFormat:@"%@",[dictionary valueForKey:@"stepSize"]];
            [[MySingleton sharedSingleton].nowuserinfo setValue:stepSize forKey:@"StepSize"];
            NSString *weight = [[NSString alloc]initWithFormat:@"%@",[dictionary valueForKey:@"weight"]];
            [[MySingleton sharedSingleton].nowuserinfo setValue:weight forKey:@"Weight"];
            
            NSLog(@"MySingleton Weight = %@", [[MySingleton sharedSingleton].nowuserinfo valueForKey:@"Weight"]);
        }
        else if([jsonObject isKindOfClass:[NSArray class]])
        {
            NSArray *array = (NSArray *)jsonObject;
            NSLog(@"Array = %@",array);
            
        }
    }
    
    return dictionary;
}

+(NSDictionary *)requestCheckCode:(NSString *)url
{
    BOOL b = false;
    
    NSDictionary *dictionary;
    
    NSData *revData;
    @try {
        revData = [self doSyncRequest:url];
    }
    @catch (NSException *exception) {
        NSLog(@"**********%@",exception);
    }
    @finally {
        NSLog(@"");
    }
    revData = [self doSyncRequest:url];
    
    if(revData == nil)
    {
        return false;
    }
    
    NSError *error = nil;
    NSString *str = [[NSString alloc]initWithData:revData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",str);
    NSData *strdata = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    if(revData == nil)return nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:strdata options:NSJSONReadingAllowFragments error:&error];
    
    NSLog(@"jsonObject : %@",jsonObject);
    
    if(jsonObject != nil)
    {
        NSLog(@"成功转为json数据");
        if([jsonObject isKindOfClass:[NSDictionary class]])
        {
            dictionary = (NSDictionary *)jsonObject;
            NSLog(@"Dictionary = %@", dictionary);
            
            NSString *success = [[NSString alloc]initWithFormat:@"%@",[dictionary valueForKey:@"success"]];
            if([success isEqualToString:@"1"])
            {
                b = true;
            }
        }
        else if([jsonObject isKindOfClass:[NSArray class]])
        {
            NSArray *array = (NSArray *)jsonObject;
            NSLog(@"Array = %@",array);
        }
    }
    
    
    return dictionary;
}

+(BOOL)backCheckCode:(NSString *)url
{
    BOOL b = false;
    NSData *revData = [self doSyncRequest:url];
    if(revData.length == 0) //没有任何返回表示：成功...
    {
        b = true;
    }
    return b;
}


+(BOOL)uploadBodyFatData:(NSString *)url
{
    BOOL b = false;
    NSData *revData = [self doSyncRequest:url];
    NSError *error = nil;
    if(revData == nil) return NO;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:revData options:NSJSONReadingAllowFragments error:&error];
    if(jsonObject != nil)
    {
        if([jsonObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dictionary = (NSDictionary *)jsonObject;
            if([[[NSString alloc]initWithFormat:@"%@",[dictionary valueForKey:@"success"]]isEqualToString:@"true"])
            {
                b = true;
            }
        }
    }
    return  b;
}


+(NSDictionary *)uploadTemperatureData:(NSDictionary *)datadic authkey:(NSString *)authkey
{
    NSDictionary *dic,*dicadvice;
    
    
    
    NSString *testtimestr = [datadic valueForKey:@"TestTime"];
    float temperature = [[datadic valueForKey:@"Temperature"] floatValue];
    
    NSString *url = [[NSString alloc]initWithFormat:@"http://www.ebelter.com/service/ehealth_uploadEarThermometerData?authkey=%@&temperature=%@&time=%@&showresult=true&showadvice=false",
                     authkey,
                     [[NSString alloc] initWithFormat:@"%.1f",temperature],
                     testtimestr];
    dic = [self getDictionaryByUrl:url];
    
    NSString *urladvice = [[NSString alloc]initWithFormat:@"http://www.ebelter.com/service/ehealth_uploadEarThermometerData?authkey=%@&temperature=%@&time=%@&showresult=true&showadvice=true",
                     authkey,
                     [[NSString alloc] initWithFormat:@"%.1f",temperature],
                     testtimestr];
    dicadvice = [self getDictionaryByUrl:urladvice];
    
    [[MySingleton sharedSingleton].nowuserinfo setObject:dicadvice forKey:@"TemperatureUploadDic"];
    return dic;
}

+(NSDictionary *)uploadWeightData:(NSDictionary *)datadic authkey:(NSString *)authkey
{
    NSDictionary *dic, *dicadvice;
    //http://www.ebelter.com/service/ehealth_uploadWeightData?authkey=NjU1YjNlNjNjMTVjNDliZWJhNzc4ZDBmNzdkMGY3YjUjMjAxNC0wMy0yNyAwOTowODo1MyMzMCN6%0AaF9DTg%3D%3D&weight=70&height=173&time=2012-02-16%2001:24:00
    NSString *testtimestr = [datadic valueForKey:@"TestTime"];
    float weight = [[datadic valueForKey:@"Weight"] floatValue];
    int height = [[[MySingleton sharedSingleton].nowuserinfo valueForKey:@"Height"] intValue];
    
    NSString *url = [[NSString alloc]initWithFormat:@"http://www.ebelter.com/service/ehealth_uploadWeightData?authkey=%@&weight=%.1f&height=%d&time=%@&showresult=true&showadvice=false",
                     authkey,
                     weight,
                     height,
                     testtimestr];
    dic = [self getDictionaryByUrl:url];
    
    NSString *urlgetadvice = [[NSString alloc]initWithFormat:@"http://www.ebelter.com/service/ehealth_uploadWeightData?authkey=%@&weight=%.1f&height=%d&time=%@&showresult=true&showadvice=true",
                     authkey,
                     weight,
                     height,
                     testtimestr];
    dicadvice = [self getDictionaryByUrl:urlgetadvice];
    
    [[MySingleton sharedSingleton].nowuserinfo setObject:dicadvice forKey:@"WeightUploadDic"];
    return dic;
}

+(NSDictionary *)uploadBodyFatData:(NSDictionary *)datadic authkey:(NSString *)authkey
{
    //http://www.ebelter.com/service/ehealth_uploadBodyCompositionData?authkey=NjU1YjNlNjNjMTVjNDliZWJhNzc4ZDBmNzdkMGY3YjUjMjAxNC0wMy0yNyAwOTowODo1MyMzMCN6%0AaF9DTg%3D%3D&muscle=99&adiposerate=89&Metabolism=%d&visceralfat=77&moisture=80&bone=90&thermal=80&impedance=70&bmi=32&time=2012-02-16%2001:52:00&showtresult=true&showadvice=true&shareid=123
    
    NSDictionary *dic, *dicadvice;
    
    NSString *testtimestr = [datadic valueForKey:@"TestTime"];
    float muscle = [[datadic valueForKey:@"Muscle"] floatValue];
    float adiposerate = [[datadic valueForKey:@"Fat"] floatValue];
    float visceralfat = [[datadic valueForKey:@"VisceralFat"] floatValue];
    float moisture = [[datadic valueForKey:@"Water"] floatValue];
    float bone = [[datadic valueForKey:@"Bone"] floatValue];
    int thermal = [[datadic valueForKey:@"BMR"] intValue];
    int impedance = 70;
    float bmi = [[datadic valueForKey:@"BMI"] floatValue];
    
    NSString *url = [[NSString alloc]initWithFormat:@"http://www.ebelter.com/service/ehealth_uploadBodyCompositionData?authkey=%@&muscle=%.1f&adiposerate=%.1f&Metabolism=%d&visceralfat=%.1f&moisture=%.1f&bone=%.1f&thermal=%d&impedance=%d&bmi=%.1f&time=%@&showtresult=true&showadvice=false&shareid=123",
                     authkey,
                     muscle,
                     adiposerate,
                     thermal,
                     visceralfat,
                     moisture,
                     bone,
                     thermal,
                     impedance,
                     bmi,
                     testtimestr];
    dic = [self getDictionaryByUrl:url];
    
    NSString *urlgetadvice = [[NSString alloc]initWithFormat:@"http://www.ebelter.com/service/ehealth_uploadBodyCompositionData?authkey=%@&muscle=%.1f&adiposerate=%.1f&Metabolism=%d&visceralfat=%.1f&moisture=%.1f&bone=%.1f&thermal=%d&impedance=%d&bmi=%.1f&time=%@&showtresult=true&showadvice=true&shareid=123",
                     authkey,
                     muscle,
                     adiposerate,
                     thermal,
                     visceralfat,
                     moisture,
                     bone,
                     thermal,
                     impedance,
                     bmi,
                     testtimestr];
    dicadvice = [self getDictionaryByUrl:urlgetadvice];
    
    [[MySingleton sharedSingleton].nowuserinfo setObject:dicadvice forKey:@"BodyFatUploadDic"];
    
    return dic;
}

+(NSDictionary *)uploadBloodPressureData:(NSDictionary *)datadic authkey:(NSString *)authkey
{
    NSDictionary *dic,*dicadvice;
    //http://www.ebelter.com/service/ehealth_uploadBloodPressureData?authkey=NjU1YjNlNjNjMTVjNDliZWJhNzc4ZDBmNzdkMGY3YjUjMjAxNC0wMy0yNyAwOTowODo1MyMzMCN6%0AaF9DTg%3D%3D&systolic=110&diastolic=80&pulse=100&time=2012-02-16%2001:57:00&shareid=123&showresult=true&showadvice=true
    NSString *testtimestr = [datadic valueForKey:@"TestTime"];
    int sys = [[datadic valueForKey:@"SYS"] intValue];
    int dia = [[datadic valueForKey:@"DIA"] intValue];
    int pulse = [[datadic valueForKey:@"Pulse"] intValue];
    
    NSString *url = [[NSString alloc]initWithFormat:@"http://www.ebelter.com/service/ehealth_uploadBloodPressureData?authkey=%@&systolic=%d&diastolic=%d&pulse=%d&time=%@&shareid=123&showresult=true&showadvice=false",
                     authkey,
                     sys,
                     dia,
                     pulse,
                     testtimestr];
    dic = [self getDictionaryByUrl:url];
    
    NSString *urladvice = [[NSString alloc]initWithFormat:@"http://www.ebelter.com/service/ehealth_uploadBloodPressureData?authkey=%@&systolic=%d&diastolic=%d&pulse=%d&time=%@&shareid=123&showresult=true&showadvice=true",
                     authkey,
                     sys,
                     dia,
                     pulse,
                     testtimestr];
    dicadvice = [self getDictionaryByUrl:urladvice];
    
    
    [[MySingleton sharedSingleton].nowuserinfo setObject:dicadvice forKey:@"BloodPressUploadDic"];
    return dic;
}

//邮箱注册
+(NSString *)registByEmail:(NSString *)email password:(NSString *)password
{
    NSString *str;
    //性别 男:0,女:1.
    //职业 白领:1,普通工作者:2,运动员:3
    //http://www.ebelter.com/public/right_emailRegister?user.email=11369866@qq.com&user.password=123456&userInfo.sex=0&userInfo.birthday=1999-09-27&userInfo.height=175&userInfo.weight=65&userInfo.profession=1
    
    NSString *url = [[NSString alloc] initWithFormat:
                     @"http://www.ebelter.com/public/right_emailRegister?user.email=%@&user.password=%@&userInfo.sex=0&userInfo.birthday=1990-01-01&userInfo.height=175&userInfo.weight=65&userInfo.profession=1",email,password];
    str = [self getStringByUrl:url];
    
    if([str isEqualToString:@"0"]){
        [[MySingleton sharedSingleton].nowuserinfo setValue:email forKey:@"UserName"];
        [[MySingleton sharedSingleton].nowuserinfo setValue:password forKey:@"PassWord"];
        [[MySingleton sharedSingleton].nowuserinfo setValue:@"0" forKey:@"Gender"];
        [[MySingleton sharedSingleton].nowuserinfo setValue:@"1990-01-01" forKey:@"Birthday"];
        [[MySingleton sharedSingleton].nowuserinfo setValue:@"175" forKey:@"Height"];
        [[MySingleton sharedSingleton].nowuserinfo setValue:@"65" forKey:@"Weight"];
        [[MySingleton sharedSingleton].nowuserinfo setValue:@"1" forKey:@"Profession"];
    }
    
    return str;
}




+(NSDictionary *)getLastData:(NSString *)url
{
    NSDictionary *dic = [[NSDictionary alloc]init];
    NSData *revData;
    @try {
        revData = [self doSyncRequest:url];
    }
    @catch (NSException *exception) {
        NSLog(@"**********%@",exception);
    }
    @finally {
        NSLog(@"");
    }
    
    NSError *error = nil;
    if(revData == nil)return nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:revData options:NSJSONReadingAllowFragments error:&error];
    if(jsonObject != nil)
    {
        if([jsonObject isKindOfClass:[NSDictionary class]])
        {
            dic = (NSDictionary *)jsonObject;
        }
    }
    
    return dic;
}


//邮箱找回密码时请求验证码
+(NSDictionary *)getCheckCodeByEmail:(NSString *)email
{
    NSDictionary *dic;
    
    //http://www.ebelter.com/service/ehealth_checkTelphone?dtype=30&telphone=1322081542@qq.com&flag=true
    NSString *url = [[NSString alloc] initWithFormat:@"http://www.ebelter.com/service/ehealth_checkTelphone?dtype=30&telphone=%@&flag=true",email];
    dic = [self getDictionaryByUrl:url];
    
    return dic;
}

//邮箱找回密码时发送获得的验证码
+(NSDictionary *)checkCheckCode:(NSString *)email checkcode:(NSString *)checkcode
{
    NSDictionary *dic;
    
    //http://www.ebelter.com/service/ehealth_checkTelphone?dtype=30&telphone=1322081542@qq.com&&flag=true&&check_code=49952
    NSString *url = [[NSString alloc] initWithFormat:@"http://www.ebelter.com/service/ehealth_checkTelphone?dtype=30&telphone=%@&&flag=true&&check_code=%@",email,checkcode];
    dic = [self getDictionaryByUrl:url];
    
    return dic;
}
//邮箱找回密码时设置新密码
+(NSDictionary *)resetPasswordByEmail:(NSString *)email newpassword:(NSString *)newpassword
{
    NSDictionary *dic;
    
    //http://www.ebelter.com/service/ehealth_resetPassword?telphone=1322081542@qq.com&dtype=30&newpassword=123456
    NSString *url = [[NSString alloc] initWithFormat:@"http://www.ebelter.com/service/ehealth_resetPassword?telphone=%@&dtype=30&newpassword=%@",email,newpassword];
    dic = [self getDictionaryByUrl:url];
    
    return dic;
}


//根据开始时间获取数据
+(void)getAllDataFromCloud:(NSDate *)starttime
{
    [self getWeightDataFromCloud:starttime];
    [self getFatDataFromCloud:starttime];
    [self getBloodPressureDataFromCloud:starttime];
    [self getTemperatureDataFromCloud:starttime];
}

+(void)getWeightDataFromCloud:(NSDate *)starttime
{
    NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
    [fomatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timestr = [fomatter stringFromDate:starttime];
    //体重获取数据
    //http://www.ebelter.com/service/ehealth_getAllWeightData?authkey=NzQ0MzQ4ODAxNzdjNGRiYWFmNWRiMGUyNDk4YmE1NGMjMjAxMy0wNy0wMSAwOToyNTozNyMxOCN6%0AaF9DTg%3D%3D&startdate=2013-06-01%2000:00:00
    NSString *authkey = [[MySingleton sharedSingleton].nowuserinfo valueForKey:@"AuthKey"];
    NSString *url = [[NSString alloc]initWithFormat:@"http://www.ebelter.com/service/ehealth_getAllWeightData?authkey=%@&startdate=%@",authkey,timestr];
    NSDictionary *dic = [ServerConnect getDictionaryByUrl:url];
    //    NSArray *weightdataArray = [[NSArray alloc]init];
    if([[dic valueForKey:@"weightdata"] isKindOfClass:[NSArray class]])
    {
        NSMutableArray *weightDataArray = (NSMutableArray *)[dic valueForKey:@"weightdata"];
        
        if(weightDataArray != nil){
            [[MySingleton sharedSingleton].nowuserinfo setObject:weightDataArray forKey:@"UserWeightDataArray"];
        }
        
        //        NSLog(@"建议: %@",[dicweightdataArray0 valueForKey:@"advice"]);
        //        NSLog(@"日期: %@",[dicweightdataArray0 valueForKey:@"date"]);
        //        NSLog(@"结果: %@",[dicweightdataArray0 valueForKey:@"result"]);
        //        NSLog(@"分享id: %@",[dicweightdataArray0 valueForKey:@"shareid"]);
        //        NSLog(@"值: %@",[dicweightdataArray0 valueForKey:@"value"]);
        //
        //        if([[dicweightdataArray0 valueForKey:@"advice"] isKindOfClass:[NSDictionary class]])
        //        {
        //            NSDictionary *dicAdvice = (NSDictionary *)[dicweightdataArray0 valueForKey:@"advice"];
        //            NSLog(@"commSuggestion: %@",[dicAdvice valueForKey:@"commSuggestion"]);
        //            NSLog(@"doctorSuggestion: %@",[dicAdvice valueForKey:@"doctorSuggestion"]);
        //            NSLog(@"foodSuggestion: %@",[dicAdvice valueForKey:@"foodSuggestion"]);
        //            NSLog(@"sportSuggestion: %@",[dicAdvice valueForKey:@"sportSuggestion"]);
        //        }
    }
    
}


+(void)getFatDataFromCloud:(NSDate *)starttime
{
    NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
    [fomatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timestr = [fomatter stringFromDate:starttime];
    //脂肪秤获取数据
    //http://www.ebelter.com/service/ehealth_getAllBodyCompositionData?authkey=NzQ0MzQ4ODAxNzdjNGRiYWFmNWRiMGUyNDk4YmE1NGMjMjAxMy0wNi0yOCAxNjo1OTowNSMxOCN6%0AaF9DTg%3D%3D&startdate=2012-02-11%2001:52:00
    
    NSString *authkey = [[MySingleton sharedSingleton].nowuserinfo valueForKey:@"AuthKey"];
    NSString *url = [[NSString alloc]initWithFormat:@"http://www.ebelter.com/service/ehealth_getAllBodyCompositionData?authkey=%@&startdate=%@",authkey,timestr];
    NSDictionary *dic = [ServerConnect getLastData:url];
    //    NSArray *bodyFatDataArray = [[NSArray alloc]init];
    if([[dic valueForKey:@"bodyCompositondata"] isKindOfClass:[NSArray class]])
    {
        NSMutableArray *bodyfatDataArray = (NSMutableArray *)[dic valueForKey:@"bodyCompositondata"];
        
        if(bodyfatDataArray != nil){
            [[MySingleton sharedSingleton].nowuserinfo setObject:bodyfatDataArray forKey:@"UserBodyFatDataArray"];
        }
        
        //        NSLog(@"%@",bodyFatDataArray);
        //
        //        _bodyfatDataArray = bodyFatDataArray[0];
        
        //        NSLog(@"日期: %@",[dicdataArray0 valueForKey:@"date"]);
        //        NSLog(@"结果: %@",[dicdataArray0 valueForKey:@"result"]);
        //        NSLog(@"分享id: %@",[dicdataArray0 valueForKey:@"shareid"]);
        //        NSLog(@"肌肉量: %@",[dicdataArray0 valueForKey:@"muscle_value"]);
        //        NSLog(@"脂肪率: %@",[dicdataArray0 valueForKey:@"adiposerate_value"]);
        //        NSLog(@"内脂肪等级: %@",[dicdataArray0 valueForKey:@"visceralfat_value"]);
        //        NSLog(@"水分: %@",[dicdataArray0 valueForKey:@"moisture_value"]);
        //        NSLog(@"骨量: %@",[dicdataArray0 valueForKey:@"bone"]);
        //        NSLog(@"基础代谢: %@",[dicdataArray0 valueForKey:@"thermal"]);
        //        NSLog(@"阻抗: %@",[dicdataArray0 valueForKey:@"impedance"]);
        //        NSLog(@"BMI: %@",[dicdataArray0 valueForKey:@"bmi"]);
        //
        //
        //        if([[dicdataArray0 valueForKey:@"advice"] isKindOfClass:[NSDictionary class]])
        //        {
        //            NSDictionary *dicAdvice = (NSDictionary *)[dicdataArray0 valueForKey:@"advice"];
        //            NSLog(@"commSuggestion: %@",[dicAdvice valueForKey:@"commSuggestion"]);
        //            NSLog(@"doctorSuggestion: %@",[dicAdvice valueForKey:@"doctorSuggestion"]);
        //            NSLog(@"foodSuggestion: %@",[dicAdvice valueForKey:@"foodSuggestion"]);
        //            NSLog(@"sportSuggestion: %@",[dicAdvice valueForKey:@"sportSuggestion"]);
        //        }
        //
        //        bodyFatDataLabel.text =[dicdataArray0 valueForKey:@"adiposerate_value"];
    }
    
    
    NSLog(@"%@",dic);
}

+(void)getBloodPressureDataFromCloud:(NSDate *)starttime
{
    NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
    [fomatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timestr = [fomatter stringFromDate:starttime];
    
    //血压计获取数据
    //http://www.ebelter.com/service/ehealth_getAllBloodPressureData?authkey=NzQ0MzQ4ODAxNzdjNGRiYWFmNWRiMGUyNDk4YmE1NGMjMjAxMy0wNi0yOCAxNjo1OTowNSMxOCN6%0AaF9DTg%3D%3D&startdate=2013-06-01%2000:00:00
    
    NSString *authkey = [[MySingleton sharedSingleton].nowuserinfo valueForKey:@"AuthKey"];
    NSString *url = [[NSString alloc]initWithFormat:@"http://www.ebelter.com/service/ehealth_getAllBloodPressureData?authkey=%@&startdate=%@",authkey,timestr];
    NSDictionary *dic = [ServerConnect getLastData:url];
    
    //    NSArray *bloodPressureDataArray = [[NSArray alloc]init];
    if([[dic valueForKey:@"bloodPressData"] isKindOfClass:[NSArray class]])
    {
        NSMutableArray *bloodpressDataArray = (NSMutableArray *)[dic valueForKey:@"bloodPressData"];
        
        if(bloodpressDataArray != nil){
            [[MySingleton sharedSingleton].nowuserinfo setObject:bloodpressDataArray forKey:@"UserBloodpressDataArray"];
        }
        
        //        NSLog(@"%@",bloodPressureDataArray);
        //
        //        NSDictionary *dicweightdataArray0 = bloodPressureDataArray[0];
        //        NSLog(@"建议: %@",[dicweightdataArray0 valueForKey:@"advice"]);
        //        NSLog(@"日期: %@",[dicweightdataArray0 valueForKey:@"date"]);
        //        NSLog(@"结果: %@",[dicweightdataArray0 valueForKey:@"result"]);
        //        NSLog(@"分享id: %@",[dicweightdataArray0 valueForKey:@"shareid"]);
        //        NSLog(@"收缩压: %@",[dicweightdataArray0 valueForKey:@"systolic"]);
        //        NSLog(@"舒张压: %@",[dicweightdataArray0 valueForKey:@"diastolic"]);
        //        NSLog(@"脉搏: %@",[dicweightdataArray0 valueForKey:@"pulse"]);
        //
        //        if([[dicweightdataArray0 valueForKey:@"advice"] isKindOfClass:[NSDictionary class]])
        //        {
        //            NSDictionary *dicAdvice = (NSDictionary *)[dicweightdataArray0 valueForKey:@"advice"];
        //            NSLog(@"commSuggestion: %@",[dicAdvice valueForKey:@"commSuggestion"]);
        //            NSLog(@"doctorSuggestion: %@",[dicAdvice valueForKey:@"doctorSuggestion"]);
        //            NSLog(@"foodSuggestion: %@",[dicAdvice valueForKey:@"foodSuggestion"]);
        //            NSLog(@"sportSuggestion: %@",[dicAdvice valueForKey:@"sportSuggestion"]);
        //        }
        //
        //        //设置界面的血压数据
        //        bloodPressDataLabel.text = [[NSString alloc]initWithFormat:@"%@/%@",[dicweightdataArray0 valueForKey:@"diastolic"],[dicweightdataArray0 valueForKey:@"systolic"]];
        //        bloodPressResultLabel.text = [dicweightdataArray0 valueForKey:@"result"];
    }
    
    
    NSLog(@"%@",dic);
}

+(void)getTemperatureDataFromCloud:(NSDate *)starttime
{
    NSDateFormatter *fomatter = [[NSDateFormatter alloc] init];
    [fomatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timestr = [fomatter stringFromDate:starttime];
    //体温获取数据 (异常 ，有返回，无数据)
    //http://www.ebelter.com/service/ehealth_getAllTempretureData?authkey=ZWUxYWQ0YzJmZWEyNDAwYWI5N2FlYmMyNzRkOWVlYmEjMjAxNC0wNC0yOCAxNzowMDowMiMzMCN6%0D%0AaF9DTg%3D%3D&startdate=2013-06-01%2000:00:00
    
    NSString *authkey = [[MySingleton sharedSingleton].nowuserinfo valueForKey:@"AuthKey"];
    NSString *url = [[NSString alloc]initWithFormat:@"http://www.ebelter.com/service/ehealth_getAllTempretureData?authkey=%@&startdate=%@",authkey,timestr];
    NSDictionary *dic = [ServerConnect getLastData:url];
    
    //    NSArray *temperatureDataArray = [[NSArray alloc]init];
    if([[dic valueForKey:@"temperaturedata"] isKindOfClass:[NSArray class]])
    {
        NSMutableArray *temperatrueDataArray = (NSMutableArray *)[dic valueForKey:@"temperaturedata"];
        
        if(temperatrueDataArray != nil){
            [[MySingleton sharedSingleton].nowuserinfo setObject:temperatrueDataArray forKey:@"UserTemperatureDataArray"];
        }
        //        NSLog(@"%@",temperatureDataArray);
        //
        //        NSDictionary *dicweightdataArray0 = temperatureDataArray[0];
        //
        //        NSLog(@"日期: %@",[dicweightdataArray0 valueForKey:@"date"]);
        //        NSLog(@"脉搏: %@",[dicweightdataArray0 valueForKey:@"value"]);
        //
        //        if([[dicweightdataArray0 valueForKey:@"advice"] isKindOfClass:[NSDictionary class]])
        //        {
        //            NSDictionary *dicAdvice = (NSDictionary *)[dicweightdataArray0 valueForKey:@"advice"];
        //            NSLog(@"commSuggestion: %@",[dicAdvice valueForKey:@"commSuggestion"]);
        //            NSLog(@"doctorSuggestion: %@",[dicAdvice valueForKey:@"doctorSuggestion"]);
        //            NSLog(@"foodSuggestion: %@",[dicAdvice valueForKey:@"foodSuggestion"]);
        //            NSLog(@"sportSuggestion: %@",[dicAdvice valueForKey:@"sportSuggestion"]);
        //        }
        //
        //        //设置界面的血压数据
        //        _temperatureDataLabel.text = [[NSString alloc]initWithFormat:@"%@",[dicweightdataArray0 valueForKey:@"value"]];
        //        _temperatureResultLabel.text = [dicweightdataArray0 valueForKey:@"result"];
    }
    
}




//根据url获取字典返回
+(NSDictionary *)getDictionaryByUrl:(NSString *)url
{
    NSDictionary *dic = [[NSDictionary alloc]init];
    NSData *revData;
    @try {
        revData = [self doSyncRequest:url];
    }
    @catch (NSException *exception) {
        NSLog(@"**********%@",exception);
    }
    @finally {
        NSLog(@"");
    }
    
    NSError *error = nil;
    id jsonObject;
    if(revData != nil){
        jsonObject = [NSJSONSerialization JSONObjectWithData:revData options:NSJSONReadingAllowFragments error:&error];
    }
    if(jsonObject != nil)
    {
        if([jsonObject isKindOfClass:[NSDictionary class]])
        {
            dic = (NSDictionary *)jsonObject;
        }
    }
    return  dic;
}

//根据url获取字符串返回
+(NSString *)getStringByUrl:(NSString *)url
{
    NSString *str = [[NSString alloc]init];
    NSData *revData;
    @try {
        revData = [self doSyncRequest:url];
    }
    @catch (NSException *exception) {
        NSLog(@"*************%@",exception);
    }
    @finally {
        NSLog(@"");
    }
    
    str = [[NSString alloc] initWithData:revData encoding:NSUTF8StringEncoding];
    return  str;
}


//同步请求
+(NSData *)doSyncRequest:(NSString *)urlString
{
    
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];//转化为正确格式的url
    NSLog(@"%@",urlString);
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10.0];
    
    NSHTTPURLResponse *response;
    NSError *error;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if(error != nil)
    {
        NSLog(@"Error on load = %@", [error localizedDescription]);
        return nil;
    }
    
    if([response isKindOfClass:[NSHTTPURLResponse class]])
    {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if(httpResponse.statusCode != 200)//200服务器返回网页成功
        {
            return nil;
        }
        
        NSLog(@"Headers: %@", [httpResponse allHeaderFields]);
    }
    
    return data;
}

//检查网络是否连接
+ (BOOL) isConnectionAvailable
{
    SCNetworkReachabilityFlags flags;
    BOOL receivedFlags;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(CFAllocatorGetDefault(), [@"www.ebelter.com" UTF8String]);
    receivedFlags = SCNetworkReachabilityGetFlags(reachability, &flags);
    CFRelease(reachability);
    
    if (!receivedFlags || (flags == 0) )
    {
        return FALSE;
    } else {
        return TRUE;
    }
}


@end

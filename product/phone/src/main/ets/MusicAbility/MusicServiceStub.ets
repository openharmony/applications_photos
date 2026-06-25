/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import lazy rpc from '@ohos.rpc';
import lazy { Log } from '@ohos/common/src/main/ets/default/utils/Log';
import lazy { DeviceInfo } from '@ohos/tools/src/main/utils/DeviceInfo';
import lazy { buffer, util } from '@kit.ArkTS';
import lazy fs from '@ohos.file.fs';
import lazy { common } from '@kit.AbilityKit';
import lazy { cryptoFramework } from '@kit.CryptoArchitectureKit';
import lazy RscGetter from '@ohos/tools/src/main/global/RscGetter';
import lazy bundleManager from '@ohos.bundle.bundleManager';
import lazy { fileIo } from '@kit.CoreFileKit'
import { BigDataConstants, ReportToBigDataUtil } from '@ohos/common/src/main/ets/default/utils/ReportToBigDataUtil';

/* instrument ignore file */
const TAG: string = 'MusicServiceStub';

// const TLS_OPTIONS = {
//   tlsVersion: 'TlsV1.2',
//   cipherSuite: [
//     'TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256',
//     'TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384',
//     'TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256',
//     'TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256',
//     'TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384',
//     'TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256'
//   ]
// } as rcp.TlsV12Option;

//Uint8Array转十六进制
function uint8ArrayToHexStr(data: Uint8Array): string {
  return buffer.from(data).toString('hex').toUpperCase();
}

//十六进制转Uint8Array
function hexStrToUint8Array(data: string): Uint8Array {
  return new Uint8Array(buffer.from(data, 'hex').buffer);
}

// 字符串转成字节流
function stringToUint8Array(str: string) {
  return new Uint8Array(buffer.from(str, 'utf-8').buffer);
}

export default class MusicServiceStub extends rpc.RemoteObject {
  private musicContext: common.ServiceExtensionContext;

  public constructor(des: string, context: common.ServiceExtensionContext) {
    super(des);
    this.musicContext = context;
  }

  GenerateAuthorization(message: string): string {
    let authorization = '';
    try {
      let part1 = '7B5547C57F67B79';
      let part2 = new RscGetter(this.musicContext.resourceManager).getString($r('app.string.musicServiceAuth'));
      let part3 = '93849A19E500A643B73882CDAD7';
      let matchWords = 'service-platform-mediaanalysis'; // 分配的matchWords
      let nonce = util.generateRandomUUID(true).slice(0, 32); // 生成32位包含字母和数字的随机数
      let date = new Date().toISOString(); // 当前时间,UTC格式
      let macAlgName = 'SHA256'; // 使用SHA256加密方式
      let authValidation = part1 + part2 + part3;
      let key = authValidation + nonce + date;
      let keyBytes = hexStrToUint8Array(key);
      let dataBytes = stringToUint8Array(message);
      let symKey = cryptoFramework.createSymKeyGenerator('HMAC').convertKeySync({
        data: keyBytes,
      });
      let mac = cryptoFramework.createMac(macAlgName);
      mac.initSync(symKey);
      mac.updateSync({
        data: dataBytes,
      });
      let macOutput = mac.doFinalSync();
      let str = uint8ArrayToHexStr(macOutput.data);
      authorization = 'Digest username = ' + matchWords + ',nonce = ' + nonce + ',created = ' + date +
        ',response = security:' + str;
      return authorization;
    } catch (err) {
      Log.error(TAG, `HmacSha256Hex failed with err : ${err}`);
      return authorization;
    }
  }

  public async GetGrsAddress(): Promise<string> {
    // let copyFlag: boolean = await GrsFileUtil.copyGrsConfigFile(this.musicContext, true);
    // let urlAddress = '';
    // if (copyFlag) {
    //   let grsService: GRSService = new GRSService();
    //   let initResult = await grsService.Init(this.info, this.musicContext);
      // if (initResult.code === GrsError.ERR_OK) {
      //   Log.info(TAG, 'Grs Init success');
      //   let urlResult = await grsService.SyncGetGrsUrl('com.xxx.cloud.music', 'ROOT');
      //   urlAddress = urlResult.message;
      //   Log.info(TAG, `urlResult: ${JSON.stringify(urlResult)}`);
      //   Log.info(TAG, `urlResult: ${urlResult.message}`);
      // } else {
      //   Log.info(TAG, `Grs init failed: ${JSON.stringify(initResult)}`);
      // }
    // } else {
    //   Log.error(TAG, 'Grs Config File Copy Failed');
    // }
    // return urlAddress;
    return ''
  }

  monitorNetworkStatus(): boolean {
    let networkConnectionStatus: boolean | undefined = AppStorage.get('networkConnectionStatus');
    Log.info(TAG, `Photo NetworkConnectionStatus: ${networkConnectionStatus}`);
    if (!networkConnectionStatus) {
      return false;
    }
    return true;
  }

  // 判断路径是否有效
  private isValidatePath(path: string): boolean {
    if (!/^[a-zA-Z0-9_-]*$/.test(path)) {
      return false;
    }
    return true;
  }

  /**
   * 获取应用版本号
   * @returns
   */
  private getAppVersion(): string {
    let bundleInfo: bundleManager.BundleInfo =
      bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT);
    return bundleInfo.versionName;
  }

  private generateTraceId(): string {
    let randomStr: string = util.generateRandomUUID(true).slice(0, 16); // 生成16位包含字母和数字的随机数
    let deviceId: string = DeviceInfo.getODID().slice(0, 16);
    Log.info(TAG, `request traceId front part: ${randomStr}`);
    return randomStr + deviceId;
  }

  private async getMusicMessage(code: number, urlAddress: string, data: rpc.MessageSequence,
    reply: rpc.MessageSequence): Promise<boolean> {
    switch (code) {
      case MusicServiceStub.COMMAND_GET_MUSIC_METADATA_ADDRESS: {
        let categoryIDs: string = data.readString();
        let startIndex: string = data.readString();
        if (categoryIDs === '') {
          return false;
        }
        if (startIndex === '') {
          Log.info(TAG, 'getMusicMessage startIndex is null');
          startIndex = '0';
        }
        let httpAddress: string = `${urlAddress}music-search-service/v3/service/categorysearch`;
        let auth = this.GenerateAuthorization(httpAddress);
        let searchAddress: string = await this.httpRequestSearchAddress(categoryIDs, httpAddress, startIndex, auth);
        reply.writeString(searchAddress);
        return true;
      }

      case MusicServiceStub.COMMAND_GET_MUSIC_METADATA: {
        let searchAddress: string = data.readString();
        let metaData: string = await this.httpRequestSearchData(searchAddress);
        reply.writeString(metaData);
        return true;
      }

      case MusicServiceStub.COMMAND_GET_MUSICDATA_ADDRESS: {
        let musicId = data.readString();
        if (musicId === '') {
          return false;
        }
        let httpAddress: string = `${urlAddress}music-play-service/v3/service/file/bycontentcode`;
        let auth = this.GenerateAuthorization(httpAddress);
        let musicAddress: string = await this.httpRequestMusicAddress(musicId, httpAddress, auth);
        reply.writeString(musicAddress);
        return true;
      }

      case MusicServiceStub.COMMAND_GET_MUSICDATA: {
        let musicAddress: string = data.readString();
        let musicName: string = data.readString();
        if (!this.isValidatePath(musicName)) {
          return false;
        }
        let path: string = this.musicContext.filesDir + `/${musicName}` + '.mp3';
        Log.info(TAG, `musicName: ${musicName}`);
        this.httpRequestMusicData(musicAddress, path);
        reply.writeString(path);
        return true;
      }

      default: {
        Log.info(TAG, `invalid request code: ${code}`);
        break;
      }
    }
    return false;
  }

  public async onRemoteMessageRequest(code: number, data: rpc.MessageSequence, reply: rpc.MessageSequence,
    option: rpc.MessageOption): Promise<boolean> {
    if (this.getDescriptor() !== data.readInterfaceToken()) {
      Log.error(TAG, 'service process error: descriptor is illegal');
      return false;
    }
    if (!this.monitorNetworkStatus()) {
      return false;
    }
    let urlAddress: string = await this.GetGrsAddress();
    if (urlAddress === '') {
      return false;
    }
    return await this.getMusicMessage(code, urlAddress, data, reply);
  }

  public async httpRequestSearchAddress(categoryIDs: string, httpAddress: string, startIndex: string,
    auth: string): Promise<string> {
    // let jsonAddress: string = '';
    // let headers: rcp.RequestHeaders = {
    //   'Content-Type': 'application/json;charset=UTF-8',
    //   'Authorization': auth,
    //   'x-deviceid': DeviceInfo.getODID(),
    //   'x-client-version': this.getAppVersion(),
    //   'Accept-Lang': 'zh',
    //   'x-clienttraceid': this.generateTraceId(),
    // };
    // let content: rcp.RequestContent = {
    //   'contentType': '77',
    //   'categoryIDs': [categoryIDs],
    //   'start': startIndex,
    //   'limit': '10', // json数目限制
    //   'sort': '1',
    //   'conditionType': '1',
    // };
    // let session = rcp.createSession({
    //   requestConfiguration: {
    //     security: {
    //       tlsOptions: TLS_OPTIONS,
    //     }
    //   }
    // });
    // let request = new rcp.Request(httpAddress, 'POST', headers, content);
    // try {
    //   let response: rcp.Response = await session.fetch(request);
    //   jsonAddress = response.toString() as string;
    // } catch (err) {
    //   Log.error(TAG, `httpRequestSearchAddress error: ${err?.code}, code: ${err?.message}`);
    // } finally {
    //   session.close();
    // }
    // Log.info(TAG, `ServiceAbility jsonAddress : ${jsonAddress}`);
    // return jsonAddress;
    return ''
  }

  public async httpRequestMusicAddress(musicId: string, httpAddress: string, auth: string): Promise<string> {
    // let musicAddress: string = '';
    // Log.info(TAG, `ServiceAbility httpAddress : ${httpAddress}`);
    // let headers: rcp.RequestHeaders = {
    //   'Content-Type': 'application/json;charset=UTF-8',
    //   'Authorization': auth,
    //   'x-deviceid': DeviceInfo.getODID(),
    //   'x-client-version': this.getAppVersion(),
    //   'Accept-Lang': 'zh',
    //   'x-clienttraceid': this.generateTraceId(),
    // };
    // let content: rcp.RequestContent = {
    //   'contentType': '77',
    //   'algType': '1',
    //   'contentCode': musicId,
    //   'qualityType': '1',
    //   'actionType': '2',
    // };
    // let session = rcp.createSession({
    //   requestConfiguration: {
    //     security: {
    //       tlsOptions: TLS_OPTIONS,
    //     }
    //   }
    // });
    // let request = new rcp.Request(httpAddress, 'POST', headers, content);
    // try {
    //   let response: rcp.Response = await session.fetch(request);
    //   musicAddress = response.toString() as string;
    // } catch (err) {
    //   Log.error(TAG, `httpRequestMusicAddress error: ${err?.code}, code: ${err?.message}`);
    // } finally {
    //   session.close();
    // }
    // return musicAddress;
    return ''
  }

  public async httpRequestSearchData(jsonAddress: string): Promise<string> {
    // Log.info(TAG, `ServiceAbility jsonAddress : ${jsonAddress}`);
    // let requestResult: string = '';
    // try {
    //   let res = '';
    //   let dataReceive: rcp.OnDataReceive = (incomingData: ArrayBuffer): void => {
    //     Log.info(TAG, `ServiceAbility json dataReceive : ${incomingData}`);
    //     let test = incomingData as ArrayBuffer;
    //     let textDecoder = util.TextDecoder.create('utf-8');
    //     requestResult = textDecoder.decodeWithStream(new Uint8Array(test));
    //     res += requestResult;
    //   };
    //   let onHeaderReceive: rcp.OnHeaderReceive = (headers: rcp.ResponseHeaders): void => {
    //     console.info(`ServiceAbility header: ${JSON.stringify(headers)}`);
    //   };
    //   let onDataEnd: rcp.OnDataEnd = (): void => {
    //     Log.info(TAG, 'json receive end');
    //   };
    //   let tracingConfig: rcp.TracingConfiguration = {
    //     verbose: true,
    //     httpEventsHandler: {
    //       onDataReceive: dataReceive,
    //       onHeaderReceive: onHeaderReceive,
    //       onDataEnd: onDataEnd,
    //     }
    //   };
      // let session = rcp.createSession({
      //   requestConfiguration: {
      //     tracing: tracingConfig,
      //     security: {
      //       tlsOptions: TLS_OPTIONS,
      //     }
      //   }
      // });
    //   try {
    //     let request = new rcp.Request(jsonAddress, 'GET');
    //     await session.fetch(request);
    //   } catch (err) {
    //     Log.error(TAG, `httpRequestSearchData error: ${err?.code}, code: ${err?.message}`);
    //   } finally {
    //     session.close();
    //   }
    //   return res;
    // } catch {
    //   Log.info(TAG, 'ServiceAbility get musicAddress is error');
    //   return '';
    // }
    return ''
  }

  public async httpRequestMusicData(musicAddress: string, path: string): Promise<void> {
    // Log.info(TAG, `ServiceAbility musicAddress : ${musicAddress}`);
    // let requestResult: string = '';
    // let file: fs.File = await fs.open(path, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
    // let stat = await fs.stat(file.fd);
    // let fileSize: number = stat.size;
    // Log.info(TAG, `mp3 fileSize : ${fileSize}`);
    // if (fileSize !== 0) {
    //   Log.info(TAG, 'this mp3 is already exist, do not need download');
    //   fs.closeSync(file);
    //   return;
    // }
    // try {
    //   let res = '';
    //   let allowReceive = true;
    //   let byteLen = 0;
    //   let contentLength = 0;
    //   setTimeout(() => {
    //     allowReceive = false; // 时间到后终止写入
    //     Log.info(TAG, '4 seconds have passed. Stop receiving file data.');
    //   }, 4000);
    //   let dataReceive: rcp.OnDataReceive = (incomingData: ArrayBuffer): void => {
    //     if (!allowReceive) {
    //       return;
    //     }
    //     fs.writeSync(file.fd, incomingData);
    //     Log.info(TAG, `ServiceAbility mp3 dataReceive : ${incomingData}`);
    //     let test = incomingData as ArrayBuffer;
    //     let textDecoder = util.TextDecoder.create('utf-8');
    //     requestResult = textDecoder.decodeWithStream(new Uint8Array(test));
    //     res += requestResult;
    //     byteLen += incomingData.byteLength;
    //   };
    //   let onHeaderReceive: rcp.OnHeaderReceive = (headers: rcp.ResponseHeaders): void => {
    //     console.info(`ServiceAbility header: ${JSON.stringify(headers)}`);
    //     contentLength = parseInt((JSON.parse(JSON.stringify(headers)))['content-length']);
    //     Log.info(TAG, `String header: ${(JSON.parse(JSON.stringify(headers)))['content-length']}`)
    //   };
    //   let onDataEnd: rcp.OnDataEnd = (): void => {
    //     if (byteLen != contentLength) {
    //       fileIo.unlink(path);
    //       Log.info(TAG, `The file is incomplete. Delete this file.`)
    //     }
    //     Log.info(TAG, 'Music music data receive end');
    //     ReportToBigDataUtil.report(BigDataConstants.SINGLE_MUSIC_DOWNLOAD)
    //   };
    //   let tracingConfig: rcp.TracingConfiguration = {
    //     verbose: true,
    //     httpEventsHandler: {
    //       onDataReceive: dataReceive,
    //       onHeaderReceive: onHeaderReceive,
    //       onDataEnd: onDataEnd,
    //     }
    //   };
    //   let session = rcp.createSession({
    //     requestConfiguration: {
    //       tracing: tracingConfig,
    //       security: {
    //         tlsOptions: TLS_OPTIONS,
    //       }
    //     }
    //   });
    //   try {
    //     let request = new rcp.Request(musicAddress, 'GET');
    //     await session.fetch(request);
    //   } catch (err) {
    //     Log.error(TAG, `httpRequestMusicData error: ${err?.code}, code: ${err?.message}`);
    //   } finally {
    //     session.close();
    //   }
    // } catch {
    //   Log.error(TAG, 'ServiceAbility get musicData is error');
    // } finally {
    //   if (file) {
    //     Log.info(TAG, `[fd flag] httpRequestMusicData ,fs close fd: ${file.fd}`);
    //     fs.closeSync(file);
    //   }
    // }
  }

  // private info: BaseInfoType = {
  //   'packageName': 'com.ohos.photos',
  //   'packageVersion': '0.0.1',
  //   'productName': 'Photos',
  //   'productLine': 'XXX',
  //   'appName': 'com.xxx.cloud.music',
  //   'configureFilePath': '',
  //   'regCountry': 'CN',
  //   'serCountry': 'CN',
  //   'issueCountry': 'CN',
  // };
  private static readonly COMMAND_GET_MUSIC_METADATA_ADDRESS = 0;
  private static readonly COMMAND_GET_MUSIC_METADATA = 1;
  private static readonly COMMAND_GET_MUSICDATA_ADDRESS = 2;
  private static readonly COMMAND_GET_MUSICDATA = 3;
}
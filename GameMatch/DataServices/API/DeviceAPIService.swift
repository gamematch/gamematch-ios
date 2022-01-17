//
//  DeviceAPIService.swift
//  GameMatch
//
//  Created by Luke Shi on 10/16/21.
//

import Foundation

class DeviceAPIService: BaseAPIService
{
    func register(deviceToken: String,
                  completion: @escaping (Result<DeviceInfo, Error>) -> Void)
    {
        let deviceInfo = DeviceInfo(token: deviceToken)
        
        post(request: APIRequests.device,
             parameters: deviceInfo.dict,
             completion: { (result: Result<DeviceInfo, Error>) in
                            switch result {
                            case .success(let deviceInfo):
                                print("========== deviceInfo: \(String(describing: deviceInfo.deviceId)) ===========")
                                completion(.success(deviceInfo))
                            case .failure(let error):
                                print("========== error: \(error) ===========")
                                completion(.failure(error))
                            }
                         })
    }
    
    func update(deviceId: String,
                deviceToken: String,
                completion: @escaping (Result<Void, Error>) -> Void)
    {
        let deviceInfo = DeviceInfo(token: deviceToken)
        
        put(request: APIRequests.device,
            pathParam: deviceId,
            parameters: deviceInfo.dict,
            completion: { (result: Result<Void, Error>) in
                            switch result {
                            case .success():
                                completion(.success(()))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                         })
    }
}

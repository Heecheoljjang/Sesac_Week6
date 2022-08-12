//
//  CameraViewController.swift
//  SesacWeek6
//
//  Created by HeecheolYoon on 2022/08/12.
//

import UIKit
import YPImagePicker
import Alamofire
import SwiftyJSON

class CameraViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    //UIimagePickerController 1. 인스턴스 생성
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UIimagePickerController 2.
        picker.delegate = self

       
    }
    

    //오픈소스 사용
    //일단 권한 다 허용
    //권한 문구 등도 내부적으로 구현되어있음. 실제로 카메라를 쓸 때 권한을 요청
    @IBAction func ypImagePicker(_ sender: UIButton) {
        let picker = YPImagePicker()
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                print(photo.fromCamera) // Image source (camera or library)
                print(photo.image) // Final image selected by the user
                print(photo.originalImage) // original image selected by the user, unfiltered
                print(photo.modifiedImage) // Transformed image, can be nil
                print(photo.exifMeta) // Print exif meta data of original image. -> 날짜, 위치 등 메타데이터
                self.imageView.image = photo.image
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    
    //UIImagePickerController
    @IBAction func cameraButtonClicked(_ sender: UIButton) {
        
        //소스타입에는 세가지가 있음(카메라, 포토라이브러리, 세이브)
        //기능이 들어있는지 안들어있는지 확인하는구문
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("사용불가 + 얼럿띄우는 등")
            return
        }
        
        //어떤 화면을 띄울건지
        picker.sourceType = .camera
        
        //촬영하고나서 편집을 할 수 있는지(디폴트는 false)
        picker.allowsEditing = true
        present(picker, animated: true)
        
    }
    
    //UIimagePickerController
    @IBAction func photoLibraryButtonClicked(_ sender: UIButton) {
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("사용불가 + 얼럿띄우는 등")
            return
        }
        
        //어떤 화면을 띄울건지
        picker.sourceType = .photoLibrary // 조건문을 써서 다양한 타입 가능
        
        //촬영하고나서 편집을 할 수 있는지(디폴트는 false)
        picker.allowsEditing = true //false라면 아래에서 edited이미지 사용불가
        present(picker, animated: true)
        
    }
    //단순히 저장, 특정한 앨범에 저장
    @IBAction func saveToPhotoLibrary(_ sender: UIButton) {
        
        if let image = imageView.image {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
    //이미지뷰 이미지 -> 네이버 -> 얼굴 분석 -> 응답
    //문자열이 아닌 파일, 이미지, pdf 파일은 그대로 전송하기 힘듦. => 텍스트 형태로 인코딩
    //어떤 파일의 종류가 서버에게 전달이 되는지 명시해야함 = content-type -> 보통 헤더에 추가
    //contenttype생략해도 응답이 옴
    @IBAction func clovaFaceButtonClicked(_ sender: UIButton) {
        
        let url = "https://openapi.naver.com/v1/vision/celebrity"
        
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": "JPn2BexzHtawtjBLviCv",
            "X-Naver-Client-Secret": "z4H3ty26JR",
            //"Content-Type": "multipart/form-data" -> 코드에 따라 디폴트값이 라이브러리에 내장되어잇음.
        ]
        
        // UIIMage를 텍스트형태(바이너리 타입)로 변환해서 전달
        //jpegData도 있음 -> 압축 가능
        guard let imageData = imageView.image?.jpegData(compressionQuality: 0.3) else { return }
        //guard let imageData = imageView.image?.pngData() else { return }
        
        AF.upload(multipartFormData: { multipartFormData in
            //여기에 데이터 들어감. 클로바에서 메세지의 네임은 이미지여야한다니까 withName을 image로 전달
            multipartFormData.append(imageData, withName: "image")
            
        }, to: url, headers: header).validate(statusCode: 200...500).responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

//UIimagePickerController 3. 익스텐션 구현 (두 가지 채택해야함)
//네비게이션컨트롤러를 상속받고있어서 같이 딜리게이트채택
extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //UIImagePicker4. 사진을 선택하거나 카메라 촬영직후
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(#function)
        
        //원본, 편집, 메타 데이터 등 -infokey
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageView.image = image
            dismiss(animated: true)
        }
    }
    
    //UIimagePickerController 5. 왼쪽 아래의 취소버튼 눌렀을때 호출
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print(#function)
        dismiss(animated: true)
    }
    
}

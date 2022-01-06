//
//  ProfileViewController.swift
//  Game Match
//
//  Created by Luke Shi on 8/11/21.
//

import UIKit
import MobileCoreServices
import AVFoundation

class ProfileViewController: BaseViewController
{
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var contactField: UITextField!

    private let profileVM = ProfileViewModel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        navigationItem.title = "Profile"

        let avatarTapGesture = UITapGestureRecognizer(target: self, action: #selector(changePhoto))
        avatarView.addGestureRecognizer(avatarTapGesture)
    }

    @objc private func changePhoto()
    {
        var selections: [MenuAction] = []
        selections.append((title: "Take Picture", actionStyle: .default, action: self.openCamera))
        selections.append((title: "From Photo Album", actionStyle: .default, action: self.readPhotoAlbum))

        showAlertController(title: "Upload Photo",
                            with: selections)
    }
    
    @IBAction func closeAction(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoutAction(_ sender: UIBarButtonItem)
    {
        SessionManager.shared.clear()
        
        profileVM.logout()
        
        closeAction(sender)
    }

    @IBAction func changePasswordAction()
    {
        if let nextScreen = UIStoryboard(name: "Main",
                                         bundle: nil).instantiateViewController(identifier: "PasswordViewController") as? PasswordViewController {
            navigationController?.pushViewController(nextScreen, animated: true)
        }
    }
    
    private func openCamera()
    {
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .authorized
        {
            takePicture()
        }
        else
        {
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { [weak self] permissionGranted in
                DispatchQueue.main.async {
                    if permissionGranted {
                        self?.takePicture()
                    } else {
                        print("To take a photo, allow app to access your camera in Settings")
                    }
                }
            }
        }
    }

    private func readPhotoAlbum()
    {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    private func takePicture()
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.cameraDevice = .front
        picker.mediaTypes = [kUTTypeImage as String]
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
}

extension ProfileViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
    {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let chosenImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {
            avatarView.image = chosenImage
        }
        picker.dismiss(animated: true, completion: nil)
    }

    // Helper function inserted by Swift 4.2 migrator.
    private func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any]
    {
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (key.rawValue, value) })
    }

    // Helper function inserted by Swift 4.2 migrator.
    private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String
    {
        return input.rawValue
    }
}

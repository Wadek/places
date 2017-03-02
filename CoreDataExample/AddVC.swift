//
//  ViewController.swift
//  CoreDataExample
//
//  Created by Kariniemi, Wade (NE) on 03/02/167
//  Copyright © 2017 wade. All rights reserved.
//

import UIKit
import CoreData


class AddVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var imageSelected: UIImageView!
    let picker = UIImagePickerController()
    
    @IBOutlet weak var imageSource: UISegmentedControl!
    
    let appDelegateObj : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var editRecNo = Int()
    var dataArray = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if editRecNo != -1 {
            txtName.text = self.dataArray[editRecNo].value(forKey: kNameStr) as? String
            txtPhone.text = self.dataArray[editRecNo].value(forKey: kDescStr) as? String
        }
        picker.delegate = self
    }
    

    @IBAction func addImage(_ sender: Any) {
        
        if imageSource.selectedSegmentIndex == 1
        {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.allowsEditing = false
                picker.sourceType = UIImagePickerControllerSourceType.camera
                picker.cameraCaptureMode = .photo
                picker.modalPresentationStyle = .fullScreen
                present(picker,animated: true,completion: nil)
            } else {
                print("No camera")
            }
            
        }else{
            picker.allowsEditing = false
            picker.sourceType = .photoLibrary
            picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            picker.modalPresentationStyle = .popover
            present(picker, animated: true, completion: nil)
        }
    }

    
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        picker .dismiss(animated: true, completion: nil)
        imageSelected.image=info[UIImagePickerControllerOriginalImage] as? UIImage
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnDoneTapped(_ sender: AnyObject) {
        
        if editRecNo != -1 {
            self.dataArray[editRecNo].setValue(txtName.text!, forKey: kNameStr)
            self.dataArray[editRecNo].setValue(txtPhone.text!, forKey: kDescStr)
            
            do {
                try self.dataArray[editRecNo].managedObjectContext?.save()
            } catch {
                print("Error occured during updating entity")
            }
        } else {
            let entityDescription = NSEntityDescription.entity(forEntityName: kEntityStr, in: appDelegateObj.managedObjectContext)
            let newPerson = NSManagedObject(entity: entityDescription!, insertInto: appDelegateObj.managedObjectContext)
            newPerson.setValue(txtName.text!, forKey: kNameStr)
            newPerson.setValue(txtPhone.text!, forKey: kDescStr)
            
            do {
                try newPerson.managedObjectContext?.save()
            } catch {
                print("Error occured during save entity")
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnCancelTappe(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

}


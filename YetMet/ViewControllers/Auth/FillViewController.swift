//
//  FillViewController.swift
//  YetMet
//
//  Created by Sun on 2021/8/6.
//

import UIKit
import DKImagePickerController
import CropViewController

class FillViewController: UIViewController {

    @IBOutlet weak var fullname_text: UITextField!
    @IBOutlet weak var location_text: UITextField!
    @IBOutlet weak var job_text: UITextField!
    @IBOutlet weak var salary_text: UITextField!
    @IBOutlet var collectionViews: [UICollectionView]!
    @IBOutlet weak var height_view: UIStackView!
    @IBOutlet var images: [UIImageView]!
    @IBOutlet var photo_btns: [UIButton]!
    @IBOutlet weak var info_stack_height: NSLayoutConstraint!
    @IBOutlet weak var salary_view: UIView!
    
    var userpf = NSMutableDictionary()
    var isMale = Bool()
    
    private var ranges = [[Int]]()
    private var values = [Int]()
    
    private var location: Location!
    private var alertError: String = ""
    private var profile_images: [UIImage?] = [nil, nil, nil, nil, nil, nil]
    private var profile_index = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        init_UI()
        setupCollectionView()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func location_btn_click(_ sender: Any) {
        let alert = UIAlertController(style: .actionSheet, source: nil, title: NSLocalizedString("Pick Location", comment: ""), message: nil, tintColor: nil)
        alert.addLocationPicker { (location) in
            if let loc = location {
                self.location = loc
                self.location_text.text = loc.address
            }
        }
        alert.addAction(image: nil, title: L_CANCEL, color: nil, style: .cancel, isEnabled: true) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.show()
    }
    
    @IBAction func photo_btn_click(_ sender: UIButton) {
        profile_index = sender.tag
        let picker = DKImagePickerController()
        picker.singleSelect = true
        picker.sourceType = .both
        picker.assetType = .allPhotos
        picker.didSelectAssets = {[unowned self] (assets: [DKAsset]) in
            for asset in assets {
                asset.fetchOriginalImage { (image: UIImage?, _: [AnyHashable: Any]?) in
                    let cropper = CropViewController(croppingStyle: .default, image: image!)
                    cropper.delegate = self
                    self.present(cropper, animated: true, completion: nil)
                }
            }
        }
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func submit_btn_click(_ sender: Any) {
        if checkFields() {
            userpf.setValue(fullname_text.text, forKey: u_fname)
            let firstname = fullname_text.text?.components(separatedBy: " ")
            userpf.setValue((firstname?[0] ?? "") as String, forKey: u_name)
            userpf.setValue(job_text.text, forKey: u_job)
            if let location = self.location {
                var positions = [Double]()
                positions.append(location.coordinate.latitude)
                positions.append(location.coordinate.longitude)
                userpf.setValue(positions, forKey: u_location)
                userpf.setValue(location.address, forKey: u_locationText)
            }
            userpf.setValue(values[0], forKey: u_birth_day)
            userpf.setValue(values[1], forKey: u_birth_month)
            userpf.setValue(values[2], forKey: u_birth_year)
            userpf.setValue(DateComponents(calendar: .current, year: values[2], month: values[1], day: values[0]).date!, forKey: u_age)
            profile_images = profile_images.filter({$0 != nil})
            self.uploadImages(0)
        } else {
            let alertController = UIAlertController(title: L_ERROR, message: alertError, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: L_OK, style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Upload Images
    func uploadImages(_ index: Int) {
        if index == profile_images.count {
            DispatchQueue.main.async {
                self.goNextStep()
            }
        } else {
            self.showHUD("Uploading Photos...")
            let scaledImage = scaleImage(image: profile_images[index]!, and: CGSize(width: 320, height: 320)).jpegData(compressionQuality: 0.7)
            uploadImage(imageData: scaledImage!) { (urlStr) in
                self.dismissHUD()
                switch index {
                case 0:
                    self.userpf.setValue(urlStr, forKey: u_pic1)
                    self.userpf.setValue(urlStr, forKey: u_dpLarge)
                    self.userpf.setValue(urlStr, forKey: u_dpSmall)
                    break
                case 1:
                    self.userpf.setValue(urlStr, forKey: u_pic2)
                    break
                case 2:
                    self.userpf.setValue(urlStr, forKey: u_pic3)
                    break
                case 3:
                    self.userpf.setValue(urlStr, forKey: u_pic4)
                    break
                case 4:
                    self.userpf.setValue(urlStr, forKey: u_pic5)
                    break
                case 5:
                    self.userpf.setValue(urlStr, forKey: u_pic6)
                    break
                default:
                    break
                }
                self.uploadImages(index+1)
            }
        }
    }
    
    func goNextStep() {
        if isMale {
            userpf.setValue(Double(salary_text.text ?? "0"), forKey: u_salary)
            let vc = self.storyboard?.instantiateViewController(identifier: "SubscriptionViewController") as! SubscriptionViewController
            vc.userpf = self.userpf
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            userpf.setValue(values[3], forKey: u_height)
            userpf.setValue(values[4], forKey: u_weight)
            userpf.setValue(false, forKey: u_activate)
            self.createUserWoman()
        }
    }
    
    // MARK: - Create Woman
    func createUserWoman() {
        self.showHUD()
        let email = userpf.object(forKey: u_email) as? String ?? ""
        let password = userpf.object(forKey: u_password) as? String ?? ""
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            self.dismissHUD()
            if let error = error as NSError? {
                var alertMsg:String = ""
                switch AuthErrorCode(rawValue: error.code) {
                    case .operationNotAllowed:
                        alertMsg = NSLocalizedString("The operations is not allowed.", comment: "")
                      break
                    case .emailAlreadyInUse:
                        alertMsg = NSLocalizedString("Your email address is already in use.", comment: "")
                      print("emailAlreadyInUse")
                      break
                    case .invalidEmail:
                        alertMsg = NSLocalizedString("Your email address is malformed.", comment: "")
                      print("invalidEmail")
                      break
                    case .weakPassword:
                        alertMsg = NSLocalizedString("Your password is weak. Please try with strong password.", comment: "")
                      print("weakPassword")
                      break
                    default:
                        alertMsg = "Error: \(error.localizedDescription)"
                      print("Error: \(error.localizedDescription)")
                }
                let alertController = UIAlertController(title: L_ERROR, message: alertMsg, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: L_OK, style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            } else {
                let userId = Auth.auth().currentUser!.uid as String?
                self.userpf.setValue(userId, forKey: "userId")
                currentuser = self.userpf
                
                let ref = Database.database().reference()
                ref.child("users").child(userId!).setValue(self.userpf) {
                    (error:Error?, ref:DatabaseReference) in
                    if let error = error {
                        print("Data could not be saved: \(error).")
                    } else {
                        print("Data saved successfully!")
                        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                            getCurrentUser { (result) in
                              if result {
                                DispatchQueue.main.async {
                                    let vc = self.storyboard?.instantiateViewController(identifier: "FinalViewController") as! FinalViewController
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                              }
                            }
                        })
                    }
                }
            }
        }
    }
    
    func checkFields() -> Bool {
        if (fullname_text.text?.isEmpty ?? true) || (location_text.text?.isEmpty ?? true) || (job_text.text?.isEmpty ??  true) {
            alertError = NSLocalizedString("Oops! Text is empty", comment: "")
            return false
        } else if isMale && salary_text.text!.isEmpty {
            alertError = NSLocalizedString("Oops! Text is empty", comment: "")
            return false
        } else if !isMale && profile_images.filter({$0 != nil}).count < 6 {
            alertError = NSLocalizedString("Add your photo", comment: "")
            return false
        }
        return true
    }
    
    func setupCollectionView() {
        collectionViews.forEach{
            $0.delegate = self
            $0.dataSource = self
            $0.isPagingEnabled = true
            $0.showsVerticalScrollIndicator = false
            $0.register(UINib(nibName: "CountCell", bundle: nil), forCellWithReuseIdentifier: "CountCell")
            $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            $0.reloadData()
        }
    }
    
    // MARK: - Init UI
    func init_UI() {
        ranges = [
            [Int](1...31), [Int](1...12), [Int](1950...2021), [Int](140...200), [Int](50...150)
        ]
        values = [15, 7, 1992, 170, 85]
        height_view.isHidden = isMale
        info_stack_height.constant = isMale ? 220 : 140
        salary_view.isHidden = !isMale
        images.forEach{$0.image = UIImage(named: isMale ? "ic_male" : "ic_female")}
    }
}

// MARK: - CropViewControllerDelegate
extension FillViewController: CropViewControllerDelegate {
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: nil)
        
        self.images[profile_index].image = image
        self.profile_images[profile_index] = image
    }
}

// MARK: - CollectionView
extension FillViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return ranges[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CountCell", for: indexPath) as! CountCell
        
        cell.value = ranges[collectionView.tag][indexPath.row]
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for i in 0 ..< self.collectionViews.count {
            for cell in collectionViews[i].visibleCells {
                let indexPath = collectionViews[i].indexPath(for: cell)
                self.values[i] = self.ranges[i][indexPath!.row]
            }
        }
    }
}

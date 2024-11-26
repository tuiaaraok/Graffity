//
//  OrderFormViewController.swift
//  Graffity
//
//  Created by Karen Khachatryan on 26.11.24.
//

import UIKit
import FSPagerView
import Combine
import PhotosUI

class OrderFormViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameTextField: BaseTextField!
    @IBOutlet weak var dateTextField: BaseTextField!
    @IBOutlet weak var priceTextField: PricesTextField!
    @IBOutlet weak var locationTextField: BaseTextField!
    @IBOutlet weak var infoTextView: PaddingTextView!
    @IBOutlet weak var pagerView: FSPagerView!
    @IBOutlet weak var pageControl: FSPageControl!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var createButton: BaseButton!
    private let datePicker = UIDatePicker()
    private let viewModel = OrderFormViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
    }

    func setupUI() {
        setNavigationTitle(title: "ADD ORDERS")
        setNaviagtionBackButton(title: "cancel")
        nameTextField.delegate = self
        dateTextField.delegate = self
        priceTextField.baseDelegate = self
        locationTextField.delegate = self
        infoTextView.delegate = self
        infoTextView.font = .bold(size: 26)
        pagerView.layer.borderWidth = 2
        pagerView.layer.borderColor = UIColor.black.cgColor
        pagerView.layer.masksToBounds = true
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.contentMode = .center
        pagerView.transformer = FSPagerViewTransformer(type: .linear)
        pagerView.itemSize = pagerView.bounds.size
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        pageControl.contentHorizontalAlignment = .center
        pageControl.setFillColor(.white, for: .selected)
        pageControl.setFillColor(.black, for: .normal)
        tapGesture.delegate = self
        datePicker.locale = NSLocale.current
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.addTarget(self, action: #selector(startDatePickerValueChanged), for: .valueChanged)
        dateTextField.inputView = datePicker
    }
    
    func subscribe() {
        viewModel.$orderModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] order in
                guard let self = self else { return }
                self.nameTextField.text = order.name
                self.dateTextField.text = order.date?.toString()
                self.priceTextField.text = order.price?.formattedToString()
                self.locationTextField.text = order.location
                self.infoTextView.text = order.info
                self.createButton.isEnabled = (order.name.checkValidation() && order.date != nil && order.price != nil && order.info.checkValidation() && order.location.checkValidation() && (UIImage(data: order.photos.first ?? Data()) != UIImage.imagePlaceholder))
                self.pageControl.numberOfPages = order.photos.count
                let size = (UIImage(data: order.photos.first ?? Data()) != UIImage.imagePlaceholder) ? self.pagerView.bounds.size : CGSize(width: 49, height: 25)
                self.pagerView.itemSize = size
                self.pagerView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    func choosePhoto() {
        let actionSheet = UIAlertController(title: "Select Image", message: "Choose a source", preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
                guard let self = self else { return }
                self.requestCameraAccess()
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.requestPhotoLibraryAccess()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view // Your source view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        present(actionSheet, animated: true, completion: nil)
    }
    
    @objc func startDatePickerValueChanged() {
        viewModel.orderModel.date = datePicker.date
    }

    @IBAction func handelTapGesture(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func clickedCreate(_ sender: UIButton) {
        viewModel.create { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    deinit {
        viewModel.clear()
    }
}

extension OrderFormViewController: UITextFieldDelegate, PriceTextFielddDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField != dateTextField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case nameTextField:
            viewModel.orderModel.name = textField.text
        case priceTextField:
            viewModel.orderModel.price = Double(textField.text ?? "")
        case locationTextField:
            viewModel.orderModel.location = textField.text
        default:
            break
        }
    }
}

extension OrderFormViewController: UITextViewDelegate {
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        viewModel.orderModel.info = textView.text
    }
}

extension OrderFormViewController: FSPagerViewDataSource, FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return viewModel.orderModel.photos.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        
        let data = viewModel.orderModel.photos[index]
        cell.imageView?.image = UIImage(data: data)
        return cell
    }
        
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        pageControl.currentPage = pagerView.currentIndex
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        choosePhoto()
    }
    
    func pagerView(_ pagerView: FSPagerView, shouldSelectItemAt index: Int) -> Bool {
        return true
    }
}


extension OrderFormViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func requestCameraAccess() {
        let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.openCamera()
                }
            }
        case .authorized:
            openCamera()
        case .denied, .restricted:
            showSettingsAlert()
        @unknown default:
            break
        }
    }
    
    private func requestPhotoLibraryAccess() {
        let photoStatus = PHPhotoLibrary.authorizationStatus()
        switch photoStatus {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                guard let self = self else { return }
                if status == .authorized {
                    self.openPhotoLibrary()
                }
            }
        case .authorized:
            openPhotoLibrary()
        case .denied, .restricted:
            showSettingsAlert()
        case .limited:
            break
        @unknown default:
            break
        }
    }
    
    private func openCamera() {
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    private func openPhotoLibrary() {
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    private func showSettingsAlert() {
        let alert = UIAlertController(title: "Access Needed", message: "Please allow access in Settings", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var image: UIImage?
        if let editedImage = info[.editedImage] as? UIImage {
            image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            image = originalImage
        }
        if let imageData = image?.jpegData(compressionQuality: 1.0) {
            let data = imageData as Data
            viewModel.addImage(data: data)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension OrderFormViewController {
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(OrderFormViewController.keyboardNotification(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                scrollView.contentInset = .zero
            } else {
                let height: CGFloat = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)!.size.height
                scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
            }
            
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
}

extension OrderFormViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !(view.hitTest(touch.location(in: view), with: nil)?.isDescendant(of: pagerView) == true)
    }
}

//
//  DocumentsController.swift
//  SoloDriver
//
//  Created by HaoBoji on 21/09/2016.
//  Copyright © 2016 HaoBoji. All rights reserved.
//

import UIKit

class DocumentsController: UITableViewController {
    
    override func viewDidLoad() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(close))
    }
    
    func close(_: AnyObject?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var urlString: String?
        switch indexPath.section {
        case 0:
            urlString = "http://www.worksafe.vic.gov.au/__data/assets/pdf_file/0018/9504/Safely-Transporting-Dangerous-Goods.compressed.pdf"
            break
        case 1:
            urlString = "http://www.worksafe.vic.gov.au/__data/assets/pdf_file/0008/14768/transport_routes.pdf"
            break
        case 2:
            urlString = "http://www.worksafe.vic.gov.au/__data/assets/pdf_file/0005/112937/TEBARS.pdf"
            break
        case 3:
            urlString = "http://www.worksafe.vic.gov.au/__data/assets/pdf_file/0012/10353/prevention_falls_trucks.pdf"
            break
        case 4:
            urlString = "http://www.worksafe.vic.gov.au/__data/assets/pdf_file/0011/10352/03275_LR_Guidance_Note_Web.pdf"
            break
        case 5:
            urlString = "http://www.worksafe.vic.gov.au/__data/assets/pdf_file/0017/10349/HSS0137_-_Unloading_flat-bed_truck_trailers_-_delivery_sites.pdf"
            break
        default:
            break
        }
        if (urlString != nil) {
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            controller.urlString = urlString!
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }

}

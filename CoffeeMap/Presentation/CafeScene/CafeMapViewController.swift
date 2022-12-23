//
//  CafeDetailViewController.swift
//  CoffeeMap
//
//  Created by wyn on 2022/9/25.
//

import UIKit
import MapKit

final class CafeMapViewController: UIViewController, Alertable {

    enum Contents {
        static let visibleEdgeInsets: CGFloat = 100
        static let renderLineWidth: CGFloat = 3.0
    }
    enum CafeMapViewString: LocallizedStringType {
        case routeError
    }
    @IBOutlet weak private var mapView: MKMapView!
    private let viewModel: CafeDetailViewModel

    init(_ viewModel: CafeDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        setAnnotation()
    }

    private func setAnnotation() {
        let annotation = MKPointAnnotation()
        annotation.title = viewModel.name
        if let coordinate = viewModel.coordinate {
            let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(floatLiteral: coordinate.latitude), longitude: CLLocationDegrees(floatLiteral: coordinate.longitude))
            annotation.coordinate = coordinate
            setRoute(MKPlacemark(coordinate: coordinate))
        } else {
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(viewModel.address, completionHandler: { placemarks, error in
                guard let placemarks = placemarks,
                      let placemark = placemarks.first,
                      let location = placemark.location else { return }
                if let error = error {
                    print(error)
                    return
                }
                annotation.coordinate = location.coordinate
                self.setRoute(MKPlacemark(placemark: placemark))
            })
        }
        mapView.showAnnotations([annotation], animated: true)
    }
    
    private func setRoute(_ placemark: MKPlacemark) {
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem.forCurrentLocation()
        directionRequest.destination = MKMapItem(placemark: placemark)
        directionRequest.transportType = MKDirectionsTransportType.walking

        let directions = MKDirections(request: directionRequest)
        directions.calculate { (routeResponse, routeError) -> Void in
            guard let routeResponse = routeResponse else {
                if routeError != nil {
                    self.showAlert(message: CafeDetailViewString.routeError.text)
                }
                return
            }
            guard let route = routeResponse.routes.first else { return }
            self.mapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
        }
    }
    
}

extension CafeMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = Contents.renderLineWidth
        
        // show the whole route
        let visibleMapRect = mapView.mapRectThatFits(renderer.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: Contents.visibleEdgeInsets, left: Contents.visibleEdgeInsets, bottom: Contents.visibleEdgeInsets, right: Contents.visibleEdgeInsets))
        mapView.setRegion(MKCoordinateRegion(visibleMapRect), animated: true)
        
        return renderer
    }
}

//
//  TrackingService.swift
//  SwiftPost
//
//  Created by Christian John on 2021-05-03.
//

import CoreLocation

enum DeliveryState: String, CaseIterable, Identifiable {
    case preTransit = "pre_transit"
    case inTransit = "in_transit"
    case outForDelivery = "out_for_delivery"
    case delivered = "delivered"
    
    var id: String { self.rawValue }
}

enum DeliveryService: String, CaseIterable, Identifiable {
    case AmazonMws = "AmazonMws"
    case APC = "APC"
    case Asendia = "Asendia"
    case AustraliaPost = "Australia Post"
    case AxlehireV3 = "AxlehireV3"
    case Bond = "Bond"
    case BorderGuru = "BorderGuru"
    case Cainiao = "Cainiao"
    case CanadaPost = "Canada Post"
    case Canpar = "Canpar"
    case ColumbusLastMile = "CDL Last Mile Solutions"
    case Chronopost = "Chronopost"
    case ColisPrive = "Colis Privé"
    case Colissimo = "Colissimo"
    case CourierExpress = "Courier Express"
    case CouriersPlease = "CouriersPlease"
    case DaiPost = "Dai Post"
    case DeutschePost = "Deutsche Post"
    case DeutschePostUK = "Deutsche Post UK"
    case DHLEcommerceAsia = "DHL eCommerce Asia"
    case DhlEcs = "DHL eCommerce Solutions"
    case DHLExpress = "DHL Express"
    case DHLFreight = "DHL Freight"
    case DHLGermany = "DHL Germany"
    case DPD = "DPD"
    case DPDUK = "DPD UK"
    case ChinaEMS = "EMS"
    case Estafeta = "Estafeta"
    case Fastway = "Fastway"
    case FedEx = "FedEx"
    case FedExCrossBorder = "FedEx Cross Border"
    case FedExMailview = "FedEx Mailview"
    case FedExSameDayCity = "FedEx SameDay City"
    case FedexSmartPost = "FedEx SmartPost"
    case FirstMile = "FirstMile"
    case Globegistics = "Globegistics"
    case GSO = "GSO"
    case Hermes = "Hermes"
    case HongKongPost = "Hong Kong Post"
    case InterlinkExpress = "Interlink Express"
    case JancoFreight = "Janco Freight"
    case JPPost = "JP Post"
    case KuronekoYamato = "Kuroneko Yamato"
    case LaPoste = "La Poste"
    case LaserShipV2 = "LaserShip"
    case Liefery = "Liefery"
    case LoomisExpress = "Loomis Express"
    case Newgistics = "Newgistics"
    case LSO = "LSO"
    case OnTrac = "OnTrac"
    case OsmWorldwide = "Osm Worldwide"
    case Parcelforce = "Parcelforce"
    case Passport = "Passport"
    case PcfFinalMile = "PCF Final Mile"
    case Pilot = "Pilot"
    case PostNL = "PostNL"
    case PostNord = "PostNord"
    case Purolator = "Purolator"
    case RoyalMail = "Royal Mail"
    case RRDonnelley = "RR Donnelley"
    case Seko = "Seko"
    case OmniParcel = "SEKO OmniParcel"
    case SingaporePost = "Singapore Post"
    case SpeeDee = "Spee-Dee"
    case StarTrack = "StarTrack"
    case Toll = "Toll"
    case TForce = "TForce"
    case UDS = "UDS"
    case Ukrposhta = "Ukrposhta"
    case UPS = "UPS"
    case UPSIparcel = "UPS i-parcel"
    case UPSMailInnovations = "UPS Mail Innovations"
    case USPS = "USPS"
    case Veho = "Veho"
    case Yanwen = "Yanwen"
    
    var id: String { self.rawValue }
    var name: String {
        get { return String(describing: self) }
    }
}

struct Tracker: Codable, Identifiable {
    var id: String
    var carrier: String?
    var object: String?
    var mode: String?
    var tracking_code: String?
    var status: String?
    var created_at: String?
    var updated_at: String?
    var signed_by: String?
    var weight: Double?
    var est_delivery_date: String?
    var finalized: Bool?
    var is_return: Bool?
    var status_detail: String?
    var shipment_id: String?
    var public_url: String?
    var tracking_details: [Tracking_Details]?
    var carrier_detail: Carrier_Detail?
    var fees: [Fees]?

    init() {
        id = ""
        carrier = ""
        object = ""
        mode = ""
        tracking_code = ""
        status = ""
        created_at = ""
        updated_at = ""
        signed_by = ""
        weight = 0.0
        est_delivery_date = ""
        finalized = false
        is_return = false
        status_detail = ""
        shipment_id = ""
        public_url = ""
        tracking_details = []
        carrier_detail = Carrier_Detail()
        fees = []
    }
}

struct Tracking_Details: Codable {
    var carrier_code: String?
    var datetime: String?
    var description: String?
    var message: String?
    var object: String?
    var source: String?
    var status: String?
    var status_detail: String?
    var tracking_location: Tracking_Location?
    
    init() {
        carrier_code = ""
        datetime = ""
        description = ""
        message = ""
        object = ""
        source = ""
        status = ""
        status_detail = ""
        tracking_location = Tracking_Location()
    }
}

struct Tracking_Location: Codable {
    var city: String?
    var country: String?
    var object: String?
    var state: String?
    var zip: String?
    
    init() {
        city = ""
        country = ""
        object = ""
        state = ""
        zip = ""
    }
}

struct Carrier_Detail: Codable {
    var object: String?
    var service: String?
    var container_type: String?
    var est_delivery_date_local: String?
    var est_delivery_time_local: String?
    var origin_location: String?
    var origin_tracking_location: Tracking_Location?
    var destination_location: String?
    var destination_tracking_location: Tracking_Location?
    var guaranteed_delivery_date: String?
    var alternate_identifier: String?
    var initial_delivery_attempt: String?
    
    init() {
        object = ""
        service = ""
        container_type = ""
        est_delivery_date_local = ""
        est_delivery_time_local = ""
        origin_location = ""
        origin_tracking_location = Tracking_Location()
        destination_location = ""
        destination_tracking_location = Tracking_Location()
        guaranteed_delivery_date = ""
        alternate_identifier = ""
        initial_delivery_attempt = ""
    }
}

struct Fees: Codable {
    var object: String?
    var type: String?
    var amount: String?
    var charged: Bool?
    var refunded: Bool?
    
    init() {
        object = ""
        type = ""
        amount = ""
        charged = false
        refunded = false
    }
}

extension Tracking_Details: Identifiable {
    var id: UUID? { return UUID() }
}

struct FinalTrackingDetail: Identifiable, Equatable {
    static func == (lhs: FinalTrackingDetail, rhs: FinalTrackingDetail) -> Bool {
        return lhs == rhs
        
    }

    static func != (lhs: FinalTrackingDetail, rhs: FinalTrackingDetail) -> Bool {
        return lhs != rhs
    }

    var trackingDetail: Tracking_Details
    var localDateTime: Date
    var id: UUID
    
    init(detail: Tracking_Details, date: Date) {
        self.trackingDetail = detail
        self.localDateTime = date
        self.id = UUID()
    }
}

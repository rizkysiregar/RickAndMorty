//
//  RMCharacterInfoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Rizky Siregar on 24/03/24.
//

import UIKit

final class RMCharacterInfoCollectionViewCellViewModel {
    
    private let type: `Type`
    private let value: String
    
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
        formatter.timeZone = .current
        return formatter
    }()
    
    static let shortDataFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.timeZone = .current
        return formatter
    }()
    
    public var title: String {
        self.type.displayTitle
    }
    
///    self: Refers to the current instance within instance methods or properties. (lowercase)
///    Self: Refers to the type of the current instance, especially within protocols to refer to the conforming type
    
    public var displayValue: String {
        if value.isEmpty { return "None" }
        
        /// if the parsing dateFormatter is successful and type is created
        if let date = Self.dateFormatter.date(from: value),type == .created {
            return Self.shortDataFormatter.string(from: date)
        }
        
        return value
    }
    
    public var iconImage: UIImage? {
        return type.iconImage
    }
    
    public var tintColor: UIColor {
        return type.tintColor
    }
    
    enum `Type` {
        case status
        case gender
        case type
        case species
        case origin
        case created
        case location
        case episodeCount
        
        var tintColor: UIColor {
            switch self {
            case .status:
                return .systemRed
            case .gender:
                return .systemGreen
            case .type:
                return .systemYellow
            case .species:
                return .systemBlue
            case .origin:
                return .systemCyan
            case .created:
                return .systemMint
            case .location:
                return .systemGray
            case .episodeCount:
                return .systemPink
                
            }
        }
        
        var iconImage: UIImage? {
            switch self {
            case .status:
                return UIImage(systemName: "bell")
            case .gender:
                return UIImage(systemName: "bell")
            case .type:
                return UIImage(systemName: "bell")
            case .species:
                return UIImage(systemName: "bell")
            case .origin:
                return UIImage(systemName: "bell")
            case .created:
                return UIImage(systemName: "bell")
            case .location:
                return UIImage(systemName: "bell")
            case .episodeCount:
                return UIImage(systemName: "bell")
                
            }
        }
        
        var displayTitle: String {
            switch self {
            case .status:
                return "Status"
            case .gender:
                return "Gender"
            case .type:
                return "Type"
            case .species:
                return "Species"
            case .origin:
                return "Origin"
            case .created:
                return "Created"
            case .location:
                return "Location"
            case .episodeCount:
                return "Total Eps"
                
            }
        }
    }
    
    init (
        type: `Type`,
        value: String
    ) {
        self.value = value
        self.type = type
    }
}

//
//  Support.swift
//  PianoTranscription
//
//  Created by Vaida on 7/9/22.
//

import Foundation
import Support

@dynamicMemberLookup struct ItemContainer: Identifiable {
    
    var item: FinderItem
    var isAudio: Bool
    
    var id: FinderItem.ID {
        item.id
    }
    
    /// A read and write subscript to a keyPath of `Source`.
    ///
    /// - Note: The type needs to conform to `@dynamicMemberLookup`.
    public subscript<Subject>(dynamicMember keyPath: WritableKeyPath<FinderItem, Subject>) -> Subject {
        get { item[keyPath: keyPath] }
        set { item[keyPath: keyPath] = newValue }
    }
    
    /// A read subscript to a keyPath of `Source`.
    ///
    /// - Note: The type needs to conform to `@dynamicMemberLookup`.
    public subscript<Subject>(dynamicMember keyPath: KeyPath<FinderItem, Subject>) -> Subject {
        item[keyPath: keyPath]
    }
    
}

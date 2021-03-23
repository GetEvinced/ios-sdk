//
//  SearchBar.swift
//  EvincedSDKiOS
//
//  Copyright © Evinced, Inc. All rights reserved.
//

import Foundation

class SearchBar: View {
    init(searchBar: UISearchBar)  {
        super.init(view: searchBar)
        
        ancestorType = .uiSearchBar
    }
}

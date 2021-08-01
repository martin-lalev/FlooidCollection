Pod::Spec.new do |s|

s.name         = "FlooidCollection"
s.version      = "1.0.7"
s.summary      = "UICollectionView framework for declerative data source creation."
s.description  = "UICollectionView framework for declerative data source creation."
s.homepage     = "http://github.com/martin-lalev/FlooidCollection"
s.license      = "MIT"
s.author       = "Martin Lalev"
s.platform     = :ios, "11.0"
s.source       = { :git => "https://github.com/martin-lalev/FlooidCollection.git", :tag => s.version }
s.source_files  = "FlooidCollection", "FlooidCollection/**/*.{swift}"
s.swift_version = '5.0'

end

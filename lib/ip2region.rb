# frozen_string_literal: true

require_relative "ip2region/version"
require_relative "ip2region/xdb_searcher"

module Ip2region
  class Error < StandardError; end
  # Your code goes here...

  def self.ip_2_region_path=(path)
    @@ip_2_region_path = path
  end

  def self.search(ip)

    if @@ip_2_region_path.nil?
      throw "需要先运行 Ip2region.ip_2_region_path = XDB_PATH"
    end

    XdbSearcher.xdb_path = @@ip_2_region_path

    searcher = XdbSearcher.instance
    searcher.search(ip)
  end
end

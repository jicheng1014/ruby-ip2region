module Ip2region
  class XdbSearcher
    # xdb默认参数
    HeaderInfoLength = 256
    VectorIndexRows = 256
    VectorIndexCols = 256
    VectorIndexSize = 8
    SegmentIndexSize = 14

    def search(ip)
      if ip.is_a?(String)
      ip = ip.to_i unless ip =~ /\A\d+\z/
      return search_by_ip_long(ip)
      else
      return search_by_ip_long(ip)
      end
      end
  end
end
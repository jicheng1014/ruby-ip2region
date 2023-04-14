require 'ipaddr'
require 'singleton'


module Ip2region
  class XdbSearcher
    include ::Singleton

    # xdb默认参数
    HeaderInfoLength = 256
    VectorIndexRows = 256
    VectorIndexCols = 256
    VectorIndexSize = 8
    SegmentIndexSize = 14

    attr_accessor :vector_index, :content_buff, :f

    def self.xdb_path= (path)
      @@xdb_path = path
    end

    def self.xdb_path
      @@xdb_path
    end

    def initialize()
      init_database(@@xdb_path, nil, nil)
    end

    def init_database(dbfile, vi, cb)
      begin
        if cb
          @f = nil
          @vector_index = nil
          @content_buff= cb
        else
          @f = File.open(dbfile, "rb")
          @vector_index = vi
        end
      rescue IOError => e
        puts "[Error]: #{e}"
        exit
      end
    end

    def search(ip)
      if ip.is_a?(String)

        ip = ip_to_long(ip).to_i unless ip =~ /\A\d+\z/
        return search_by_ip_long(ip)
      else
        return search_by_ip_long(ip)
      end
    end

    def ip_to_long(ip)
      IPAddr.new(ip).to_i
    end

    def get_long(b, offset)
      return 0 if b[offset, 4].length != 4

      b[offset, 4].unpack("I")[0]
    end

    def get_int2(b, offset)
      (b[offset].ord & 0x000000FF) | (b[offset + 1].ord & 0x0000FF00)
    end

    def read_buffer(offset, length)
      buffer = nil
      if self.content_buff != nil
        buffer = self.content_buff[offset, length]
      else
        f.seek(offset)
        buffer = f.read(length)
      end
    end

    def search_by_ip_long(ip)
      #locate the segment index block based on the vector index
      s_ptr = e_ptr = 0
      il0 = (ip >> 24) & 0xFF
      il1 = (ip >> 16) & 0xFF
      idx = il0 * VectorIndexCols * VectorIndexSize + il1 * VectorIndexSize


      if self.vector_index != nil
        s_ptr = self.get_long(self.vector_index, idx)
        e_ptr = self.get_long(self.vector_index, idx + 4)
      elsif self.content_buff != nil
        s_ptr = self.get_long(self.content_buff,HeaderInfoLength +  idx)
        e_ptr = self.get_long(self.content_buff, HeaderInfoLength + idx + 4)
      else
        f.seek(HeaderInfoLength + idx)
        buffer_ptr = f.read(8)
        s_ptr = self.get_long(buffer_ptr, 0)
        e_ptr = self.get_long(buffer_ptr, 4)
      end

      data_len = data_ptr = -1

      l = 0
      h = (e_ptr - s_ptr) / SegmentIndexSize

      while l <= h
        m = (l + h) >> 1
        p = s_ptr + m * SegmentIndexSize

        # read the segment index
        buffer_sip = self.read_buffer(p, SegmentIndexSize)
        sip = self.get_long(buffer_sip, 0)
        if ip < sip
          h = m-1
        else
          eip = self.get_long(buffer_sip, 4)
          if ip > eip
            l = m + 1
          else
            data_len = self.get_int2(buffer_sip, 8)
            data_ptr = self.get_long(buffer_sip, 10)
            break
          end
        end
      end

      if data_ptr == -1
        return nil
      end

      buffer_string = self.read_buffer(data_ptr, data_len)
      # to utf8
      buffer_string.force_encoding("UTF-8")

    end
  end

end
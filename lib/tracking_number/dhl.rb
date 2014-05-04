module TrackingNumber
  class DHL < Base
    SEARCH_PATTERN = /(\b([0-9]\s*){11,11}\b)/
    VERIFY_PATTERN = /^([0-9]{10,10})([0-9])$/
    def carrier
      :dhl
    end

    # commas for multiples
    def self.uri(*args)
      _uri = URI('http://webtrack.dhlglobalmail.com/')
      _uri.query = URI.encode_www_form({
        mobile: '',
        locale: 'en',
        :trackingnumber => args.map{|a| a.tracking_number }.join(",")
      })
      return _uri
    end

    def uri
      self.class.uri(self)
    end

    def matches
      self.tracking_number.scan(VERIFY_PATTERN).flatten
    end

    def valid_checksum?
      # standard mod 7 check
      sequence, check_digit = matches
      return true if sequence.to_i % 7 == check_digit.to_i
    end
  end
end
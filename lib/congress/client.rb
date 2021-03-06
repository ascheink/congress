require 'congress/connection'
require 'congress/request'
require 'geocoder'

module Congress
  class Client
    include Connection
    include Request
    attr_reader :key

    def initialize(key)
      fail ArgumentError, 'API key required' if key.nil?
      @key = key
    end

    # Current legislators' names, IDs, biography, and social media.
    #
    # @return [Hashie::Rash]
    # @example
    #   Congress.key = YOUR_SUNLIGHT_API_KEY
    #   Congress.legislators
    def legislators(options = {})
      get('/legislators', options)
    end

    # Find representatives and senators for a latitude/longitude, zip, or address.
    #
    # @return [Hashie::Rash]
    # @example
    #   Congress.key = YOUR_SUNLIGHT_API_KEY
    #   Congress.legislators_locate(94107)
    #   Congress.legislators_locate(37.775, -122.418)
    #   Congress.legislators_locate('2169 Mission Street, San Francisco, CA 94110')
    def legislators_locate(*args)
      get('/legislators/locate', extract_location(args))
    end

    # Find congressional districts for a latitude/longitude, zip, or address.
    #
    # @return [Hashie::Rash]
    # @example
    #   Congress.key = YOUR_SUNLIGHT_API_KEY
    #   Congress.districts_locate(94107)
    #   Congress.districts_locate(37.775, -122.418)
    #   Congress.districts_locate('2169 Mission Street, San Francisco, CA 94110')
    def districts_locate(*args)
      get('/districts/locate', extract_location(args))
    end

    # Current committees, subcommittees, and their membership.
    #
    # @return [Hashie::Rash]
    # @example
    #   Congress.key = YOUR_SUNLIGHT_API_KEY
    #   Congress.committees
    def committees(options = {})
      get('/committees', options)
    end

    # Legislation in the House and Senate, back to 2009. Updated daily.
    #
    # @return [Hashie::Rash]
    # @example
    #   Congress.key = YOUR_SUNLIGHT_API_KEY
    #   Congress.bills
    def bills(options = {})
      get('/bills', options)
    end

    # ull text search over legislation.
    #
    # @return [Hashie::Rash]
    # @example
    #   Congress.key = YOUR_SUNLIGHT_API_KEY
    #   Congress.bills_search
    def bills_search(options = {})
      get('/bills/search', options)
    end

    # Roll call votes in Congress, back to 2009. Updated within minutes of votes.
    #
    # @return [Hashie::Rash]
    # @example
    #   Congress.key = YOUR_SUNLIGHT_API_KEY
    #   Congress.votes
    def votes(options = {})
      get('/votes', options)
    end

    # To-the-minute updates from the floor of the House and Senate.
    #
    # @return [Hashie::Rash]
    # @example
    #   Congress.key = YOUR_SUNLIGHT_API_KEY
    #   Congress.floor_updates
    def floor_updates(options = {})
      get('/floor_updates', options)
    end

    # Committee hearings in Congress. Updated as hearings are announced.
    #
    # @return [Hashie::Rash]
    # @example
    #   Congress.key = YOUR_SUNLIGHT_API_KEY
    #   Congress.hearings
    def hearings(options = {})
      get('/hearings', options)
    end

    # Bills scheduled for debate in the future, as announced by party leadership.
    #
    # @return [Hashie::Rash]
    # @example
    #   Congress.key = YOUR_SUNLIGHT_API_KEY
    #   Congress.upcoming_bills
    def upcoming_bills(options = {})
      get('/upcoming_bills', options)
    end

  private

    def extract_location(args)
      options = args.last.is_a?(::Hash) ? args.pop : {}
      case [args.size, args.first.class]
      when [1, Fixnum]
        options.merge(:zip => args.pop)
      when [1, String]
        placemark = Geocoder.search(args.pop).first
        options.merge(:longitude => placemark.longitude, :latitude => placemark.latitude)
      when [2, Float]
        options.merge(:longitude => args.pop, :latitude => args.pop)
      else
        fail ArgumentError, 'Must pass a latitude/longitude, zip or address'
      end
    end
  end
end

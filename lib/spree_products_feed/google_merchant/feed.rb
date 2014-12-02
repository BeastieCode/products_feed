module SpreeProductsFeed::GoogleMerchant
  class Feed

    def initialize(items, options={})
      @items = items

      @options = {
        currency: Spree::Config[:currency],
        country: Spree::Country.find(Spree::Config[:default_country_id]),
        title: 'Google Merchant feed',
        description: 'Google Merchant feed generated by Spree',
        link: Spree::Store.default.url,
        google_category: 'Software > Digital Goods & Currency',
        target: STDOUT
      }.merge(options)
    end

    def generate &block
      xml.instruct! :xml, version: '1.0'

      xml.rss(version: '2.0', 'xmlns:g' => 'http://base.google.com/ns/1.0') do
        xml.channel do
          xml.title @options[:title]
          xml.description @options[:description]
          xml.link @options[:link]

          @items.each do |item|
            xml.item do
              yield self, item
              # self.instance_eval(&block)
            end
          end
        end
      end
    end

    # TODO: keep track of missing required fields for feed
    # validate their presence, then raise an exception
    def field(name, value)
      xml.tag! name, value
    end

    private
    def xml
      @xml ||= Builder::XmlMarkup.new target: @options[:target]
    end
  end
end

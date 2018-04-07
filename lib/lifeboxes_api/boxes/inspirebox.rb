require "lifeboxes_api/apis/mahalojournal/api"
require "lifeboxes_api/linebreaker"

module LifeboxesApi
  class Inspirebox
    def to_json
      {
        text: formatted_text,
        date: formatted_date
      }.to_json
    end

    private

      def formatted_text
        Linebreaker.new(entry.text).run
      end

      def formatted_date
        entry.date.strftime("%Y.%m.%d")
      end

      def entry
        @_entry ||= Mahalojournal::Api.new.random
      end
  end
end

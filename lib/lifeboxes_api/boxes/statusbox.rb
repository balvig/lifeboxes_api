require "lifeboxes_api/apis/github"
require "lifeboxes_api/apis/garbage"
require "lifeboxes_api/apis/weather"

module LifeboxesApi
  class Statusbox < Lifebox
    BORDER = "----------"

    def to_h
      {
        screens: screens
      }
    end

    private

      def screens
        [
          temperature_screen,
          weather_codes_screen,
          recycle_screen,
          github_screen
        ]
      end

      def temperature_screen
        <<~TEXT
        #{day.upcase}
        #{BORDER}
        Now: #{weather.current.temperature}C
        Low: #{weather.lowest_temperature}C
        TEXT
      end

      def weather_codes_screen
        <<~TEXT
        WEATHER
        #{BORDER}
        #{weather_codes}
        TEXT
      end

      def recycle_screen
        <<~TEXT
        RECYCLING
        #{BORDER}
        #{garbage.current || "No garbage"}
        TEXT
      end

      def github_screen
        <<~TEXT
        GITHUB
        #{BORDER}
        #{github.statuses.map(&:to_s).join("\n")}
        TEXT
      end

      def day
        Date.today.strftime("%A")
      end

      def forecasts
        weather.forecasts
      end

      def weather_codes
        forecasts.map do |report|
          "#{report.time.strftime("%k:%M")} #{report.code}"
        end.join("\n")
      end

      def weather
        @_weather ||= Weather.new
      end

      def garbage
        @_garbage ||= Garbage.new
      end

      def github
        @_github ||= Github.new
      end
  end
end

# frozen_string_literal: true

# Initialize constants for service urls

service_urls_file = Rails.root.join('config', 'services.yml')
service_urls = YAML.safe_load(ERB.new(File.read(service_urls_file)).result, [], [], true)
               .with_indifferent_access[Rails.env]

# Configure faraday requests
COVID_API_URL = service_urls[:covid_api_url]

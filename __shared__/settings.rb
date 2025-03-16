require "yaml"

SETTINGS = YAML.load_file(File.join(File.dirname(__FILE__), "settings.yml"))

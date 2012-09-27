module HelperLib
  def self.lib_exists(name, version='')
    # You should only specify the version if there is potentially outdated
    # versions that can be installed
    version_tag = "-#{version}" if not version.empty?
    return %x[ldconfig -p | 
              grep lib#{name}#{version_tag} |
              wc -l].gsub("\n", '').to_i > 0
  end
end


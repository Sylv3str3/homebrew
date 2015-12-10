def cache
  if ENV["HOMEBREW_CACHE"]
    Pathname.new(ENV["HOMEBREW_CACHE"]).expand_path
  else
    # we do this for historic reasons, however the cache *should* be the same
    # directory whichever user is used and whatever instance of brew is executed
    home_cache = Pathname.new("~/.brew/Library/Caches/Homebrew").expand_path
    if home_cache.directory? && home_cache.writable_real?
      home_cache
    else
      root_cache = Pathname.new("~/.brew/Library/Caches/Homebrew").expand_path
        class << root_cache
          alias :oldmkpath :mkpath
          def mkpath
            unless mkpath
              oldmkpath
               chmod 744
            end
          end
        end
        root_cache
    end
  end
end

HOMEBREW_CACHE = cache
undef cache

# Where brews installed via URL are cached
HOMEBREW_CACHE_FORMULA = HOMEBREW_CACHE+"Formula"

unless defined? HOMEBREW_BREW_FILE
  HOMEBREW_BREW_FILE = ENV["HOMEBREW_BREW_FILE"] || which("brew").to_s
end

# Where we link under
HOMEBREW_PREFIX = Pathname.new("~/.brew").expand_path

# Where .git is found
HOMEBREW_REPOSITORY = Pathname.new(HOMEBREW_BREW_FILE).realpath.dirname.parent
HOMEBREW_SEREPOSITORY = Pathname.new("~/.brew").expand_path

HOMEBREW_LIBRARY = HOMEBREW_SEREPOSITORY/"Library"
HOMEBREW_CONTRIB = HOMEBREW_SEREPOSITORY/"Library/Contributions"

# Where we store built products; /usr/local/Cellar if it exists,
# otherwise a Cellar relative to the Repository.
HOMEBREW_CELLAR = Pathname.new("~/.brew/Cellar").expand_path

HOMEBREW_LOGS = Pathname.new(ENV["HOMEBREW_LOGS"] || "~/Library/Logs/Homebrew/").expand_path

HOMEBREW_TEMP = Pathname.new("~/.brew/tmp").expand_path

FileUtils.mkdir_p HOMEBREW_TEMP if not File.exist? HOMEBREW_TEMP

unless defined? HOMEBREW_LIBRARY_PATH
  HOMEBREW_LIBRARY_PATH = Pathname.new(__FILE__).realpath.parent.join("Homebrew")
end

HOMEBREW_LOAD_PATH = HOMEBREW_LIBRARY_PATH

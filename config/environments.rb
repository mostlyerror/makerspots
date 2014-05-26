#The environment variable DATABASE_URL should be in the following format:
# => postgres://{user}:{password}@{host}:{port}/path
configure :production, :development do
  db = URI.parse(ENV['postgres://david:commerce@localhost/makerspotsdb'] || 'postgres://localhost/makerspotsdb')
end

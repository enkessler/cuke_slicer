SimpleCov.start do
  add_filter '/spec/'
  add_filter '/features/'

  #Ignore results that are older than 10 minutes
  merge_timeout 600
end

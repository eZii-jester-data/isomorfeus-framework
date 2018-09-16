class String
  def event_camelize
    `return #{self}.replace(/(^|_)([^_]+)/g, function(match, pre, word, index) {
      return word.substr(0,1).toUpperCase()+word.substr(1);
    })`
  end
end
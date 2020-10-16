module CustomExceptions

  class Error < StandardError; end
  class NotAuthorizedError < Error; end
  
end

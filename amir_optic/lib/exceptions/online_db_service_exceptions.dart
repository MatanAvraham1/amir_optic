class OnlineDBServiceException implements Exception {}

class ClientAlreadyExistsException extends OnlineDBServiceException {
  String message = "The client does already exists in our systems!";
}

class ClientDoesNotExistsException extends OnlineDBServiceException {
  String message = "The client does not exists in our systems!";
}

class ClientIdDoesAlreadyInUse extends OnlineDBServiceException {
  String message = "This id does already in use!";
}

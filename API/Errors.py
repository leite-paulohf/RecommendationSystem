from flask_restful import abort
from requests import api

class BaseError(Exception):
    def __init__(self, code=400, message='', status='', field=None):
        Exception.__init__(self)
        self.code = code
        self.message = message
        self.status = status
        self.field = field

    def to_dict(self):
        return {'code': self.code,
                'message': self.message,
                'status': self.status,
                'field': self.field, }

class NotFoundError(BaseError):
    def __init__(self, message='Not found'):
        BaseError.__init__(self)
        self.code = 404
        self.message = message
        self.status = 'NOT_FOUND'

class NotAuthorizedError(BaseError):
    def __init__(self, message='Unauthorized'):
        BaseError.__init__(self)
        self.code = 401
        self.message = message
        self.status = 'NOT_AUTHORIZED'

class ValidationError(BaseError):
    def __init__(self, field, message='Invalid field'):
        BaseError.__init__(self)
        self.code = 400
        self.message = message
        self.status = 'INVALID_FIELD'
        self.field = field

class ServerError(BaseError):
    def __init__(self, message='Internal server error'):
        BaseError.__init__(self)
        self.code = 500
        self.message = message
        self.status = 'SERVER_ERROR'

@api.errorhandler(NotFoundError)
@api.errorhandler(NotAuthorizedError)
@api.errorhandler(ValidationError)
def handle_error(error):
    return error.to_dict(), getattr(error, 'code')

@api.errorhandler
def default_error_handler(error):
    error = ServerError()
    return error.to_dict(), getattr(error, 'code', 500)
# meraki_request.py
import requests
import os
import urllib.parse
from robot.api import logger
import time, random, json

# Code ported from https://github.com/meraki/dashboard-api-python/releases/tag/2.0.2
# Python SDK release 2.0.2

# Local constants
API_BASE = "https://api.meraki.com/api/v1"
MAXIMUM_RETRIES = 2
API_KEY_ENVIRONMENT_VARIABLE = 'MERAKI_API_KEY'
NGINX_429_RETRY_WAIT_TIME = 10
ACTION_BATCH_RETRY_WAIT_TIME = 10
NETWORK_DELETE_RETRY_WAIT_TIME = 240
RETRY_4XX_ERROR = False
RETRY_4XX_ERROR_WAIT_TIME = 1

# To catch exceptions while making API calls (ported from Meraki Python SDK)
class APIError(Exception):
    def __init__(self, response):
        self.response = response
        self.status = (
            self.response.status_code
            if self.response is not None and self.response.status_code
            else None
        )
        self.reason = (
            self.response.reason
            if self.response is not None and self.response.reason
            else None
        )
        try:
            self.message = (
                self.response.json()
                if self.response is not None and self.response.json()
                else None
            )
        except ValueError:
            self.message = self.response.content[:100].decode("UTF-8").strip()
            if (
                type(self.message) == str
                and self.status == 404
                and self.reason == "Not Found"
            ):
                self.message += (
                    "please wait a minute if the key or org was just newly created."
                )
        super(APIError, self).__init__(
            f"{self.status} {self.reason}, {self.message}"
        )

    def __repr__(self):
        return f"{self.status} {self.reason}, {self.message}"

# API key error (ported from Meraki Python SDK)
class APIKeyError(Exception):
    def __init__(self):
        self.message = "Meraki API key needs to be defined"
        super(APIKeyError, self).__init__(self.message)

    def __repr__(self):
        return self.message

# Setup request session for reuse throughout the run
def request_session(api_key=None):
    # Check API key
    api_key = api_key or os.environ.get(API_KEY_ENVIRONMENT_VARIABLE)
    if not api_key:
        raise APIKeyError()
    session = requests.session()
    session.encoding = 'utf-8'
    session.headers = {
            'Authorization': 'Bearer ' + api_key,
            'Content-Type': 'application/json',
            'User-Agent': f'nac-robot/{requests.__version__}',
        }
    return session

# Request with API error handling (ported from Meraki Python SDK)
def request(req_session, method, url, **kwargs):
    base_url = API_BASE

    # Ensure proper base URL
    allowed_domains = ['meraki.com', 'meraki.ca', 'meraki.cn', 'meraki.in', 'gov-meraki.com']
    parsed_url = urllib.parse.urlparse(url)

    if any(domain in parsed_url.netloc for domain in allowed_domains):
        abs_url = url
    else:
        abs_url = base_url + url

    # Set maximum number of retries
    retries = MAXIMUM_RETRIES

    response = None
    while retries > 0:
        # Make the HTTP request to the API endpoint
        try:
            if response:
                response.close()
            logger.info(f'{method} {abs_url}')
            response = req_session.request(method, abs_url, allow_redirects=False,
                                                    **kwargs)
            reason = response.reason if response.reason else ''
            status = response.status_code
        except requests.exceptions.RequestException as e:
            logger.info(f'{method}, {abs_url} - {e}, retrying in 1 second')
            time.sleep(1)
            retries -= 1
            if retries == 0:
                if e.response:
                    raise APIError(e.response)
                else:
                    raise Exception(f'Request failed for {method} {abs_url} - {e}')
            else:
                continue

        # Handle 3XX redirects automatically
        if str(status)[0] == '3':
            abs_url = response.headers['Location']
            substring = 'meraki.com/api/v'
            if substring not in abs_url:
                substring = 'meraki.cn/api/v'
            base_url = abs_url[:abs_url.find(substring) + len(substring) + 1]

        # 2XX success
        elif response.ok:
            logger.info(f'{method}, {abs_url} - {status} {reason}')
            # For non-empty response to GET, ensure valid JSON
            try:
                if method == 'GET' and response.content.strip():
                    response.json()
                return response
            except json.decoder.JSONDecodeError as e:
                logger.info(f'{method}, {abs_url} - {e}, retrying in 1 second')
                time.sleep(1)
                retries -= 1
                if retries == 0:
                    raise APIError(response)
                else:
                    continue

        # Rate limit 429 errors
        elif status == 429:
            if 'Retry-After' in response.headers:
                wait = int(response.headers['Retry-After'])
            else:
                wait = random.randint(1, NGINX_429_RETRY_WAIT_TIME)
            logger.info(f'{method}, {abs_url} - {status} {reason}, retrying in {wait} seconds')
            time.sleep(wait)
            retries -= 1
            if retries == 0:
                raise APIError(response)

        # 5XX errors
        elif status >= 500:
            logger.info(f'{method}, {abs_url} - {status} {reason}, retrying in 1 second')
            time.sleep(1)
            retries -= 1
            if retries == 0:
                raise APIError(response)

        # 4XX errors
        else:
            try:
                message = response.json()
                message_is_dict = True
            except ValueError:
                message = response.content[:100]
                message_is_dict = False

            # Check for specific concurrency errors
            network_delete_concurrency_error_text = 'This may be due to concurrent requests to delete networks.'
            action_batch_concurrency_error = {'errors': [
                'Too many concurrently executing batches. Maximum is 5 confirmed but not yet executed batches.']
            }
            # Check specifically for network delete concurrency error
            if message_is_dict and 'errors' in message.keys() \
                    and network_delete_concurrency_error_text in message['errors'][0]:
                wait = random.randint(30, NETWORK_DELETE_RETRY_WAIT_TIME)
                logger.info(f'{method}, {abs_url} - {status} {reason}, retrying in {wait} seconds')
                time.sleep(wait)
                retries -= 1
                if retries == 0:
                    raise APIError(response)
            # Check specifically for action batch concurrency error
            elif message == action_batch_concurrency_error:
                wait = ACTION_BATCH_RETRY_WAIT_TIME
                logger.info(f'{method}, {abs_url} - {status} {reason}, retrying in {wait} seconds')
                time.sleep(wait)
                retries -= 1
                if retries == 0:
                    raise APIError(response)
            elif RETRY_4XX_ERROR:
                wait = random.randint(1, RETRY_4XX_ERROR_WAIT_TIME)
                logger.info(f'{method}, {abs_url} - {status} {reason}, retrying in {wait} seconds')
                time.sleep(wait)
                retries -= 1
                if retries == 0:
                    raise APIError(response)

            # All other client-side errors
            else:
                logger.info(f'{method}, {abs_url} - {status} {reason}, {message}')
                raise APIError(response)


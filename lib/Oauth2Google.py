# Prerequisite
# pip install google google_auth_oauthlib google-api-python-client
# credentials.json
import pickle
import os.path
from googleapiclient.discovery import build
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request

# If modifying these scopes, delete the file token.pickle.
SCOPES = ['https://www.googleapis.com/auth/spreadsheets','https://www.googleapis.com/auth/presentations']

LIB_PATH = os.path.dirname(os.path.abspath(__file__)) + '/'

def get_access_token():
    """Get access token from google
    
    Example:
    | ${accessToken} | Get Access Token | ${credentials_json_path} |
    
    """
    creds = None
    # The file token.pickle stores the user's access and refresh tokens, and is
    # created automatically when the authorization flow completes for the first
    # time.
    if os.path.exists(LIB_PATH+'token.pickle'):
        with open(LIB_PATH+'token.pickle', 'rb') as token:
            creds = pickle.load(token)
    # If there are no (valid) credentials available, let the user log in.
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(
                LIB_PATH+'credentials.json', SCOPES)
            creds = flow.run_local_server(port=0)
        # Save the credentials for the next run
        with open(LIB_PATH+'token.pickle', 'wb') as token:
            pickle.dump(creds, token)
    return creds.token

if __name__ == '__main__':
    print(get_access_token())
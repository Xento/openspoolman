from app import app
import os

if __name__ == '__main__':

    ADHOC_SSL = True

    if os.getenv('ADHOC_SSL', "").upper() == "FALSE" :
        ADHOC_SSL = False

    if ADHOC_SSL:
        app.run(debug=os.getenv('DEBUG', False), port=os.getenv('PORT', 8443), host=os.getenv('HOST', '0.0.0.0'), ssl_context='adhoc')
    else:
        app.run(debug=os.getenv('DEBUG', False), port=os.getenv('PORT', 8001), host=os.getenv('HOST', '0.0.0.0'))

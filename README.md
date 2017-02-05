# Flicker-popular-images


## Frameworks
'Reachability' is used to check the internet connection.
'SDWebImage' is used to download image asynchronous with cache support.


================
'WebServices' : contains the base url and the api key
'ErrorHandlingLayer': to handle the response and connection error
'HTTPClient' : send the request from the parameters and send the result back to the 'SearchManager'
'SearchManager' : build the parameters and send it to the 'HTTPClient' and create photos array from the json response

'CoreDataController' : responsible for Core Data initialization and removing all objects from core data.

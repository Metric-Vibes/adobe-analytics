___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Adobe Analytics",
  "brand": {
    "id": "brand_dummy",
    "displayName": ""
  },
  "description": "Send data to Adobe Analytics with just one click",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "trackingserver",
    "displayName": "Tracking Server",
    "simpleValueType": true,
    "help": "example.data.adobedc.net",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "reportsuite",
    "displayName": "Report Suite ID",
    "simpleValueType": true,
    "help": "Enter the report Suite ID",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "orgid",
    "displayName": "Enter Adobe Org ID",
    "simpleValueType": true,
    "help": "Enter the Adobe Organisation ID",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "SELECT",
    "name": "eventtype",
    "displayName": "Event to Track",
    "macrosInSelect": false,
    "selectItems": [
      {
        "value": "page",
        "displayValue": "Pageview"
      },
      {
        "value": "custom",
        "displayValue": "Custom Link"
      },
      {
        "value": "download",
        "displayValue": "Download Link"
      },
      {
        "value": "exit",
        "displayValue": "Exit Link"
      }
    ],
    "simpleValueType": true
  },
  {
    "type": "TEXT",
    "name": "sevents",
    "displayName": "Add success event (if any) separated by comma",
    "simpleValueType": true,
    "help": "Set success events in comma separated format: event1,event2,event99",
    "valueHint": "event35,event3\u003d103,event121\u003d12.04"
  },
  {
    "type": "GROUP",
    "name": "requestBody",
    "displayName": "Adobe eVar and Props",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "SIMPLE_TABLE",
        "name": "reqBody",
        "displayName": "Set eVar and Props (Optional)",
        "simpleTableColumns": [
          {
            "defaultValue": "",
            "displayName": "Key",
            "name": "key",
            "type": "TEXT"
          },
          {
            "defaultValue": "",
            "displayName": "Value",
            "name": "value",
            "type": "TEXT"
          }
        ]
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const JSON = require('JSON');
const logToConsole = require('logToConsole');
const encodeUriComponent = require('encodeUriComponent');
//const queryPermission = require('queryPermission');
//const sendPixel = require('sendPixel');
const timestamp = require('getTimestampMillis');
const sendPixel = require('sendPixel');
const copyFromWindow = require('copyFromWindow');
const callInWindow=require('callInWindow');
const getCookieValues = require('getCookieValues');
//const injectScript = require('injectScript');

//const script="https://datalayerbuilder.in/jonnysliquor/global.js";

const endpoint= "https://"+data.trackingserver+"/b/ss/"+data.reportsuite+"/1/s234234238479?";

//logToConsole(endpoint);

let postBodyData = "AQB=1&ndh=0&pf=1ce=UTF-8&s=234Xss&ce=UTF-8";

let clientID= getCookieValues("ecid")[0];
//logToConsole(clientID);

postBodyData+="&mid="+clientID;

const t=timestamp()*1000;

const sevnt=data.sevents;

if(sevnt){
  postBodyData+="&events="+sevnt;
  logToConsole("events are"+sevnt);

}
//const page= data.page;

//postBodyData+="&t="+t+"&pageName="+page;

// set (pageName) 
//JS version installed
//screens size
//browser height width
//Page URL


for (let key in data.reqBody) {
    postBodyData += "&"+enc(data.reqBody[key].key) + '=' + enc(data.reqBody[key].value);

}

const orgID= data.orgid;

postBodyData+="&v=N&k=Y&mcorgid="+orgID;

const event = data.eventtype;
logToConsole(event);

switch (event) {
  case "page":
    break;
  case "custom":
    postBodyData+="&pe=lnk_o&pev2=link clicked";
    break;
  case "download":
    postBodyData+="&pe=lnk_d&pev2=link clicked";
    break;
  case "exit":
    postBodyData+="&pe=lnk_e&pev2=link clicked";
    break;
}
//const finalorgID= orgID.replace('@AdobeOrg', '');
//logToConsole(finalorgID);

//const cloudidurl="https://dpm.demdex.net/id?d_orgid="+finalorgID;

//logToConsole("CloudiDvar="+JSON.stringify(cloudID));

//const url=endpoint+postBodyData;
//logToConsole(url);

const result = callInWindow('globalFunction');
logToConsole("result = ", result);
postBodyData+="&t="+t+"&pageName="+result.pagePath+"&g="+result.pageURL+"&s="+result.screenSize;
postBodyData += "&AQE=1";

const url=endpoint+postBodyData;
//logToConsole(url);
sendPixel(url);

//injectScript(script,  test ,data.gtmOnFailure, "externalScript");
//logToConsole("script injected");


const onSuccess = () => {
  logToConsole('Script loaded successfully.');
  data.gtmOnSuccess();
};

// If the script fails to load, log a message and signal failure
const onFailure = () => {
  logToConsole('Script load failed.');
  data.gtmOnFailure();
};

function enc(data) {
    data = data || '';
    return encodeUriComponent(data);
}


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "all"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "send_pixel",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedUrls",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "globalFunction"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "get_cookies",
        "versionId": "1"
      },
      "param": [
        {
          "key": "cookieAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "cookieNames",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "ecid"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 9/30/2024, 4:42:06 PM



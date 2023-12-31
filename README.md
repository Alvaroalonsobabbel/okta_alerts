# Okta Alerts to Slack

This application receives events from Okta webhooks, looks for matching alerts in the database and post the event into Slack.
Alerts can be managed through a RESTful API.

## Okta Events

Okta Events are formated according to the [System Log API](https://developer.okta.com/docs/reference/api/system-log/) and events are cataloged in the [Event Types](https://developer.okta.com/docs/reference/api/event-types/) page.

## Alerts

Alerts will track three components of the Events generated by Okta:

- Event Type (mandatory)
- Actor ID
- Target ID

The Event Type is mandatory and each alert can only track one. You can track multiple Actor IDs and Target IDs for each Event Type.
Alert tracking parameters are additive:

- Tracking an Event Type only will alert every time this Event Type occur.
- Tracking an Event Type AND one or multiple Actor IDs will alert every time this Event Type and ANY of the tracked Actor IDs is in the Event, regardless of the Event's Target IDs
- Tracking an Event Type AND one or multiple Target IDs will alert every time this Event Type and ANY of the tracked Target IDs is in the Event, regardless of the Event's Alerts ID
- Tracking an Event Type AND one or multiple Actor AND Target IDs will alert every time any combination of Event Type, Actor ID and Target ID are present.

Unerstanding Events is key to create a successfull alert. For example:

- Tracking an account logging attempt:
  - Event Type: `user.session.start`
  - Actor ID: Account's ID
- Tracking someone being added to a group:
  - Event Type: `group.user_membership.add`
  - Traget ID: Group's ID

## Authentication

Authenticating to the API is done by Bearer Tokens. Different keys are needed for `/events` and `/alerts`.
The application will expect the following Header:

```bash
Authorization: Bearer <token>
```

## API Definition

#### Alerts

<details>
 <summary><code>GET</code> <code><b>/alerts</b></code> <code>(retrieves all alerts)</code></summary>

##### Parameters

> None

##### Responses

> | http code     | content-type                      | response                                                            |
> |---------------|-----------------------------------|---------------------------------------------------------------------|
> | `200`         | `application/json`                | `{ "data" : [ alerts ] }`                                           |

##### Example cURL

> ```sh
>  curl -L -X GET "https://#{endpoint_url}/alerts"
> ```

</details>

<details>
 <summary><code>GET</code> <code><b>/alerts/:id</b></code> <code>(retrieves an alert)</code></summary>

##### Parameters

> | name      |  type   | required  | data type               | description                                                           |
> |-----------|---------|-----------|-------------------------|-----------------------------------------------------------------------|
> | id        | URL     | true      | int                     | The specific Alert ID                                                 |

##### Responses

> | http code     | content-type                      | response                                                            |
> |---------------|-----------------------------------|---------------------------------------------------------------------|
> | `200`         | `application/json`                | `{ "data" : { alert } }`                                            |
> | `404`         | -                                 | -                                                                   |

##### Example cURL

> ```sh
>  curl -L -X GET "https://#{endpoint_url}/alerts/2"
> ```

</details>

<details>
 <summary><code>POST</code> <code><b>/alerts</b></code> <code>(creates an alert)</code></summary>

##### Parameters

> | name                  | type  | required     | data type               | description                                                |
> |-----------------------|-------|--------------|-------------------------|------------------------------------------------------------|
> | [data][event_type]    | body  | true         | string                  | The Okta eventType to monitor                              |
> | [data][slack_webhook] | body  | true         | string                  | The Slack Webhook URL to post the alert to                 |
> | [data][target_id]     | body  | false        | array of strings        | Okta IDs for the Targets to monitor                        |
> | [data][actor_id]      | body  | false        | array of strings        | Okta IDs for the Actors to monitor                         |
> | [data][description]   | body  | false        | text                    | Description of the event                                   |

##### Responses

> | http code     | content-type                      | response                                                            |
> |---------------|-----------------------------------|---------------------------------------------------------------------|
> | `201`         | `application/json`                | { "data": { created_event }, "status": "Created" }                  |
> | `422`         | `application/json`                | { "error": error_message }                                          |

##### Example cURL

>```sh
>curl -L -X POST 'http://#{endpoint_url}/alerts' \
>-H 'Content-Type: application/json' \
>-d '{
>    "data": {
>            "event_type": "group.user_membership.add",
>            "actor_id": ["00g94mecoy1nH7wRP1d7", "0f3f3emecoy1nH7wRP1d7"],
>            "target_id": ["00g94mecoy1nH7wRP1d7"],
>            "slack_webhook": "https://hooks.slack.com/services/T024GE59A/B05G0UG44DA/7gAXtsxogW223f23eBNmBK",
>            "description": "some description"
>     }'
>```

</details>

<details>
 <summary><code>PATCH</code> <code><b>/alerts/:id</b></code> <code>(updates an alert)</code></summary>

##### Parameters

> | name                  | type  | required     | data type               | description                                                |
> |-----------------------|-------|--------------|-------------------------|------------------------------------------------------------|
> | id                    | URL   | true         | int                     | Alert ID
> | [data][event_type]    | body  | false        | string                  | The Okta eventType to monitor                              |
> | [data][slack_webhook] | body  | false        | string                  | The Slack Webhook URL to post the alert to                 |
> | [data][target_id]     | body  | false        | array of strings        | Okta IDs for the Targets to monitor                        |
> | [data][actor_id]      | body  | false        | array of strings        | Okta IDs for the Actors to monitor                         |
> | [data][description]   | body  | false        | text                    | Description of the event                                   |

##### Responses

> | http code     | content-type                      | response                                                            |
> |---------------|-----------------------------------|---------------------------------------------------------------------|
> | `200`         | `application/json`                | { "data": { created_event }, "status": "Updated" }                  |
> | `404`         | -                                 | -                                                                   |
> | `422`         | `application/json`                | { "error": error_message }                                          |

##### Example cURL

>```sh
>curl -L -X PATCH 'http://#{endpoint_url}/alerts' \
>-H 'Content-Type: application/json' \
>-d '{
>    "data": {
>            "event_type": "group.user_membership.add"
>     }'
>```

</details>

<details>
  <summary><code>DELETE</code> <code><b>/alert/:id</b></code> <code>(deletes the alert)</code></summary>

##### Parameters

> | name      |  type   | required  | data type               | description                                                           |
> |-----------|---------|-----------|-------------------------|-----------------------------------------------------------------------|
> | id        | URL     | true      | int                     | The specific Alert ID                                                 |

##### Responses

> | http code     | content-type                      | response                                                            |
> |---------------|-----------------------------------|---------------------------------------------------------------------|
> | `204`         | -                                 | -                                                                   |
> | `404`         | -                                 | -                                                                   |

##### Example cURL

> ```sh
>  curl -L -X DELETE "https://#{endpoint_url}/alerts/2"
> ```

</details>

#### Events

<details>
  <summary><code>GET</code> <code><b>/events</b></code> <code>(verifies the endpoint with okta)</code></summary>

##### Parameters

> | name      |  type   | required  | data type               | description                                                           |
> |-----------|---------|-----------|-------------------------|-----------------------------------------------------------------------|
> | X_OKTA_VERIFICATION_CHALLENGE      | HEADER     | true      | string    | Okta verification challenge value                       |

##### Responses

> | http code     | content-type                      | response                                                            |
> |---------------|-----------------------------------|---------------------------------------------------------------------|
> | `200`         | `application/json`                | { "verification": content_of_X_OKTA_VERIFICATION_CHALLENGE }        |

##### Example cURL

> ```sh
> curl -L -X GET 'http://#{endpoint_url}/events' \
> -H 'X_OKTA_VERIFICATION_CHALLENGE: value'
> ```

</details>

<details>
  <summary><code>POST</code> <code><b>/events</b></code> <code>(receives events from okta)</code></summary>

##### Parameters

> None

##### Responses

> | http code     | content-type                      | response                                                            |
> |---------------|-----------------------------------|---------------------------------------------------------------------|
> | `200`         | -                                 | -                                                                   |

##### Example cURL

> ```sh
>curl -L -X POST 'http://#{endpoint_url}/events' \
>-H 'Content-Type: application/json' \
>--data-raw '{
>    "eventType": "com.okta.event_hook",
>    "data": {
>        "events": [
>            {
>                "uuid": "6176a4ec-74d7-11ee-9749-01b1d80fa5f4",
>                "published": "2023-10-27T14:44:49.702Z",
>                "eventType": "user.account.reset_password",
>                "actor": {
>                    "id": "00u28g6btw2OBoq5f1d7",
>                    "type": "User",
>                    "alternateId": "aalonso@paperjamtoast.com",
>                    "displayName": "Alvaro Paper Jam Toast",
>                    "detailEntry": null
>                },
>                "outcome": {
>                    "result": "SUCCESS",
>                    "reason": null
>                },
>                "target": [
>                    {
>                        "id": "00u7nys3x0tu928bM1d7",
>                        "type": "User",
>                        "alternateId": "blttest@paperjamtoast.com",
>                        "displayName": "test test",
>                        "detailEntry": null
>                    }
>                ]
>            }
>        ]
>    }
>}'
> ```

</details>

# JWTAuthenticationServer


This project developed for demonstration purposes and provides an API for token based authentication using [JWT (JSON Web Tokens)](https://jwt.io/introduction)

## Endpoints

Base URL for this API  `http://127.0.0.1:8080/users`

### To create (sign up) new user

Add  this endpoint to base URL `/create`
(method: POST)

Your need to pass in body of request using form-data following fields:
- name
- email
- password
- confirmPassword

Then you can see in the response something like that:
```
{
    "id": "CA37DF2C-3C15-47EB-BC32-23FBAAC667AD",
    "name": "user",
    "email": "user@test.com",
    "passwordHash": "$2b$12$3T.PidGgjEbzabIOVhKp3OG7sVvd/pnEN0G.koGUGjEf9WOU03iv.",
    "createdAt": "2021-07-21T09:33:00Z",
    "lastModifiedAt": "2021-07-21T09:33:00Z"
}
```

### To login user

Use endpoint `/login` 
(method: POST)

In Authorization header pass the API a Base64 encoded string representing your users email and password values, appended to the text "Basic" as follows:
```
Basic <Base64 encoded email:password>
```

The response will look like something like that:
```
{
    "id": "1E63CD6A-D009-4C3E-9B2A-5585C249F282",
    "user": {
        "id": "CA37DF2C-3C15-47EB-BC32-23FBAAC667AD"
    },
    "value": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IkNBMzdERjJDLTNDMTUtNDdFQi1CQzMyLTIzRkJBQUM2NjdBRCIsIm5hbWUiOiJ1c2VyIiwiZXhwIjoxNjI3MDQwNTc5LjAxNDA4fQ.JmtlM8P796lUDQFczUuqz0RAUPm2Dt6lbUOmnpft2zRE1Oh86ka5QmRjqzQt9whTWI1TtLgpMUu8MPH5O71UG3XeNpHhcXcfTuVZiWp0Ijzt2RYICPWZBu-j3_G2WUPUbxnfaW4KwcDAQyBTWT-hmgE5pBND31pOppaxqLifuB3e-ArHzcZq03PJ42slEDDfxWM0G6pgR7P3L61Egc12K2t9Xyz2dFnmxhQ42zDKp0Y98j1tNoo1v8cXqJ234t99-ZVnb3LugyukYQTyPK-OSTh9LYnWHRZei0rfDVF8rcpZ2LPmKmEBpFKPP3yHjusvm6VwTx0oqV263WutjkRzb8IVrBDIwTKzvvaURYcPYnBld4AIo4mOJvUjm0UtTO5-RxrQ__r8h5sUIdoJJVHU0GQyCm7SUXtpqABrVFsO_ajAJPmKiYmRHe2P-fh87wAEQm6wDrsBUkmtM19XVByVMcroK0SXhBjBLmQLkfHM_Il9KmgkuNUp2bcvwth4LSOqnSYMHqc2PySaEWCBSdPantnnRriqo7YII4gaIzYTS_ROw18g32cs-Yi7y4kKjxLGuz96uXp_ZyXJolRnhG8el2vUJSUo3M3Jb2lB2q8Mj4YjuoDX48X0fe_g--GZC__wBdh492nI8L6Dbbz7Kbz__y14AqV_PpKy17yG-AXF6Fw"
}
```

### To get users payload

Use endpoint `/me` 
(method: GET)

In Authorization header pass the API token value from the login response, appended to the text "Bearer", as follows:
```
Bearer <Your token value>
```

In the response you should see:
```
{
    "id": "CA37DF2C-3C15-47EB-BC32-23FBAAC667AD",
    "username": "user"
}
```





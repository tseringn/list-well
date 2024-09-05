# README

# List Well

This is List Well, it allows clients to submit buildings they own and make updates to them. It also enables other clients to read paginated list of buildings with location and custom fields with value. The system provides APIs to create, read, update, and delete (CRUD) buildings and clients and their related data. The application is built using Ruby on Rails with a focus on modular service layers.

## Table of Contents

- [README](#readme)
- [List Well](#list-well)
  - [Table of Contents](#table-of-contents)
  - [Features](#features)
  - [Technologies](#technologies)
  - [Setup](#setup)
  - [Database Structure](#database-structure)
    - [Models:](#models)
  - [Usage](#usage)
    - [Endpoints](#endpoints)
      - [GET /buildings](#get-buildings)
      - [POST /buildings](#post-buildings)
      - [PATCH /buildings/:id](#patch-buildingsid)
      - [DELETE /buildings/:id](#delete-buildingsid)
      - [GET /clients](#get-clients)
      - [GET /clients/:id](#get-clientsid)
      - [POST /clients](#post-clients)
      - [DELETE /clients/:id](#delete-clientsid)
    - [Request Format](#request-format)
  - [Immediate Further Improvement](#immediate-further-improvement)

## Features

- Create, update, delete, and view buildings.
- Manage custom attributes for buildings.
- Associate buildings with locations.
- Paginated results for large data sets.
- Modular service pattern for easy scalability.
- Custom validations and error handling.

## Technologies

- **Backend**: Ruby on Rails
- **Database**: SQLite
- **Data Seeding**: Faker for generating mock data.

## Setup

1. Clone the repository:

   ```bash
   git clone https://github.com/tseringn/list-well.git
   cd list-well
   ```

2. Install dependencies:

   ```bash
   bundle install
   ```

3. Set up the database:

   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. Start the Rails server:

   ```bash
   rails s
   ```

5. Access the application at:
   ```
   http://127.0.0.1:3000
   ```

## Database Structure

### Models:

- **Building**

  - Attributes: `name`, `year_built`, `lot_area`, `client_id`
  - Associations: `has_many :building_attributes`, `has_one :location`

- **Location**

  - Attributes: `name`, `address`, `lat`, `lng`
  - Associations: `belongs_to :building`

- **BuildingAttribute**

  - Attributes: `field_value`
  - Associations: `belongs_to :building`, `belongs_to :custom_field`

- **CustomField**
  - Attributes: `field_name`, `field_type`- enum of `number_type`,`freeform_type`,`enum_type`
  - Associations: `belongs_to :client`, `has_many :building_attributes`

## Usage

### Endpoints

#### GET /buildings

Fetches a list of all buildings, including locations and key value pair of `<custom field name>: <building attribute field value>`

```bash
GET /buildings?page=1
```

#### POST /buildings

Creates a new building.

```bash
POST /buildings
```

Body (example):

```json
{
  "building": {
    "name": "New Building",
    "year_built": 1995,
    "lot_area": 1500,
    "client_id": 1,
    "attributes": [{ "id": 2, "weight": "heavy" }], // depends on field type of the custom field "weight"
    "location": {
      "name": "Main Office",
      "address": "123 Main St"
    }
  }
}
```

#### PATCH /buildings/:id

Updates an existing building.

```bash
PATCH /buildings/:id
```

Body (example):

```json
{
  "building": {
    "name": "Updated Building",
    "attributes": [{ "id": 2, "weight": "light" }],
    "location": {
      "name": "New Location"
    }
  }
}
```

#### DELETE /buildings/:id

Deletes an existing building.

```bash
DELETE /buildings/:id
```

#### GET /clients

Fetches a list of all clients, including their custom fields.

**Request:**

```http
GET /clients
```

**Response:**

```json
[
  {
    "id": 1,
    "name": "Client Name",
    "custom_fields": [
      {
        "id": 1,
        "field_name": "Field Name",
        "field_type": "number_type"
      }
    ]
  }
]
```

#### GET /clients/:id

Fetches details for a single client by ID.

**Request:**

```http
GET /clients/:id
```

**Response:**

```json
{
  "id": 1,
  "name": "Client Name",
  "custom_fields": [
    {
      "id": 1,
      "field_name": "Field Name",
      "field_type": "text"
    }
  ]
}
```

#### POST /clients

Creates a new client. You can also specify custom fields in the request.

**Request:**

```http
POST /clients
```

**Body (example):**

```json
{
  "client": {
    "name": "New Client",
    "custom_fields": [
      {
        "field_name": "Custom Field Name",
        "field_type": "string"
      }
    ]
  }
}
```

**Response:**

```json
{
  "id": 1,
  "name": "New Client",
  "custom_fields": [
    {
      "id": 1,
      "field_name": "Custom Field Name",
      "field_type": "string"
    }
  ]
}
```

#### DELETE /clients/:id

Deletes an existing client.

**Request:**

```http
DELETE /clients/:id
```

**Response:**

```json
{
  "message": "Client deleted successfully."
}
```

### Request Format

All requests and responses are in JSON format.

## Immediate Further Improvement

- Better error handling
- Format code for better readability
- Test all the controllers

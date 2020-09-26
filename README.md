# README

Test application, appeared after the **Arkency DDD training** (https://www.youtube.com/c/Arkency)

## Goal
Practice DDD technique:
- event-driven design
- event-source design
- boundry contexts
- read-models
- aggregate roots

## Structure
- **SeatReservation** boundry context with two entities: **passenger** and **seat**, with *aggregate root*, and *read-model*
- **Notification** boundry context with only the *read-model*, which is responsible for emails sending
- **SearReservationController** and view pages
- **AdminMailer** (dummy)

## Tools
- gem **rails_event_store** (https://railseventstore.org/)
- **dry.rb** libraries (https://dry-rb.org/)

## TODO
- add auto-expiration of unpaid reservations
- generate a report for paid reservation

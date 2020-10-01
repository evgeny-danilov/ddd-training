# README

Test application, appeared after the **Arkency DDD training** (https://www.youtube.com/c/Arkency)

## Goal
Practice DDD technique:
- event-driven design
- event-source design
- boundry contexts
- aggregate roots
- read-models (suscribers)

## Structure
- Root folder **/domains** for domains
- **SeatReservation** boundry context with two entities: **passenger** and **seat**, with *aggregate root*, and *subscriber*
- **Notification** boundry context with only the *subscriber*, which is responsible for emails sending
- **SearReservationController** and view pages
- **AdminMailer** (dummy)

## Tools & Approaches
- gem **rails_event_store** (https://railseventstore.org/)
- **dry.rb** libraries (https://dry-rb.org/)
- **SecureRandom.uuid** as a generator of unique ids for reservations. 

## TODO
- correct the behaviour when user enter incorrent passenger data
- add auto-expiration of unpaid reservations
- generate a report for paid reservation

# README

Test application, appeared after the **Arkency DDD training** (https://www.youtube.com/c/Arkency)

## Goal
Practice DDD technique:
- event-driven design
- event-source design
- boundary contexts
- aggregate roots
- read-models (subscribers)

## Structure
- Root folder **/domains** for domains
- **SeatReservation** boundry context with two entities: **passenger** and **seat**, with *aggregate root*, and *subscriber*
- **Flight** boundry context, flight has many seat reservations
- **Route** boundry context, route has many flights. This context doesn't follow the event sourcing approach.
- **Notification** boundry context with only the *subscriber*, which is responsible for emails sending
- **SearReservationController** and view pages
- **AdminMailer** (dummy)

## Tools & Approaches
- gem **rails_event_store** (https://railseventstore.org/)
- **dry.rb** libraries (https://dry-rb.org/)
- **SecureRandom.uuid** as a generator of unique ids for reservations. 
- gem **mutant** for mutation testing (https://github.com/mbj/mutant). Example for usage: 
  `bundle exec mutant run --include domains -r ./config/environment --use rspec SeatReservation::CommandHandler`

## TODO
- try to split read and write models to a few databases
- probably, get rid of complex Event classes (or make some experiments in GDPR) 
- adjust the behaviour when user enter incorrect passenger data through the UI
- revise the read model approach

## IDEAS FOR FURTHER EXPERIMENTS
- notify passengers if flight cancelled
- add auto-expiration of unpaid reservations
- generate a report for a paid reservation
- extend parameters for AdminMailer (see `domains/notification/lib/read_model/subscribers.rb`)

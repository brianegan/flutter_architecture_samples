# rvms

This is an implementation of the architecture sample following the RVMS approach where you have Views over Managers that contain the business logic which uses Services to connect to the outside world.

It uses the following packages:

* `get_it`: as ServiceLocator to access Managers from the UI and Services from Managers
* `get_it_mixin`: to bind the data inside GetIt to the the Widgets
+ `flutter_command`: as connector between Manager UI
* `functional_listener`: rx like extension methods for `ValueListenables`
* `listenable_collections`: We use `ListNotifier` of this package which is a List that behaves like a `ValueNofitier`
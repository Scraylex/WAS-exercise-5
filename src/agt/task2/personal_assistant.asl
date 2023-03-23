// personal assistant agent 

/* Task 2 Start of your solution */
is_awake :- owner_state(State) & State == "awake".

are_down :- blinds(State) & State == "lowered".

is_vibrating :- mattress(State) & State == "vibrating".

go_to_event :- upcoming_event(State) & State == "now".

best_option("vibrations") :- wakeup_pref_lights(X) & wakeup_pref_blinds(Y) & wakeup_pref_vibration(Z) & Z < Y & Z < X.

best_option("vibrations").
wakeup_pref_lights(2).
wakeup_pref_blinds(1).
wakeup_pref_vibration(0).

!start.

@start_plan
+!start : true <-
    .wait(1000);
    !meeting_now;
    !start.

@event_now_owner_awake_plan
+!meeting_now : go_to_event & is_awake <- 
    .print("Enjoy your event").

@event_now_owner_asleep_plan
+!meeting_now : go_to_event & not is_awake <- 
    .print("Starting wake up routine");
    !wake_user.

@owner_woken_successfully_plan
+!wake_user : is_awake <-
    .print("Woke user up").

@wake_plan
+!wake_user: not is_awake <-
    ?best_option(Current);
    .wait(1000);
    !wake_user(Current).


@wake_vibrate_plan
+!wake_user(Option) : not is_awake & Option == "vibrations" <-
    setVibrationsMode;
    -+best_option("blinds");
    !wake_user.

@wake_blinds_plan
+!wake_user(Option) : not is_awake & Option == "blinds" <-
    raiseBlinds;
    -+best_option("lights");
    !wake_user.

@wake_lights_plan
+!wake_user(Option) : not is_awake & Option == "lights" <-
    turnOnLights;
    -best_option(Option);
    .print("No further waking options left").

@select_option_plan
+best_option(State) : true <- 
    .print("The best option is ", State).

@calendar_plan
+upcoming_event(State) : true <-
    .print("The calendar is ", State).

@wrist_band_plan
+owner_state(State) : true <-
    .print("The owner state is ", State).

@mattress_plan
+mattress(State) : true <-
    .print("The mattress is ", State).

@blinds_plan
+blinds(State) : true <- 
    .print("The blinds are ", State).

@lights_plan
+lights(State) : true <- 
    .print("The lights are ", State).
/* Task 2 End of your solution */

/* Import behavior of agents that work in CArtAgO environments */
{ include("$jacamoJar/templates/common-cartago.asl") }
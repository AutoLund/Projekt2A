(*----------Pre program----------*)

REGION Ton Initialize
    //Initialize PT on timers
    //PT could be a variable, for easy change on HMI
    "Ton1s".TON(IN := "Ton1s".IN,
                PT := t#1s);
    "TonGreen5s".TON(IN := "TonGreen5s".IN,
                     PT := t#5s);
    "TonBlue8s".TON(IN := "TonBlue8s".IN,
                    PT := t#8s);
    "TonRed10s".TON(IN := "TonRed10s".IN,
                    PT := t#10s);
    "Ton10s".TON(IN := "Ton10s".IN,
                 PT := t#10s);
END_REGION

REGION MB Client
    "MB_CLIENT_UR"(REQ := "Clock_1Hz",
                   DISCONNECT := "ClientInfo".Disconnect,
                   MB_MODE := 1,
                   MB_DATA_ADDR := 40002,
                   MB_DATA_LEN := "ClientInfo".MB_DATA_LEN,
                   DONE => "ClientInfo".DONE,
                   BUSY => "ClientInfo".BUSY,
                   ERROR => "ClientInfo".ERROR,
                   STATUS => "ClientInfo".STATUS,
                   CONNECT := "ClientInfo".CONNECT,
                   MB_DATA_PTR := "ClientInfo".DATA);
    
//Find IP on UR
//Find General purpose pins and addresses
    
    
END_REGION


REGION Speed
    "Speed" := LIMIT(MN := 1, IN := "Speed", MX := 1000);             //Limits the speed between 1 and 1000
    "Analogspeed" := REAL_TO_INT("Speed" * 27648.0 / 1000.0);         //Analog conversion 100 = 1V
END_REGION

REGION Stage0
(*----------Stage 0 Initialize----------*)
//Starting value for Stage is 0.
IF "Stage" = 0 THEN
    "FWD" := 0;
    "BWD" := 0;
    "ToPreheat" := 0;
    "ToCure" := 0;
    "ManualMode" := 0;
    "Red" := 0;
    "Blue" := 0;
    "Green" := 0;
    "ClientInfo".DATA[8] := 0;          //Reset for next run
    "ClientInfo".DATA[9] := 0;          //Reset for next run
    "ClientInfo".DATA[10] := 0;         //"Reset" FOR next run
    "ClientInfo".DATA[12] := 0;         //Stage 13 ended
    "ClientInfo".DATA[13] := 0;         //S3 ended
    //reset a counter?
    //Reset UR?
    //Reset timers?
    
    IF "S1" = 0 AND "S2" = 0 AND "S3" = 0 THEN
        "Stage" := 1;
    END_IF;
    
END_IF;
END_REGION


REGION FOR Testing
    
    
END_REGION

(*----------Sekvens----------*)


(* -------Check "Start"-------- *)
IF "Stage" = 1 AND "StartBit" AND "S1" THEN
    "FWD" := 0;
    "Ton1s".IN := 1;              //Initialize TON1s
    "Speed" := 300;               //Speed 3v / 30hz
    "ToPreheat" := 1;             //Start heater
    "Stage" := 2;
    
    //Running the belt untill element is in front of sensor.
ELSIF "Stage" = 1 AND "StartBit" AND NOT "S1" THEN
        "FWD" := 1;
        "Speed" := 300;
END_IF;

// 1 Second wait, to increase validity of colorsensor
IF "Stage" = 2 AND "Ton1s".Q THEN
    "Red" := "RedSensor";               //Utilizes internal variables, to lock the color for current run
    "Blue" := "BlueSensor";             //Utilizes internal variables, to lock the color for current run
    "Green" := "GreenSensor";           //Utilizes internal variables, to lock the color for current run
    "Ton1s".IN := 0;              //Disable TON1s
    "Stage" := 3;
END_IF;

//Wait untill Preheat temp is reached
IF "Stage" = 3 AND "Temp" = "SPpreheat" THEN
    "FWD" := 1;
    "Stage" := 4;
END_IF;

//Stopping the belt for preparation
IF "Stage" = 4 AND "S2" THEN
    "FWD" := 0;
    "Stage" := 5;
END_IF;

//Determination of color and which timer to run initialize
IF "Stage" = 5 AND "Red" THEN            //RED
    "TonRed10s".IN := 1;
    "Stage" := 6;
ELSIF "Stage" = 5 AND "Blue" THEN        //BLUE
    "TonBlue8s".IN := 1;
    "Stage" := 6;
ELSIF "Stage" = 5 AND "Green" THEN       //GREEN
    "TonGreen5s".IN := 1;
    "Stage" := 6;
END_IF;

//Preheating done, return to processing
IF "Stage" = 6 AND "TonRed10s".Q OR "Stage" = 6 AND "TonBlue8s".Q OR "Stage" = 6 AND "TonGreen5s".Q THEN
    "BWD" := 1;
    "Speed" := 500;
    "TonGreen5s".IN := 0;
    "TonBlue8s".IN := 0;
    "TonRed10s".IN := 0;
    "ToCure" := 1;                  //Used to determine heater on/off
    "ToPreheat" := 0;               //Used to determine heater on/off
    "Stage" := 7;
END_IF;

//Enabling Process Ton when on processing possition
IF "Stage" = 7 AND "S1" THEN
    "BWD" := 0;
    "Ton10s".IN := 1;
    "Stage" := 8;
END_IF;

//10s Wait for processing TON, and temp
IF "Stage" = 8 AND "Ton10s".Q AND "Temp" = "SPcure" THEN
    "Ton10s".IN := 0;
    "FWD" := 1;
    "Speed" := 300;
    "Stage" := 9;
END_IF;

//Preparation for curing
IF "Stage" = 9 AND "S2" THEN
    "FWD" := 0;
    "Stage" := 10;
END_IF;

//Enable curing timers based on color
IF "Stage" = 10 AND "Red" THEN            //RED
    "TonRed10s".IN := 1;
    "Stage" := 11;
ELSIF "Stage" = 10 AND "Blue" THEN        //BLUE
    "TonBlue8s".IN := 1;
    "Stage" := 11;
ELSIF "Stage" = 10 AND "Green" THEN       //GREEN
    "TonGreen5s".IN := 1;
    "Stage" := 11;
END_IF;

//Curing done
IF "Stage" = 11 AND "TonRed10s".Q OR "Stage" = 11 AND "TonBlue8s".Q OR "Stage" = 11 AND "TonGreen5s".Q THEN
    "TonGreen5s".IN := 0;
    "TonBlue8s".IN := 0;
    "TonRed10s".IN := 0;
    "FWD" := 1;
    "Speed" := 500;
    "ToPreheat" := 1;                   //Used to determine heater on/off
    "ToCure" := 0;                      //Used to determine "Heater" on/off
    "Stage" := 12;
END_IF;

//Stopping belt, ready for pickup
IF "Stage" = 12 AND "S3" THEN
    "FWD" := 0;
    "Stage" := 13;
END_IF;

//Determination OF which address TO be switched on/off, depending
IF "Stage" = 13 AND "Red" THEN
    "ClientInfo".DATA[8] := 1;          //Red Output on UR
    "ClientInfo".DATA[12] := 1;         //Verification of Stage 13
    "ClientInfo".DATA[13] := 1;         //Verification of S3
    "Stage" := 14;
    
ELSIF "Stage" = 13 AND "Blue" THEN
    "ClientInfo".DATA[9] := 1;          //Blue Output on UR
    "ClientInfo".DATA[12] := 1;         //Verification of Stage 13
    "ClientInfo".DATA[13] := 1;         //Verification of S3
    "Stage" := 14;
    
ELSIF "Stage" = 13 AND "Blue" THEN
    "ClientInfo".DATA[10] := 1;         //Green Output on UR
    "ClientInfo".DATA[12] := 1;         //Verification of Stage 13
    "ClientInfo".DATA[13] := 1;         //Verification of S3
    "Stage" := 14;
END_IF;

IF "Stage" = 14 AND "S3" = 0 THEN
    "ClientInfo".DATA[8] := 0;          //Reset for next run
    "ClientInfo".DATA[9] := 0;          //Reset for next run
    "ClientInfo".DATA[10] := 0;         //"Reset" FOR next run
    "ClientInfo".DATA[12] := 0;         //Stage 13 ended
    "ClientInfo".DATA[13] := 0;         //S3 ended
    "Stage" := 1;
END_IF;


(*----------StartBit control button----------*)
IF "Stop" THEN
    "StartBit" := 0;
ELSIF "Start" AND NOT "Stop" THEN
    "StartBit" := 0;
END_IF;
    
    
(*----------ESTOP & Manual Control----------*)
IF "EStop" = 0 THEN
    "Stage" := 1000;
    "FWD" := 0;
    "BWD" := 0;
    "ToPreheat" := 0;
    "ToCure" := 0;
    "Heater" := 0;
    //Missing UR robot E-stop
    //Holding register reset
END_IF;

IF "Stage" = 1000 AND "Reset" AND "StartBit" = 0 AND "EStop" THEN
    "Stage" := 0;
    //Ur reset Estop Missing
ELSIF "Stage" = 1000 AND "ManualMode" THEN              //For manual control after eStop
    IF "Manual_FWD" THEN
        "FWD" := 1;
    ELSIF "Manual_BWD" THEN
        "BWD" := 1;
    ELSE
        "FWD" := 0;
        "BWD" := 0;
    END_IF;
END_IF;
    



(*----------Notes----------*)
//
//Inspektionsprogram?
//UR Estop. HOW?
//Holding register reset
//Counter
//FIX TON!
//
//
//HMI Krav:
//Tomkøring (frem og tilbage)
//Antal af behandlede emner idag
//Antal af behandlede emner før
//Trends for temp
//Animeret side af placering på conveyor
//
//Bonus Points:
//Hvordan tages der stilling til færdigpalletering? (uden for scope?)
//Switch Case / Case OF
//Functions & Local variables

(*----------Heater Sekvens----------*)

//Curing
IF "ToCure" AND "Temp" < "SPcure" THEN
    "Heater" := 1;
ELSIF "ToCure" AND "Temp" > "SPcure" THEN
    "Heater" := 0;
END_IF;

//Preheating
IF "ToPreheat" AND "Temp" < "SPpreheat" THEN
    "Heater" := 1;
ELSIF "ToPreheat" AND "Temp" > "SPpreheat" THEN
    "Heater" := 0;
END_IF;









*Not tested

Global Param's:
	Stage	Int	%MW100	False	True	True	True		Used for main program stages
	FWD	Bool	%Q2.1	False	True	True	True		
	BWD	Bool	%Q2.2	False	True	True	True		
	Analogspeed	Int	%QW3	False	True	True	True		0..10v
	Speed	Real	%MD202	False	True	True	True		Used for scaling. Limit 1-1000
	BlueSensor	Bool	%I2.0	False	True	True	True		Input
	GreenSensor	Bool	%I2.1	False	True	True	True		Input
	RedSensor	Bool	%I2.2	False	True	True	True		Input
	S1	Bool	%I2.3	False	True	True	True		
	S2	Bool	%I2.4	False	True	True	True		
	S3	Bool	%I2.5	False	True	True	True		
	Blue	Bool	%M210.0	False	True	True	True		Variable for storing input
	Green	Bool	%M210.2	False	True	True	True		Variable for storing input
	Red	Bool	%M210.4	False	True	True	True		Variable for storing input
	Start	Bool	%I2.6	False	True	True	True		
	Heater	Bool	%Q0.0	False	True	True	True		
	Temp	Int	%MW220	False	True	True	True		
	SPpreheat	Int	%MW232	False	True	True	True		Preheat Setpoint
	SPcure	Int	%MW234	False	True	True	True		Curing Setpoint
	ToCure	Bool	%M240.0	False	True	True	True		
	ToPreheat	Bool	%M240.2	False	True	True	True		
	Switch0Start	Bool	%I0.0	False	True	True	True		For testing ONLY. Start = 1
	Switch2	Bool	%I0.1	False	True	True	True		For testing ONLY. Temp = 50
	Switch3	Bool	%I0.2	False	True	True	True		For testing ONLY. Temp = 70

![image](https://github.com/user-attachments/assets/9ec5cf83-eff1-4316-a6c9-6fc5d435e3bc)





top:
	iverilog -g2012 -o pixelTop -c pixelTop.fl
	vvp -n pixelTop

ps:
	iverilog -g2012 -o pixelSensor -c pixelSensor.fl
	vvp -n pixelSensor

psfsm:
	iverilog -g2012 -o pixelSensorFsm -c pixelSensorFsm.fl
	vvp -n pixelSensorFsm

pa:
	iverilog -g2012 -o pixelArray -c pixelArray.fl
	vvp -n pixelArray

psm:
	iverilog -g2012 -o pixelState -c pixelState.fl
	vvp -n pixelState

ysfsm: synth
	dot pixelSensorFsm.dot -Tpng > pixelSensorFsm.png

synth:
	yosys pixelSensorFsm.ys

test: ps psfsm synth

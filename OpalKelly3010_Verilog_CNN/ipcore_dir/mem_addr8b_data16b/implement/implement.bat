
 
 
 




rem Clean up the results directory
rmdir /S /Q results
mkdir results

rem Synthesize the VHDL Wrapper Files


echo 'Synthesizing example design with XST';
xst -ifn xst.scr
copy mem_addr8b_data16b_exdes.ngc .\results\


rem Copy the netlist generated by Coregen
echo 'Copying files from the netlist directory to the results directory'
copy ..\..\mem_addr8b_data16b.ngc results\


rem  Copy the constraints files generated by Coregen
echo 'Copying files from constraints directory to results directory'
copy ..\example_design\mem_addr8b_data16b_exdes.ucf results\

cd results

echo 'Running ngdbuild'
ngdbuild -p xc3s1500-fg320-4 mem_addr8b_data16b_exdes

echo 'Running map'
map mem_addr8b_data16b_exdes -o mapped.ncd  -pr i

echo 'Running par'
par mapped.ncd routed.ncd

echo 'Running trce'
trce -e 10 routed.ncd mapped.pcf -o routed

echo 'Running design through bitgen'
bitgen -w routed

echo 'Running netgen to create gate level Verilog model'
netgen -ofmt verilog -sim -tm mem_addr8b_data16b_exdes -pcf mapped.pcf -w -sdf_anno false routed.ncd routed.v

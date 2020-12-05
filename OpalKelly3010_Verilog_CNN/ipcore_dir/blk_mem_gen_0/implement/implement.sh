
 
 
 




#!/bin/sh

# Clean up the results directory
rm -rf results
mkdir results

#Synthesize the Wrapper Files

echo 'Synthesizing example design with XST';
xst -ifn xst.scr
cp blk_mem_gen_0_exdes.ngc ./results/


# Copy the netlist generated by Coregen
echo 'Copying files from the netlist directory to the results directory'
cp ../../blk_mem_gen_0.ngc results/

#  Copy the constraints files generated by Coregen
echo 'Copying files from constraints directory to results directory'
cp ../example_design/blk_mem_gen_0_exdes.ucf results/

cd results

echo 'Running ngdbuild'
ngdbuild -p xc3s1500-fg320-4 blk_mem_gen_0_exdes

echo 'Running map'
map blk_mem_gen_0_exdes -o mapped.ncd -pr i

echo 'Running par'
par mapped.ncd routed.ncd

echo 'Running trce'
trce -e 10 routed.ncd mapped.pcf -o routed

echo 'Running design through bitgen'
bitgen -w routed

echo 'Running netgen to create gate level Verilog model'
netgen -ofmt verilog -sim -tm blk_mem_gen_0_exdes -pcf mapped.pcf -w -sdf_anno false routed.ncd routed.v

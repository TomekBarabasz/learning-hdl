import jinja2 as j2
import shlex,unittest,sys
from subprocess import run

class VHDLTestBench:
    def __init__(self, sys_clk, bus_clk, name):
        self.statements=[]
        self.set(scl=1,clk=0)
        self.reset()
        self.sys_clk = sys_clk
        self.bus_clk = bus_clk
        self.tb_name = name
    
    def wait(self,waittime=1):
        self.statements.append(f"wait for {waittime} ns;")
    
    def reset(self,waittime=1):
        self.set( reset_n=0 )
        self.wait(waittime)
        self.set( reset_n=1 )

    def set(self, **kwargs):
        self.statements.extend( [f"{s} <= '{v}';" for s,v in kwargs.items()])
    
    def tick(self,nticks=1,clock='clk',waittime=1):
        s = self.statements
        s.append(f'for i in 0 to {nticks} loop')
        s.append(f"{clock} <= '1';")
        s.append(f"wait for {waittime} ns;")
        s.append(f"{clock} <= '0';")
        s.append(f"wait for {waittime} ns;")
        s.append(f"end loop;")
    
    def assrt(self, **kwargs):
        self.statements.extend([f"assert {s} = '{v}';" for s,v in kwargs.items()])
    
    def render(self, template_filename, output_filename):
        env = j2.Environment()
        with open(template_filename) as template_file:
            template = env.from_string(template_file.read())
        output = template.render(sys_clk=self.sys_clk,
                                 bus_clk=self.bus_clk,
                                 testbench_name=self.tb_name,
                                 test_process='\n\t\t'.join(self.statements)) 
        with open(output_filename,'w') as output_filename:
            output_filename.write(output)

    def run(self,entity_filenames,template_filename,output_filename):
        self.render(template_filename,output_filename)
        std = '02'
        command_line = f"ghdl -a --std={std} {' '.join(map(str,entity_filenames))} {output_filename}"
        cp = run(shlex.split(command_line))
        if cp.returncode != 0:
            return cp.returncode

        command_line = f"ghdl -e --std={std} {self.tb_name}"
        cp = run(shlex.split(command_line))
        if cp.returncode != 0:
            return cp.returncode

        command_line = f"ghdl -r --std={std} {self.tb_name} --wave={self.tb_name}.ghw"
        cp = run(shlex.split(command_line),capture_output=True)
        
        return [ln for ln in cp.stdout.decode().split('\n') if 'assertion error' in ln]

class TestMissingint(unittest.TestCase):
    def setUp(self) -> None:
        return super().setUp()
        
    def tearDown(self) -> None:
        return super().tearDown()
    
    def test_clock_stretch(self):
        tb = VHDLTestBench(sys_clk=4,bus_clk=1,name='i2c_testbench_clock_stretch')
        tb.tick()
        tb.tick()
        tb.tick()
        tb.tick()
        tb.set(scl=0)
        tb.tick()
        tb.tick()
        tb.tick()
        tb.tick()
        tb.set(scl=1)
        tb.tick()
        tb.tick()
        #tb.assrt(busy=0)
        result = tb.run(['i2c.vhd'],'i2c_tb_template.vhd',tb.tb_name+'.vhd')
        self.assertTrue(len(result)==0)

def make_test_sclk_stretch():
    tb = VHDLTestBench(sys_clk=4,bus_clk=1,name='i2c_testbench_clock_stretch')
    tb.assrt(scl_clk=0,data_clk=0)
    tb.tick()
    tb.assrt(scl_clk=0,data_clk=1)
    tb.tick()
    tb.assrt(scl_clk=1,data_clk=1)
    tb.tick()
    tb.assrt(scl_clk=1,data_clk=0)
    tb.tick()
    tb.assrt(scl_clk=0,data_clk=0)
    tb.set(scl=0)
    tb.tick()
    tb.assrt(scl_clk=0,data_clk=1)
    tb.tick()
    tb.assrt(scl_clk=1,data_clk=1)
    tb.tick()
    tb.assrt(scl_clk=1,data_clk=1)
    tb.tick()
    tb.assrt(scl_clk=1,data_clk=1)
    tb.set(scl=0)
    tb.tick()
    tb.assrt(scl_clk=1,data_clk=0)
    tb.tick()
    tb.assrt(scl_clk=0,data_clk=0)
    return tb

if __name__ == '__main__':
    unittest.main()

import jinja2 as j2
import shlex,unittest,sys
from subprocess import run

class VHDLTestBench:
    def __init__(self, sys_clk, bus_clk, name):
        self.statements=[]
        self.set(clk=0,ena=0)
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
        def make_assignement(s,v):
            return f"{s} <= '{v}';" if v in [0,1] else f'{s} <= {v};'
        self.statements.extend( [make_assignement(s,v) for s,v in kwargs.items()])
    
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

    def run(self,output_filename):
        self.render(VHDLTestBench.template_filename,output_filename)
        std = '02'
        command_line = f"ghdl -a --std={std} {' '.join(map(str,VHDLTestBench.entity_filenames))} {output_filename}"
        cp = run(shlex.split(command_line))
        if cp.returncode != 0:
            return cp.returncode

        command_line = f"ghdl -e --std={std} {self.tb_name}"
        cp = run(shlex.split(command_line))
        if cp.returncode != 0:
            return cp.returncode

        command_line = f"ghdl -r --std={std} {self.tb_name} --wave={self.tb_name}.ghw"
        cp = run(shlex.split(command_line),capture_output=True)

        errors = [ln for ln in cp.stdout.decode().split('\n') if 'assertion error' in ln]
        #if len(errors) > 0:
        #    print('\n'.join(errors))
        return len(errors) == 0

class TestMissingint(unittest.TestCase):
    def setUp(self) -> None:
        return super().setUp()
        
    def tearDown(self) -> None:
        return super().tearDown()
    
    def test_clock_stretch(self):
        tb = VHDLTestBench(sys_clk=4,bus_clk=1,name='i2c_testbench_clock_stretch')
        tb.set(scl="'Z'")
        tb.tick(8)
        tb.set(scl=0)
        tb.tick(4)
        tb.set(scl="'Z'")
        tb.tick(2)
        tb.assrt(busy=0)
        result = tb.run(tb.tb_name+'.vhd')
        self.assertTrue(result)

    def test_start_condition(self):
        tb = VHDLTestBench(sys_clk=4,bus_clk=1,name='i2c_testbench_start_condition')
        tb.set(scl="'Z'")
        tb.tick(4)
        tb.set(ena=1,addr='"1010101"',rw=1)
        tb.tick(4*8)
        tb.tick(4)
        tb.assrt(sda=0, scl=1)
        result = tb.run(tb.tb_name+'.vhd')
        self.assertTrue(result)

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


# jak uruchamiać:
# -t musi być na końcu!
#  python3 i2c_test.py -- i2c.vhd
#  python3 i2c_test.py -- i2c.vhd -t i2c_tb_template.vhd
if __name__ == '__main__':
    args = []
    for i,a in enumerate(sys.argv):
        if a != '--':
            args.append(a)
        else:
            POS = i+1
            break
    VHDLTestBench.entity_filenames = []
    VHDLTestBench.template_filename = 'i2c_tb_template.vhd'
    for i in range(POS,len(sys.argv)):
        a = sys.argv[i]
        if a != '-t':
            VHDLTestBench.entity_filenames.append(sys.argv[i])
        else:
            VHDLTestBench.template_filename = sys.argv[i+1]
            break
    
    unittest.main(argv=args)

from ctypes import *

class GCD:
    @classmethod
    def Init(cls):
        cls.lib = CDLL("build/libVGCD_lib.so")
    def __init__(self):
        createModule = GCD.lib.createModule
        createModule.restype = c_void_p
        self.__dict__['m'] = createModule()
        #print("created module",self.m)
        self.__dict__['setf'] = GCD.lib.set
        self.setf.argtypes = [c_void_p, c_int, c_int]
        #print("setf initialized")        
        self.__dict__['getf'] = GCD.lib.get
        self.getf.argtypes = [c_void_p, c_int]
        self.getf.restype = c_int
        #print("getf initialized")
        self.__dict__['tickf'] = GCD.lib.tick
        self.tickf.argtypes=[c_void_p]
        #print("tickf initialized")
        self.__dict__['evalf'] = GCD.lib.eval
        self.evalf.argtypes=[c_void_p]
        #print("evalf initialized")
    
    def delete(self):
        free = GCD.lib.freeModule
        free.argtypes=[c_void_p]
        free(self.m)
    
    def __setattr__(self, name, value):
        Inputs = {  "clk"  : 0,
                    "start": 1,
                    "A"    : 2,
                    "B"    : 3 }
        self.setf(self.m, Inputs[name], value)
    
    def __getattr__(self, name):
        Outputs = {"RESULT":0, "done":1}
        return self.getf(self.m, Outputs[name])
    
    def tick(self):
        self.tickf(self.m)
    
    def eval(self):
        self.evalf(self.m)

GCD.Init()
m = GCD()
m.start=1
m.A=0
m.B=0
m.tick()
assert(m.done == 1)
assert(m.RESULT == 0)
m.delete()
print("test finished ok")
